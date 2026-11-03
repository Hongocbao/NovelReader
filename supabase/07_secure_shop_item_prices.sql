-- Gia vat pham duoc xac thuc tai server; khong tin gia do client gui len.
CREATE OR REPLACE FUNCTION public.purchase_shop_item(p_item_key TEXT, p_cost INTEGER)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  profile_row public.ho_so%ROWTYPE;
  expected_cost INTEGER;
BEGIN
  IF auth.uid() IS NULL OR NOT public.is_current_user_active() THEN
    RAISE EXCEPTION 'Active account required' USING ERRCODE = '42501';
  END IF;

  expected_cost := CASE p_item_key
    WHEN 'gold' THEN 80
    WHEN 'jade' THEN 120
    WHEN 'neon' THEN 150
    WHEN 'sepia_pro' THEN 100
    ELSE NULL
  END;
  IF expected_cost IS NULL OR p_cost IS DISTINCT FROM expected_cost THEN
    RAISE EXCEPTION 'Invalid shop purchase';
  END IF;

  PERFORM set_config('novelreader.allow_economy_update', 'true', true);
  UPDATE public.ho_so
     SET linh_thach = linh_thach - expected_cost,
         unlocked_items = CASE
           WHEN COALESCE(unlocked_items, '') = '' THEN p_item_key
           ELSE unlocked_items || ',' || p_item_key
         END
   WHERE id = auth.uid()
     AND linh_thach >= expected_cost
     AND array_position(string_to_array(COALESCE(unlocked_items, ''), ','), p_item_key) IS NULL
  RETURNING * INTO profile_row;

  IF FOUND THEN RETURN jsonb_build_object('success', true); END IF;

  SELECT * INTO profile_row FROM public.ho_so WHERE id = auth.uid();
  IF NOT FOUND THEN RAISE EXCEPTION 'Profile not found'; END IF;
  IF array_position(string_to_array(COALESCE(profile_row.unlocked_items, ''), ','), p_item_key) IS NOT NULL THEN
    RETURN jsonb_build_object('success', true, 'already_owned', true);
  END IF;
  RETURN jsonb_build_object('success', false, 'reason', 'insufficient_funds');
END;
$$;

REVOKE ALL ON FUNCTION public.purchase_shop_item(TEXT, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.purchase_shop_item(TEXT, INTEGER) TO authenticated;

NOTIFY pgrst, 'reload schema';
