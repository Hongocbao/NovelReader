-- Run after migration 10. Existing chapter IDs and content are preserved.
-- New books and appended chapters share one ID sequence, so books with more
-- than 9,999 chapters cannot collide with the next book's chapter IDs.
BEGIN;
LOCK TABLE public.chuong IN SHARE ROW EXCLUSIVE MODE;
CREATE SEQUENCE IF NOT EXISTS public.ma_chuong_seq AS BIGINT;
SELECT setval(
  'public.ma_chuong_seq',
  GREATEST(COALESCE(MAX(id), 0), (SELECT last_value FROM public.ma_chuong_seq)) + 1,
  false
) FROM public.chuong;
ALTER SEQUENCE public.ma_chuong_seq OWNED BY public.chuong.id;
ALTER TABLE public.chuong ALTER COLUMN id
  SET DEFAULT nextval('public.ma_chuong_seq');
ALTER TABLE public.chuong ADD COLUMN IF NOT EXISTS append_request_id TEXT;
CREATE UNIQUE INDEX IF NOT EXISTS uq_chuong_novel_append_request
  ON public.chuong(novel_id, append_request_id)
  WHERE append_request_id IS NOT NULL;
GRANT USAGE, SELECT ON SEQUENCE public.ma_chuong_seq TO authenticated;

CREATE OR REPLACE FUNCTION public.append_novel_chapter(
  p_novel_id BIGINT,
  p_title TEXT,
  p_content TEXT,
  p_request_id TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public, pg_temp
AS $function$
DECLARE
  v_novel public.truyen;
  v_chapter public.chuong;
  v_next_index INTEGER;
  v_title TEXT := BTRIM(COALESCE(p_title, ''), E' \t\n\r\f' || CHR(11));
  v_content TEXT := BTRIM(COALESCE(p_content, ''), E' \t\n\r\f' || CHR(11));
BEGIN
  IF auth.uid() IS NULL OR NOT public.is_current_user_active() THEN
    RAISE EXCEPTION 'Bạn cần đăng nhập bằng tài khoản đang hoạt động.'
      USING ERRCODE = '42501';
  END IF;
  IF p_novel_id IS NULL OR p_novel_id <= 0 OR v_content = '' THEN
    RAISE EXCEPTION 'Truyện và nội dung chương không hợp lệ.' USING ERRCODE = '22023';
  END IF;
  IF p_request_id IS NULL OR BTRIM(p_request_id) = '' OR LENGTH(p_request_id) > 128 THEN
    RAISE EXCEPTION 'Khóa gửi không hợp lệ.' USING ERRCODE = '22023';
  END IF;
  IF OCTET_LENGTH(v_title) + OCTET_LENGTH(v_content) > 16777216 THEN
    RAISE EXCEPTION 'Nội dung chương vượt giới hạn 16 MB.' USING ERRCODE = '22023';
  END IF;

  -- Every append to this book takes the same row lock before allocating its
  -- chapter index or checking the retry key, including concurrent retries.
  SELECT * INTO v_novel FROM public.truyen
  WHERE id = p_novel_id AND deleted_at IS NULL
  FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Không tìm thấy truyện để thêm chương.' USING ERRCODE = 'P0002';
  END IF;
  IF v_novel.owner_id IS DISTINCT FROM auth.uid()::TEXT
     AND NOT public.is_current_user_admin() THEN
    RAISE EXCEPTION 'Chỉ chủ truyện mới có thể thêm chương.' USING ERRCODE = '42501';
  END IF;

  SELECT * INTO v_chapter FROM public.chuong
  WHERE novel_id = p_novel_id AND append_request_id = p_request_id;
  IF FOUND THEN
    v_next_index := v_chapter.chapter_index;
  ELSE
    SELECT COALESCE(MAX(chapter_index), 0) + 1 INTO v_next_index
    FROM public.chuong WHERE novel_id = p_novel_id;
  END IF;
  IF v_title = '' THEN
    v_title := 'Chương ' || v_next_index;
  ELSIF LEFT(v_title, 6) <> 'Chương' THEN
    v_title := 'Chương ' || v_next_index || ': ' || v_title;
  END IF;

  IF v_chapter.id IS NOT NULL THEN
    IF v_chapter.title IS DISTINCT FROM v_title
       OR v_chapter.content IS DISTINCT FROM v_content THEN
      RAISE EXCEPTION 'Lần gửi này đã được dùng cho nội dung khác. Hãy gửi lại với mã mới.'
        USING ERRCODE = '22023';
    END IF;
    RETURN TO_JSONB(v_chapter);
  END IF;

  INSERT INTO public.chuong (
    novel_id, chapter_index, title, content, is_downloaded, append_request_id
  ) VALUES (
    p_novel_id, v_next_index, v_title, v_content, 0, p_request_id
  ) RETURNING * INTO v_chapter;

  UPDATE public.truyen SET
    total_chapters = (SELECT COUNT(*) FROM public.chuong WHERE novel_id = p_novel_id),
    updated_at = (EXTRACT(EPOCH FROM clock_timestamp()) * 1000)::BIGINT
  WHERE id = p_novel_id;

  RETURN TO_JSONB(v_chapter);
END;
$function$;
REVOKE ALL ON FUNCTION public.append_novel_chapter(BIGINT, TEXT, TEXT, TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.append_novel_chapter(BIGINT, TEXT, TEXT, TEXT) TO authenticated;

-- Chapter edits do not change chapter count/order. Update the parent's
-- timestamp in the same transaction instead of a separate client request.
CREATE OR REPLACE FUNCTION public.touch_novel_on_chapter_edit()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public, pg_temp
AS $function$
BEGIN
  IF NEW.title IS DISTINCT FROM OLD.title
     OR NEW.content IS DISTINCT FROM OLD.content
     OR NEW.publish_at IS DISTINCT FROM OLD.publish_at THEN
    UPDATE public.truyen
    SET updated_at = (EXTRACT(EPOCH FROM clock_timestamp()) * 1000)::BIGINT
    WHERE id = NEW.novel_id;
  END IF;
  RETURN NEW;
END;
$function$;
DROP TRIGGER IF EXISTS tr_chuong_touch_novel ON public.chuong;
CREATE TRIGGER tr_chuong_touch_novel
AFTER UPDATE OF title, content, publish_at ON public.chuong
FOR EACH ROW EXECUTE FUNCTION public.touch_novel_on_chapter_edit();

CREATE OR REPLACE FUNCTION public.create_novel_with_chapters(
  p_novel JSONB,
  p_chapters JSONB,
  p_request_id TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public, pg_temp
AS $function$
DECLARE
  v_novel public.truyen;
  v_owner_id TEXT;
  v_moderation_status TEXT;
  v_chapter_count INTEGER;
  v_content_bytes BIGINT;
BEGIN
  IF auth.uid() IS NULL OR NOT public.is_current_user_active() THEN
    RAISE EXCEPTION 'Bạn cần đăng nhập bằng tài khoản đang hoạt động.'
      USING ERRCODE = '42501';
  END IF;

  IF p_novel IS NULL OR jsonb_typeof(p_novel) <> 'object' THEN
    RAISE EXCEPTION 'Thông tin truyện không hợp lệ.' USING ERRCODE = '22023';
  END IF;
  IF p_chapters IS NULL OR jsonb_typeof(p_chapters) <> 'array' THEN
    RAISE EXCEPTION 'Danh sách chương không hợp lệ.' USING ERRCODE = '22023';
  END IF;
  IF p_request_id IS NULL OR BTRIM(p_request_id) = '' OR LENGTH(p_request_id) > 128 THEN
    RAISE EXCEPTION 'Khóa gửi không hợp lệ.' USING ERRCODE = '22023';
  END IF;

  v_owner_id := p_novel->>'owner_id';
  IF v_owner_id IS DISTINCT FROM auth.uid()::TEXT
     AND NOT public.is_current_user_admin() THEN
    RAISE EXCEPTION 'Không được tạo truyện thay cho tài khoản khác.'
      USING ERRCODE = '42501';
  END IF;

  v_moderation_status := COALESCE(
    NULLIF(p_novel->>'moderation_status', ''),
    'pending'
  );
  IF NOT public.is_current_user_admin() AND v_moderation_status <> 'pending' THEN
    RAISE EXCEPTION 'Truyện mới của tác giả phải chờ quản trị viên duyệt.'
      USING ERRCODE = '42501';
  END IF;
  IF v_moderation_status NOT IN ('pending', 'approved') THEN
    RAISE EXCEPTION 'Trạng thái kiểm duyệt không hợp lệ.' USING ERRCODE = '22023';
  END IF;

  IF NULLIF(BTRIM(p_novel->>'title'), '') IS NULL
     OR NULLIF(BTRIM(p_novel->>'author'), '') IS NULL THEN
    RAISE EXCEPTION 'Tên truyện và tác giả không được để trống.'
      USING ERRCODE = '22023';
  END IF;

  v_chapter_count := jsonb_array_length(p_chapters);
  IF v_chapter_count > 2000 THEN
    RAISE EXCEPTION 'Mỗi lần gửi tối đa 2.000 chương.' USING ERRCODE = '22023';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM jsonb_array_elements(p_chapters) AS chapter(value)
    WHERE jsonb_typeof(chapter.value) <> 'object'
       OR NULLIF(BTRIM(chapter.value->>'title'), '') IS NULL
  ) THEN
    RAISE EXCEPTION 'Tiêu đề chương không hợp lệ.' USING ERRCODE = '22023';
  END IF;

  SELECT COALESCE(SUM(
    OCTET_LENGTH(COALESCE(chapter.value->>'title', '')) +
    OCTET_LENGTH(COALESCE(chapter.value->>'content', ''))
  ), 0)
    INTO v_content_bytes
  FROM jsonb_array_elements(p_chapters) AS chapter(value);
  IF v_content_bytes > 16777216 THEN
    RAISE EXCEPTION 'Nội dung gửi cộng đồng vượt giới hạn 16 MB mỗi tác phẩm.'
      USING ERRCODE = '22023';
  END IF;

  INSERT INTO public.truyen (
    title, author, cover_url, description, status, type, genres,
    total_chapters, updated_at, search_text, moderation_status, owner_id,
    import_request_id
  ) VALUES (
    BTRIM(p_novel->>'title'),
    BTRIM(p_novel->>'author'),
    COALESCE(p_novel->>'cover_url', ''),
    COALESCE(p_novel->>'description', ''),
    COALESCE(NULLIF(p_novel->>'status', ''), 'ongoing'),
    COALESCE(NULLIF(p_novel->>'type', ''), 'novel'),
    COALESCE(p_novel->>'genres', ''),
    v_chapter_count,
    COALESCE(
      NULLIF(p_novel->>'updated_at', '')::BIGINT,
      (EXTRACT(EPOCH FROM clock_timestamp()) * 1000)::BIGINT
    ),
    COALESCE(p_novel->>'search_text', ''),
    v_moderation_status,
    v_owner_id,
    p_request_id
  )
  ON CONFLICT (owner_id, import_request_id)
    WHERE import_request_id IS NOT NULL
    DO NOTHING
  RETURNING * INTO v_novel;

  IF NOT FOUND THEN
    SELECT * INTO v_novel
    FROM public.truyen
    WHERE owner_id = v_owner_id
      AND import_request_id = p_request_id;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'Không xác nhận được lần gửi trước. Hãy thử lại.'
        USING ERRCODE = '40001';
    END IF;
    RETURN TO_JSONB(v_novel);
  END IF;

  INSERT INTO public.chuong (
    novel_id, chapter_index, title, content, is_downloaded
  )
  SELECT
    v_novel.id,
    chapter.ordinality::INTEGER,
    BTRIM(chapter.value->>'title'),
    COALESCE(chapter.value->>'content', ''),
    0
  FROM jsonb_array_elements(p_chapters) WITH ORDINALITY AS chapter(value, ordinality);

  RETURN TO_JSONB(v_novel);
END;
$function$;

REVOKE ALL ON FUNCTION public.create_novel_with_chapters(JSONB, JSONB, TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.create_novel_with_chapters(JSONB, JSONB, TEXT) TO authenticated;

NOTIFY pgrst, 'reload schema';
COMMIT;
