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

NOTIFY pgrst, 'reload schema';
