-- Count a novel-finished quest when a reader marks a novel as finished.
-- Run after migrations 01-11 on an existing project.

CREATE OR REPLACE FUNCTION public.advance_finished_novel_quest_progress()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  quest_row public.nhiem_vu%ROWTYPE;
  now_ms BIGINT := FLOOR(EXTRACT(EPOCH FROM now()) * 1000);
BEGIN
  IF NEW.category <> 'finished'
     OR (TG_OP = 'UPDATE' AND OLD.category = 'finished') THEN
    RETURN NEW;
  END IF;
  IF auth.uid() IS NULL OR NEW.user_id <> auth.uid()
     OR NOT public.is_current_user_active() THEN
    RAISE EXCEPTION 'Active account required' USING ERRCODE = '42501';
  END IF;

  FOR quest_row IN
    SELECT * FROM public.nhiem_vu
     WHERE goal_type = 'finish_novel' AND is_active = 1
       AND starts_at <= now_ms AND ends_at >= now_ms
  LOOP
    INSERT INTO public.nhiem_vu_nguoi_dung AS current_progress(user_id, quest_id, progress, claimed)
    VALUES (NEW.user_id, quest_row.id, 1, 0)
    ON CONFLICT (user_id, quest_id) DO UPDATE
      SET progress = LEAST(quest_row.goal_value, current_progress.progress + 1)
      WHERE current_progress.claimed = 0;
  END LOOP;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS advance_finished_novel_quest_progress_trigger ON public.tu_sach;
CREATE TRIGGER advance_finished_novel_quest_progress_trigger
AFTER INSERT OR UPDATE ON public.tu_sach
FOR EACH ROW EXECUTE FUNCTION public.advance_finished_novel_quest_progress();
REVOKE ALL ON FUNCTION public.advance_finished_novel_quest_progress() FROM PUBLIC;
