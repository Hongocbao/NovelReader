-- Chuyen cac cot user_id cu (BIGINT tu nguoi_dung demo) sang UUID cua Supabase Auth.
-- Du lieu cu duoc giu khi email trong nguoi_dung khop email ho_so; ban ghi khong
-- the gan an toan voi tai khoan Auth nao se bi xoa (hoac de NULL o cot tuy chon).
-- Database moi: chay sau 01 va 05. Database cu: chay sau 04/05, truoc khi chay lai 01.

DO $$
DECLARE
  item RECORD;
  col_type oid;
  col_number smallint;
  constraint_name text;
  optional_column boolean;
  delete_action text;
BEGIN
  FOR item IN
    SELECT * FROM (VALUES
      ('tu_sach', 'user_id', false),
      ('lich_su_doc', 'user_id', false),
      ('dau_trang', 'user_id', false),
      ('trich_dan', 'user_id', false),
      ('binh_luan', 'user_id', false),
      ('phien_doc', 'user_id', false),
      ('nhat_ky_phien_doc', 'user_id', false),
      ('thanh_tuu_nguoi_dung', 'user_id', false),
      ('nhiem_vu_nguoi_dung', 'user_id', false),
      ('bao_cao', 'reporter_id', false),
      ('bao_cao', 'handled_by', true),
      ('thong_bao_chung', 'created_by', true),
      ('thong_bao', 'user_id', true),
      ('cam_xuc_doan', 'user_id', false),
      ('hop_thoi_gian', 'user_id', false),
      ('yeu_cau_truyen', 'user_id', false),
      ('nhat_ky_quan_tri', 'admin_id', false)
    ) AS columns_to_fix(table_name, column_name, optional_column)
  LOOP
    optional_column := item.optional_column;
    delete_action := CASE WHEN optional_column THEN 'SET NULL' ELSE 'CASCADE' END;

    SELECT a.atttypid, a.attnum
      INTO col_type, col_number
      FROM pg_attribute a
      JOIN pg_class c ON c.oid = a.attrelid
      JOIN pg_namespace n ON n.oid = c.relnamespace
     WHERE n.nspname = 'public'
       AND c.relname = item.table_name
       AND a.attname = item.column_name
       AND a.attnum > 0
       AND NOT a.attisdropped;

    IF col_type IS NULL THEN
      CONTINUE;
    END IF;

    -- Bo FK cu (thuong tro vao nguoi_dung.id), de co the chuyen kieu.
    FOR constraint_name IN
      SELECT con.conname
        FROM pg_constraint con
       WHERE con.conrelid = format('public.%I', item.table_name)::regclass
         AND con.contype = 'f'
         AND col_number = ANY(con.conkey)
    LOOP
      EXECUTE format('ALTER TABLE public.%I DROP CONSTRAINT %I', item.table_name, constraint_name);
    END LOOP;

    IF col_type = 'bigint'::regtype THEN
      EXECUTE format('ALTER TABLE public.%I ALTER COLUMN %I DROP DEFAULT', item.table_name, item.column_name);

      -- Map legacy numeric account IDs to the Auth profile with the same email.
      EXECUTE format(
        'UPDATE public.%I target SET %I = profile.id::text '
        'FROM public.nguoi_dung legacy '
        'JOIN public.ho_so profile ON lower(profile.email) = lower(legacy.email) '
        'WHERE target.%I::text = legacy.id::text',
        item.table_name, item.column_name, item.column_name
      );

      IF optional_column THEN
        EXECUTE format(
          'UPDATE public.%I target SET %I = NULL '
          'WHERE target.%I IS NOT NULL AND NOT EXISTS '
          '(SELECT 1 FROM public.ho_so profile WHERE profile.id::text = target.%I::text)',
          item.table_name, item.column_name, item.column_name, item.column_name
        );
      ELSE
        EXECUTE format(
          'DELETE FROM public.%I target WHERE target.%I IS NOT NULL AND NOT EXISTS '
          '(SELECT 1 FROM public.ho_so profile WHERE profile.id::text = target.%I::text)',
          item.table_name, item.column_name, item.column_name
        );
      END IF;

      EXECUTE format(
        'ALTER TABLE public.%I ALTER COLUMN %I TYPE UUID USING NULLIF(%I::text, '''')::uuid',
        item.table_name, item.column_name, item.column_name
      );
    END IF;

    -- Dam bao moi cot UUID deu rang buoc vao tai khoan Supabase Auth.
    IF NOT EXISTS (
      SELECT 1 FROM pg_constraint con
       WHERE con.conrelid = format('public.%I', item.table_name)::regclass
         AND con.contype = 'f'
         AND col_number = ANY(con.conkey)
         AND con.confrelid = 'auth.users'::regclass
    ) THEN
      EXECUTE format(
        'ALTER TABLE public.%I ADD CONSTRAINT %I FOREIGN KEY (%I) REFERENCES auth.users(id) ON DELETE %s',
        item.table_name,
        item.table_name || '_' || item.column_name || '_auth_fkey',
        item.column_name,
        delete_action
      );
    END IF;
  END LOOP;
END $$;

-- Thong bao chung dung NULL de dai dien cho thong bao gui tat ca nguoi dung.
ALTER TABLE public.thong_bao ALTER COLUMN user_id DROP NOT NULL;

NOTIFY pgrst, 'reload schema';
