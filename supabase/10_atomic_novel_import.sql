-- Keep a submitted novel and all of its chapters in one transaction.
-- The function runs as the caller so existing RLS policies remain in force.
ALTER TABLE public.truyen
  ADD COLUMN IF NOT EXISTS import_request_id TEXT;
CREATE UNIQUE INDEX IF NOT EXISTS uq_truyen_owner_import_request
  ON public.truyen(owner_id, import_request_id)
  WHERE import_request_id IS NOT NULL;

DROP FUNCTION IF EXISTS public.create_novel_with_chapters(JSONB, JSONB);
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
    id, novel_id, chapter_index, title, content, is_downloaded
  )
  SELECT
    v_novel.id * 10000 + chapter.ordinality,
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
