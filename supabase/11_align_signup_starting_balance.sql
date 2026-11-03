-- Keep signup inserts consistent with the 150 Linh Thach shown in the app.
ALTER TABLE public.ho_so
  ALTER COLUMN linh_thach SET DEFAULT 150;

DROP POLICY IF EXISTS ho_so_insert ON public.ho_so;
CREATE POLICY ho_so_insert ON public.ho_so FOR INSERT TO authenticated
  WITH CHECK (id = auth.uid() AND role = 'user' AND is_author = 0
    AND status = 'active' AND linh_thach = 150 AND streak = 0
    AND has_streak_shield = 0 AND COALESCE(unlocked_items, 'default') = 'default');

NOTIFY pgrst, 'reload schema';
