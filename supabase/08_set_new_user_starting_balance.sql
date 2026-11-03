-- New Supabase Auth profiles start with the 150 gems promised in the UI.
ALTER TABLE public.ho_so
  ALTER COLUMN linh_thach SET DEFAULT 150;

NOTIFY pgrst, 'reload schema';
