-- =============================================================================
-- NOVELREADER DATABASE SCHEMA CHO SUPABASE (POSTGRESQL)
-- Đồ án: NovelReader (Ứng dụng Đọc truyện chữ, Light Novel & Webtoon)
-- =============================================================================

-- 1. BẢNG NGƯỜI DÙNG (users)
CREATE TABLE IF NOT EXISTS public.users (
    id BIGSERIAL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    salt TEXT NOT NULL,
    display_name TEXT NOT NULL,
    avatar TEXT NOT NULL DEFAULT '📚',
    avatar_frame TEXT NOT NULL DEFAULT 'default',
    role TEXT NOT NULL DEFAULT 'user', -- user | admin | guest
    is_author INTEGER NOT NULL DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'active', -- active | banned
    ban_reason TEXT,
    ban_until BIGINT,
    linh_thach INTEGER NOT NULL DEFAULT 100,
    streak INTEGER NOT NULL DEFAULT 0,
    has_streak_shield INTEGER NOT NULL DEFAULT 0,
    pinned_achievements TEXT DEFAULT '',
    unlocked_items TEXT DEFAULT 'default',
    secret_question TEXT DEFAULT 'Thể loại truyện yêu thích của bạn là gì?',
    secret_answer_hash TEXT DEFAULT '',
    must_change_password INTEGER NOT NULL DEFAULT 0,
    last_active_at BIGINT NOT NULL,
    created_at BIGINT NOT NULL
);

-- 2. BẢNG TRUYỆN (novels)
CREATE TABLE IF NOT EXISTS public.novels (
    id BIGINT PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    cover_url TEXT,
    description TEXT,
    status TEXT NOT NULL DEFAULT 'ongoing', -- ongoing | completed
    type TEXT NOT NULL DEFAULT 'novel', -- novel | light_novel | comic
    genres TEXT,
    total_chapters INTEGER NOT NULL DEFAULT 0,
    rating NUMERIC(3, 2) NOT NULL DEFAULT 0.0,
    views INTEGER NOT NULL DEFAULT 0,
    updated_at BIGINT NOT NULL,
    search_text TEXT,
    moderation_status TEXT NOT NULL DEFAULT 'approved', -- draft | pending | approved | rejected
    rejection_reason TEXT,
    owner_id BIGINT NOT NULL DEFAULT 1,
    is_featured INTEGER NOT NULL DEFAULT 0,
    featured_order INTEGER NOT NULL DEFAULT 0,
    deleted_at BIGINT
);

-- 3. BẢNG CHƯƠNG (chapters)
CREATE TABLE IF NOT EXISTS public.chapters (
    id BIGINT PRIMARY KEY,
    novel_id BIGINT NOT NULL REFERENCES public.novels(id) ON DELETE CASCADE,
    chapter_index INTEGER NOT NULL,
    title TEXT NOT NULL,
    content TEXT,
    is_downloaded INTEGER NOT NULL DEFAULT 0,
    publish_at BIGINT,
    CONSTRAINT uq_chapters_novel_index UNIQUE (novel_id, chapter_index)
);

-- 4. BẢNG TỦ SÁCH CÁ NHÂN (library)
CREATE TABLE IF NOT EXISTS public.library (
    user_id BIGINT NOT NULL DEFAULT 1,
    novel_id BIGINT NOT NULL REFERENCES public.novels(id) ON DELETE CASCADE,
    category TEXT NOT NULL DEFAULT 'reading', -- reading | completed | plan
    added_at BIGINT NOT NULL,
    PRIMARY KEY (user_id, novel_id)
);

-- 5. BẢNG LỊCH SỬ ĐỌC (reading_history)
CREATE TABLE IF NOT EXISTS public.reading_history (
    user_id BIGINT NOT NULL DEFAULT 1,
    novel_id BIGINT NOT NULL REFERENCES public.novels(id) ON DELETE CASCADE,
    last_chapter_id BIGINT NOT NULL,
    scroll_offset NUMERIC NOT NULL DEFAULT 0.0,
    last_read_at BIGINT NOT NULL,
    PRIMARY KEY (user_id, novel_id)
);

-- 6. BẢNG DẤU TRANG (bookmarks)
CREATE TABLE IF NOT EXISTS public.bookmarks (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL DEFAULT 1,
    novel_id BIGINT NOT NULL REFERENCES public.novels(id) ON DELETE CASCADE,
    chapter_id BIGINT NOT NULL REFERENCES public.chapters(id) ON DELETE CASCADE,
    scroll_offset NUMERIC NOT NULL DEFAULT 0.0,
    note TEXT,
    created_at BIGINT NOT NULL
);

-- 7. BẢNG TRÍCH DẪN YÊU THÍCH (quotes)
CREATE TABLE IF NOT EXISTS public.quotes (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL DEFAULT 1,
    novel_id BIGINT NOT NULL,
    novel_title TEXT NOT NULL,
    author TEXT NOT NULL,
    chapter_title TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at BIGINT NOT NULL
);

-- 8. BẢNG BÌNH LUẬN (comments)
CREATE TABLE IF NOT EXISTS public.comments (
    id BIGSERIAL PRIMARY KEY,
    novel_id BIGINT NOT NULL REFERENCES public.novels(id) ON DELETE CASCADE,
    chapter_id BIGINT NOT NULL,
    chapter_index INTEGER NOT NULL DEFAULT 1,
    user_id BIGINT NOT NULL DEFAULT 0,
    user_name TEXT NOT NULL,
    content TEXT NOT NULL,
    stars INTEGER NOT NULL DEFAULT 5,
    is_hidden INTEGER NOT NULL DEFAULT 0,
    likes INTEGER NOT NULL DEFAULT 0,
    parent_id BIGINT,
    created_at BIGINT NOT NULL
);

-- 9. BẢNG THỐNG KÊ PHIÊN ĐỌC THEO NGÀY (reading_sessions)
CREATE TABLE IF NOT EXISTS public.reading_sessions (
    user_id BIGINT NOT NULL DEFAULT 1,
    date_key TEXT NOT NULL,
    words_read INTEGER NOT NULL DEFAULT 0,
    minutes_read INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, date_key)
);

-- 10. BẢNG NHẬT KÝ PHIÊN ĐỌC CHI TIẾT (reading_session_logs)
CREATE TABLE IF NOT EXISTS public.reading_session_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL DEFAULT 0,
    novel_id BIGINT NOT NULL DEFAULT 0,
    chapter_id BIGINT NOT NULL DEFAULT 0,
    started_at BIGINT NOT NULL,
    ended_at BIGINT NOT NULL,
    words_read INTEGER NOT NULL DEFAULT 0,
    hour_of_day INTEGER NOT NULL DEFAULT 0
);

-- 11. BẢNG HUY HIỆU THÀNH TỰU (achievements)
CREATE TABLE IF NOT EXISTS public.achievements (
    code TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    icon TEXT NOT NULL,
    rule_json TEXT NOT NULL DEFAULT '{}'
);

-- 12. BẢNG HUY HIỆU NGƯỜI DÙNG (user_achievements)
CREATE TABLE IF NOT EXISTS public.user_achievements (
    user_id BIGINT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    code TEXT NOT NULL REFERENCES public.achievements(code) ON DELETE CASCADE,
    unlocked_at BIGINT NOT NULL,
    PRIMARY KEY (user_id, code)
);

-- 13. BẢNG NHIỆM VỤ (quests)
CREATE TABLE IF NOT EXISTS public.quests (
    id BIGSERIAL PRIMARY KEY,
    type TEXT NOT NULL, -- daily | weekly | event
    title TEXT NOT NULL,
    goal_type TEXT NOT NULL,
    goal_value INTEGER NOT NULL,
    reward INTEGER NOT NULL,
    starts_at BIGINT NOT NULL,
    ends_at BIGINT NOT NULL,
    is_active INTEGER NOT NULL DEFAULT 1
);

-- 14. BẢNG TIẾN ĐỘ NHIỆM VỤ NGƯỜI DÙNG (user_quests)
CREATE TABLE IF NOT EXISTS public.user_quests (
    user_id BIGINT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    quest_id BIGINT NOT NULL REFERENCES public.quests(id) ON DELETE CASCADE,
    progress INTEGER NOT NULL DEFAULT 0,
    claimed INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, quest_id)
);

-- 15. BẢNG BÁO CÁO VI PHẠM (reports)
CREATE TABLE IF NOT EXISTS public.reports (
    id BIGSERIAL PRIMARY KEY,
    reporter_id BIGINT NOT NULL,
    reporter_name TEXT NOT NULL DEFAULT 'Độc giả',
    target_type TEXT NOT NULL, -- novel | chapter | comment
    target_id BIGINT NOT NULL,
    target_snapshot TEXT DEFAULT '',
    reason TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'open', -- open | resolved | dismissed
    handled_by BIGINT,
    resolution_note TEXT,
    created_at BIGINT NOT NULL
);

-- 16. BẢNG THÔNG BÁO BAN QUẢN TRỊ (announcements)
CREATE TABLE IF NOT EXISTS public.announcements (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    audience TEXT NOT NULL DEFAULT 'all',
    pinned INTEGER NOT NULL DEFAULT 0,
    created_by BIGINT NOT NULL DEFAULT 1,
    created_at BIGINT NOT NULL
);

-- 17. BẢNG THÔNG BÁO CÁ NHÂN (notifications)
CREATE TABLE IF NOT EXISTS public.notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    kind TEXT NOT NULL DEFAULT 'system',
    is_read INTEGER NOT NULL DEFAULT 0,
    created_at BIGINT NOT NULL
);

-- 18. BẢNG THUẬT NGỮ TRUYỆN (glossary_terms)
CREATE TABLE IF NOT EXISTS public.glossary_terms (
    id BIGSERIAL PRIMARY KEY,
    novel_id BIGINT NOT NULL REFERENCES public.novels(id) ON DELETE CASCADE,
    term TEXT NOT NULL,
    meaning TEXT NOT NULL,
    first_chapter_index INTEGER NOT NULL DEFAULT 1
);

-- 19. BẢNG TÓM TẮT CHƯƠNG (chapter_summaries)
CREATE TABLE IF NOT EXISTS public.chapter_summaries (
    chapter_id BIGINT PRIMARY KEY,
    novel_id BIGINT NOT NULL REFERENCES public.novels(id) ON DELETE CASCADE,
    chapter_index INTEGER NOT NULL DEFAULT 1,
    summary TEXT NOT NULL
);

-- 20. BẢNG CẢM XÚC ĐOẠN VĂN (paragraph_reactions)
CREATE TABLE IF NOT EXISTS public.paragraph_reactions (
    user_id BIGINT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    chapter_id BIGINT NOT NULL REFERENCES public.chapters(id) ON DELETE CASCADE,
    paragraph_index INTEGER NOT NULL,
    emoji TEXT NOT NULL,
    PRIMARY KEY (user_id, chapter_id, paragraph_index)
);

-- 21. BẢNG HỘP THƯ THỜI GIAN (time_capsules)
CREATE TABLE IF NOT EXISTS public.time_capsules (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    novel_id BIGINT NOT NULL REFERENCES public.novels(id) ON DELETE CASCADE,
    chapter_id BIGINT NOT NULL REFERENCES public.chapters(id) ON DELETE CASCADE,
    note TEXT NOT NULL,
    unlock_after_days INTEGER NOT NULL DEFAULT 30,
    created_at BIGINT NOT NULL
);

-- 22. BẢNG YÊU CẦU THÊM TRUYỆN (novel_requests)
CREATE TABLE IF NOT EXISTS public.novel_requests (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    user_name TEXT NOT NULL,
    title TEXT NOT NULL,
    author_hint TEXT DEFAULT '',
    description TEXT DEFAULT '',
    votes INTEGER NOT NULL DEFAULT 1,
    created_at BIGINT NOT NULL
);

-- 23. BẢNG SƠ ĐỒ QUAN HỆ NHÂN VẬT (character_graphs)
CREATE TABLE IF NOT EXISTS public.character_graphs (
    novel_id BIGINT PRIMARY KEY REFERENCES public.novels(id) ON DELETE CASCADE,
    graph_json TEXT NOT NULL
);

-- 24. BẢNG TỪ KHÓA BỊ CẤM / KIỂM DUYỆT (banned_words)
CREATE TABLE IF NOT EXISTS public.banned_words (
    word TEXT PRIMARY KEY
);

-- 25. BẢNG NHẬT KÝ THAO TÁC QUẢN TRỊ (audit_logs)
CREATE TABLE IF NOT EXISTS public.audit_logs (
    id BIGSERIAL PRIMARY KEY,
    admin_id BIGINT NOT NULL,
    admin_name TEXT NOT NULL DEFAULT 'Admin',
    action TEXT NOT NULL,
    target TEXT NOT NULL,
    detail TEXT NOT NULL,
    created_at BIGINT NOT NULL
);

-- 26. BẢNG CẤU HÌNH HỆ THỐNG (app_config)
CREATE TABLE IF NOT EXISTS public.app_config (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);

-- =============================================================================
-- CHỈ MỤC TỐI ƯU TRUY VẤN (INDEXES)
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_chapters_novel_idx ON public.chapters(novel_id, chapter_index);
CREATE INDEX IF NOT EXISTS idx_novels_status_type ON public.novels(status, type);
CREATE INDEX IF NOT EXISTS idx_novels_views ON public.novels(views DESC);
CREATE INDEX IF NOT EXISTS idx_novels_rating ON public.novels(rating DESC);
CREATE INDEX IF NOT EXISTS idx_novels_updated ON public.novels(updated_at DESC);
CREATE INDEX IF NOT EXISTS idx_comments_chapter ON public.comments(novel_id, chapter_id);
CREATE INDEX IF NOT EXISTS idx_reading_history_user ON public.reading_history(user_id, last_read_at DESC);
CREATE INDEX IF NOT EXISTS idx_bookmarks_user ON public.bookmarks(user_id, novel_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON public.notifications(user_id, is_read);

-- =============================================================================
-- BẬT ROW LEVEL SECURITY (RLS) VÀ CẤP QUYỀN TRUY CẬP CHO ANON / AUTHENTICATED
-- =============================================================================
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.novels ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chapters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.library ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reading_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookmarks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reading_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reading_session_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_quests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.glossary_terms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chapter_summaries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.paragraph_reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.time_capsules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.novel_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.character_graphs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.banned_words ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_config ENABLE ROW LEVEL SECURITY;

-- Cấp quyền đọc/ghi công khai cho mục đích demo / đồ án sinh viên
-- (Cho phép anon và authenticated truy cập đầy đủ)
DO $$
DECLARE
    t text;
BEGIN
    FOR t IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
          AND table_type = 'BASE TABLE'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS "Public full access" ON public.%I', t);
        EXECUTE format('CREATE POLICY "Public full access" ON public.%I FOR ALL USING (true) WITH CHECK (true)', t);
        EXECUTE format('GRANT ALL ON public.%I TO anon, authenticated, service_role', t);
    END LOOP;
END $$;
