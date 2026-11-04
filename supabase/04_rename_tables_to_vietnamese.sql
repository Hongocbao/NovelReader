-- Run once against an existing Supabase project to rename the English tables.
-- Table contents and foreign key relationships are preserved by PostgreSQL.
DO $$
DECLARE
  item RECORD;
BEGIN
  FOR item IN
    SELECT * FROM (VALUES
      ('users', 'nguoi_dung'),
      ('novels', 'truyen'),
      ('chapters', 'chuong'),
      ('library', 'tu_sach'),
      ('reading_history', 'lich_su_doc'),
      ('bookmarks', 'dau_trang'),
      ('quotes', 'trich_dan'),
      ('comments', 'binh_luan'),
      ('reading_sessions', 'phien_doc'),
      ('reading_session_logs', 'nhat_ky_phien_doc'),
      ('achievements', 'thanh_tuu'),
      ('user_achievements', 'thanh_tuu_nguoi_dung'),
      ('quests', 'nhiem_vu'),
      ('user_quests', 'nhiem_vu_nguoi_dung'),
      ('reports', 'bao_cao'),
      ('announcements', 'thong_bao_chung'),
      ('notifications', 'thong_bao'),
      ('glossary_terms', 'thuat_ngu'),
      ('chapter_summaries', 'tom_tat_chuong'),
      ('paragraph_reactions', 'cam_xuc_doan'),
      ('time_capsules', 'hop_thoi_gian'),
      ('novel_requests', 'yeu_cau_truyen'),
      ('character_graphs', 'so_do_nhan_vat'),
      ('banned_words', 'tu_cam'),
      ('audit_logs', 'nhat_ky_quan_tri'),
      ('app_config', 'cau_hinh_ung_dung'),
      ('profiles', 'ho_so'),
      ('ratings', 'danh_gia')
    ) AS names(old_name, new_name)
  LOOP
    IF to_regclass(format('public.%I', item.old_name)) IS NOT NULL
       AND to_regclass(format('public.%I', item.new_name)) IS NULL THEN
      EXECUTE format(
        'ALTER TABLE public.%I RENAME TO %I',
        item.old_name,
        item.new_name
      );
    END IF;
  END LOOP;
END $$;

-- These tables are used by Supabase Auth and rating flows in the Flutter app.
CREATE TABLE IF NOT EXISTS public.ho_so (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  display_name TEXT NOT NULL,
  avatar TEXT NOT NULL DEFAULT '📚',
  avatar_frame TEXT NOT NULL DEFAULT 'default',
  role TEXT NOT NULL DEFAULT 'user',
  is_author INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'active',
  ban_reason TEXT,
  ban_until BIGINT,
  linh_thach INTEGER NOT NULL DEFAULT 100,
  streak INTEGER NOT NULL DEFAULT 0,
  has_streak_shield INTEGER NOT NULL DEFAULT 0,
  pinned_achievements TEXT DEFAULT '',
  unlocked_items TEXT DEFAULT 'default',
  last_active_at BIGINT NOT NULL DEFAULT 0,
  created_at BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS public.danh_gia (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  novel_id BIGINT NOT NULL REFERENCES public.truyen(id) ON DELETE CASCADE,
  stars SMALLINT NOT NULL CHECK (stars BETWEEN 1 AND 5),
  PRIMARY KEY (user_id, novel_id)
);

CREATE TABLE IF NOT EXISTS public.yeu_cau_binh_chon (
  request_id BIGINT NOT NULL REFERENCES public.yeu_cau_truyen(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at BIGINT NOT NULL,
  PRIMARY KEY (request_id, user_id)
);

-- Trigger tu dong cap nhat binh chon yeu cau truyen
CREATE OR REPLACE FUNCTION public.refresh_novel_request_votes()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.yeu_cau_truyen SET votes = votes + 1 WHERE id = NEW.request_id;
    RETURN NEW;
  END IF;
  UPDATE public.yeu_cau_truyen SET votes = GREATEST(0, votes - 1) WHERE id = OLD.request_id;
  RETURN OLD;
END;
$$;

DROP TRIGGER IF EXISTS refresh_novel_request_votes_trigger ON public.yeu_cau_binh_chon;
CREATE TRIGGER refresh_novel_request_votes_trigger
AFTER INSERT OR DELETE ON public.yeu_cau_binh_chon
FOR EACH ROW EXECUTE FUNCTION public.refresh_novel_request_votes();

-- =============================================================================
-- CAP NHAT TOAN BO HAM (FUNCTIONS), TRIGGER VA RLS POLICIES SANG TEN TIENG VIET
-- Khac phuc triet de loi: relation "public.profiles" does not exist (42P01)
-- =============================================================================

CREATE OR REPLACE FUNCTION public.is_current_user_admin()
RETURNS BOOLEAN
LANGUAGE SQL
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.ho_so
    WHERE id = auth.uid() AND role = 'admin' AND status = 'active'
  );
$$;

REVOKE ALL ON FUNCTION public.is_current_user_admin() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_current_user_admin() TO anon, authenticated;

CREATE OR REPLACE FUNCTION public.is_current_user_active()
RETURNS BOOLEAN
LANGUAGE SQL
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.ho_so
    WHERE id = auth.uid() AND (
      status = 'active'
      OR (status = 'banned' AND ban_until IS NOT NULL
          AND ban_until <= FLOOR(EXTRACT(EPOCH FROM now()) * 1000))
    )
  );
$$;

REVOKE ALL ON FUNCTION public.is_current_user_active() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_current_user_active() TO authenticated;

-- Xoa moi trigger cu tren public.ho_so (tranh trigger cu con goi ham tro vao public.profiles)
DO $$
DECLARE
  tr RECORD;
BEGIN
  FOR tr IN
    SELECT tgname
    FROM pg_trigger
    WHERE tgrelid = 'public.ho_so'::regclass
      AND NOT tgisinternal
  LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS %I ON public.ho_so', tr.tgname);
  END LOOP;
END $$;

CREATE OR REPLACE FUNCTION public.protect_profile_privileges()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF OLD.id = auth.uid() AND NOT public.is_current_user_admin() THEN
    NEW.role := OLD.role;
    NEW.status := OLD.status;
    NEW.is_author := OLD.is_author;
    NEW.ban_reason := OLD.ban_reason;
    NEW.ban_until := OLD.ban_until;
    IF current_setting('novelreader.allow_economy_update', true) IS DISTINCT FROM 'true' THEN
      NEW.linh_thach := OLD.linh_thach;
      NEW.streak := OLD.streak;
      NEW.has_streak_shield := OLD.has_streak_shield;
      NEW.unlocked_items := OLD.unlocked_items;
    END IF;
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER protect_profile_privileges_trigger
BEFORE UPDATE ON public.ho_so
FOR EACH ROW EXECUTE FUNCTION public.protect_profile_privileges();

-- Tu dong chuyen moi ham cu (vd handle_new_user tren auth.users) con tham chieu public.profiles sang public.ho_so
DO $$
DECLARE
  fn RECORD;
  fn_def TEXT;
BEGIN
  FOR fn IN
    SELECT p.oid
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.prosrc ILIKE '%profiles%'
  LOOP
    fn_def := pg_get_functiondef(fn.oid);
    fn_def := replace(fn_def, 'public.profiles', 'public.ho_so');
    fn_def := replace(fn_def, 'INTO profiles', 'INTO public.ho_so');
    fn_def := replace(fn_def, 'FROM profiles', 'FROM public.ho_so');
    fn_def := replace(fn_def, 'UPDATE profiles', 'UPDATE public.ho_so');
    EXECUTE fn_def;
  END LOOP;
END $$;

-- Tao VIEW tuong thich nguoc public.profiles -> public.ho_so (auto-updatable trong PostgreSQL)
-- Phong truong hop bat ky trigger hay webhook nao van goi public.profiles
DO $$
BEGIN
  IF to_regclass('public.profiles') IS NULL THEN
    EXECUTE 'CREATE VIEW public.profiles AS SELECT * FROM public.ho_so';
    EXECUTE 'GRANT ALL ON public.profiles TO anon, authenticated, service_role';
  END IF;
END $$;

-- Cap nhat RLS policies tren bang public.ho_so va public.nhat_ky_quan_tri
ALTER TABLE public.ho_so ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE
  pol RECORD;
BEGIN
  FOR pol IN
    SELECT policyname FROM pg_policies WHERE schemaname = 'public' AND tablename = 'ho_so'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.ho_so', pol.policyname);
  END LOOP;
END $$;

GRANT ALL ON public.ho_so TO anon, authenticated, service_role;

CREATE POLICY ho_so_read ON public.ho_so FOR SELECT TO authenticated
  USING (id = auth.uid() OR public.is_current_user_admin());

CREATE POLICY ho_so_insert ON public.ho_so FOR INSERT TO authenticated
  WITH CHECK (id = auth.uid());

CREATE POLICY ho_so_update ON public.ho_so FOR UPDATE TO authenticated
  USING ((id = auth.uid() AND public.is_current_user_active()) OR public.is_current_user_admin())
  WITH CHECK ((id = auth.uid() AND public.is_current_user_active()) OR public.is_current_user_admin());

DO $$
DECLARE
  pol RECORD;
BEGIN
  IF to_regclass('public.nhat_ky_quan_tri') IS NOT NULL THEN
    ALTER TABLE public.nhat_ky_quan_tri ENABLE ROW LEVEL SECURITY;
    FOR pol IN
      SELECT policyname FROM pg_policies WHERE schemaname = 'public' AND tablename = 'nhat_ky_quan_tri'
    LOOP
      EXECUTE format('DROP POLICY IF EXISTS %I ON public.nhat_ky_quan_tri', pol.policyname);
    END LOOP;
    GRANT ALL ON public.nhat_ky_quan_tri TO anon, authenticated, service_role;
    EXECUTE 'CREATE POLICY nhat_ky_quan_tri_admin_read ON public.nhat_ky_quan_tri FOR SELECT TO authenticated USING (public.is_current_user_admin())';
    EXECUTE 'CREATE POLICY nhat_ky_quan_tri_admin_insert ON public.nhat_ky_quan_tri FOR INSERT TO authenticated WITH CHECK (admin_id = auth.uid() AND public.is_current_user_admin())';
  END IF;
END $$;

-- Xoa truyen tranh (chi giu truyen chu & light novel)
DELETE FROM public.truyen WHERE type = 'comic';

-- Cap nhat ten hien thi co dau cho 3 tai khoan mau
UPDATE public.nguoi_dung SET display_name = 'Quản Trị Viên Tối Cao' WHERE id = 1;
UPDATE public.nguoi_dung SET display_name = 'Bút Mặc Tiên Sinh' WHERE id = 2;
UPDATE public.nguoi_dung SET display_name = 'Bảo Ngọc Độc Giả' WHERE id = 3;

-- Ham ho tro Admin dat lai mat khau truc tiep cho tai khoan (neu co pgcrypto)
CREATE OR REPLACE FUNCTION public.admin_reset_user_password(
  p_email TEXT,
  p_new_password TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth, extensions, pg_temp
AS $$
BEGIN
  IF NOT public.is_current_user_admin() THEN
    RAISE EXCEPTION 'Chỉ Quản trị viên mới có quyền đặt lại mật khẩu.' USING ERRCODE = '42501';
  END IF;
  UPDATE auth.users
  SET encrypted_password = crypt(p_new_password, gen_salt('bf')),
      updated_at = NOW()
  WHERE LOWER(email) = LOWER(BTRIM(p_email));
  RETURN FOUND;
END;
$$;

GRANT EXECUTE ON FUNCTION public.admin_reset_user_password(TEXT, TEXT) TO authenticated;

-- Dong bo sequence id cua bang truyen de tranh trung khoa chinh khi tao truyen moi
SELECT setval(
  pg_get_serial_sequence('public.truyen', 'id'),
  GREATEST((SELECT COALESCE(MAX(id), 1) FROM public.truyen), 1),
  true
);

NOTIFY pgrst, 'reload schema';
