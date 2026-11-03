-- Repair schemas created before truyen.id generated its own IDs and before
-- owner_id was aligned with Supabase Auth UUIDs.
DO $$
DECLARE
  id_is_identity BOOLEAN;
  owner_type TEXT;
BEGIN
  SELECT is_identity = 'YES'
    INTO id_is_identity
    FROM information_schema.columns
   WHERE table_schema = 'public'
     AND table_name = 'truyen'
     AND column_name = 'id';

  IF id_is_identity IS DISTINCT FROM TRUE THEN
    CREATE SEQUENCE IF NOT EXISTS public.truyen_id_seq;
    ALTER SEQUENCE public.truyen_id_seq OWNED BY public.truyen.id;
    ALTER TABLE public.truyen
      ALTER COLUMN id SET DEFAULT nextval('public.truyen_id_seq');
    PERFORM setval(
      'public.truyen_id_seq',
      GREATEST(COALESCE((SELECT MAX(id) FROM public.truyen), 0) + 1, 1),
      false
    );
  END IF;

  SELECT data_type
    INTO owner_type
    FROM information_schema.columns
   WHERE table_schema = 'public'
     AND table_name = 'truyen'
     AND column_name = 'owner_id';

  IF owner_type IS NOT NULL AND owner_type <> 'text' THEN
    ALTER TABLE public.truyen
      ALTER COLUMN owner_id DROP DEFAULT;
    ALTER TABLE public.truyen
      ALTER COLUMN owner_id TYPE TEXT USING owner_id::TEXT;
    ALTER TABLE public.truyen
      ALTER COLUMN owner_id SET DEFAULT '1';
  END IF;
END $$;

-- Manual IDs in the seed file must not cause future inserts to reuse an ID.
DO $$
BEGIN
  IF to_regclass('public.truyen_id_seq') IS NOT NULL THEN
    PERFORM setval(
      'public.truyen_id_seq',
      GREATEST(COALESCE((SELECT MAX(id) FROM public.truyen), 0) + 1, 1),
      false
    );
  END IF;
END $$;

NOTIFY pgrst, 'reload schema';
