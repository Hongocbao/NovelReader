-- Apply after migration 13. Reordering and appending lock the same book row.
BEGIN;
CREATE OR REPLACE FUNCTION public.reorder_novel_chapters(
  p_novel_id BIGINT,
  p_chapter_ids BIGINT[],
  p_expected_ids BIGINT[]
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public, pg_temp
AS $function$
DECLARE
  v_novel public.truyen;
  v_current BIGINT[];
  v_count INTEGER;
  v_stage_base BIGINT;
BEGIN
  IF auth.uid() IS NULL OR NOT public.is_current_user_active() THEN
    RAISE EXCEPTION 'Bạn cần đăng nhập bằng tài khoản đang hoạt động.' USING ERRCODE = '42501';
  END IF;
  IF p_novel_id IS NULL OR p_novel_id <= 0
     OR p_chapter_ids IS NULL OR p_expected_ids IS NULL
     OR COALESCE(array_ndims(p_chapter_ids), 1) <> 1
     OR COALESCE(array_ndims(p_expected_ids), 1) <> 1
     OR EXISTS (SELECT 1 FROM unnest(p_chapter_ids || p_expected_ids) AS x(id) WHERE id IS NULL OR id <= 0)
     OR (SELECT COUNT(DISTINCT id) FROM unnest(p_chapter_ids) AS x(id)) <> cardinality(p_chapter_ids)
     OR (SELECT COUNT(DISTINCT id) FROM unnest(p_expected_ids) AS x(id)) <> cardinality(p_expected_ids) THEN
    RAISE EXCEPTION 'Danh sách chương không hợp lệ.' USING ERRCODE = '22023';
  END IF;

  SELECT * INTO v_novel FROM public.truyen
  WHERE id = p_novel_id AND deleted_at IS NULL FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Không tìm thấy truyện để đổi thứ tự chương.' USING ERRCODE = 'P0002';
  END IF;
  IF v_novel.owner_id IS DISTINCT FROM auth.uid()::TEXT
     AND NOT public.is_current_user_admin() THEN
    RAISE EXCEPTION 'Chỉ chủ truyện mới có thể đổi thứ tự chương.' USING ERRCODE = '42501';
  END IF;

  SELECT COALESCE(array_agg(id ORDER BY chapter_index), ARRAY[]::BIGINT[]), COUNT(*)
  INTO v_current, v_count FROM public.chuong WHERE novel_id = p_novel_id;
  IF cardinality(p_chapter_ids) <> v_count OR cardinality(p_expected_ids) <> v_count
     OR NOT (p_chapter_ids <@ v_current) OR NOT (p_expected_ids <@ v_current) THEN
    RAISE EXCEPTION 'Danh sách chương đã thay đổi. Hãy tải lại trước khi sắp xếp.' USING ERRCODE = '40001';
  END IF;
  -- A retry after a lost response must not rotate the order/spoiler indexes again.
  IF v_current = p_chapter_ids THEN RETURN TRUE; END IF;
  IF v_current <> p_expected_ids THEN
    RAISE EXCEPTION 'Thứ tự chương đã thay đổi ở lần sửa khác. Hãy tải lại trước khi sắp xếp.' USING ERRCODE = '40001';
  END IF;

  -- Keep first appearances attached to the same chapters, before staging indexes.
  WITH positions AS (
    SELECT c.chapter_index AS old_index, desired.ordinality::INTEGER AS new_index
    FROM unnest(p_chapter_ids) WITH ORDINALITY AS desired(id, ordinality)
    JOIN public.chuong c ON c.id = desired.id AND c.novel_id = p_novel_id
  )
  UPDATE public.thuat_ngu g SET first_chapter_index = positions.new_index
  FROM positions WHERE g.novel_id = p_novel_id AND g.first_chapter_index = positions.old_index;

  -- Use temporary indexes below every existing index; this also handles gaps
  -- and old interrupted reorders without colliding with the UNIQUE constraint.
  SELECT LEAST(COALESCE(MIN(chapter_index), 0), 0)::BIGINT - v_count
  INTO v_stage_base FROM public.chuong WHERE novel_id = p_novel_id;
  UPDATE public.chuong c SET chapter_index = v_stage_base - desired.ordinality
  FROM unnest(p_chapter_ids) WITH ORDINALITY AS desired(id, ordinality)
  WHERE c.novel_id = p_novel_id AND c.id = desired.id;
  UPDATE public.chuong c SET chapter_index = desired.ordinality::INTEGER
  FROM unnest(p_chapter_ids) WITH ORDINALITY AS desired(id, ordinality)
  WHERE c.novel_id = p_novel_id AND c.id = desired.id;

  UPDATE public.tom_tat_chuong s SET chapter_index = c.chapter_index
  FROM public.chuong c
  WHERE s.novel_id = p_novel_id AND c.novel_id = p_novel_id AND s.chapter_id = c.id;
  UPDATE public.truyen SET total_chapters = v_count,
    updated_at = (EXTRACT(EPOCH FROM clock_timestamp()) * 1000)::BIGINT
  WHERE id = p_novel_id;
  RETURN TRUE;
END;
$function$;
REVOKE ALL ON FUNCTION public.reorder_novel_chapters(BIGINT, BIGINT[], BIGINT[]) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.reorder_novel_chapters(BIGINT, BIGINT[], BIGINT[]) TO authenticated;
NOTIFY pgrst, 'reload schema';
COMMIT;
