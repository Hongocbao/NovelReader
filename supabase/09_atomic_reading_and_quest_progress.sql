-- Atomic reading statistics plus server-owned quest progress.
-- Run after migrations 05-08 on an existing project.

CREATE OR REPLACE FUNCTION public.record_reading_session(
  p_words_read INTEGER,
  p_minutes_read INTEGER,
  p_novel_id BIGINT,
  p_chapter_id BIGINT,
  p_date_key TEXT,
  p_hour_of_day INTEGER
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  uid UUID := auth.uid();
  now_ms BIGINT := FLOOR(EXTRACT(EPOCH FROM now()) * 1000);
  existing_row public.phien_doc%ROWTYPE;
  accepted_words INTEGER;
  accepted_minutes INTEGER;
  quest_row public.nhiem_vu%ROWTYPE;
BEGIN
  IF uid IS NULL OR NOT public.is_current_user_active() THEN
    RAISE EXCEPTION 'Active account required' USING ERRCODE = '42501';
  END IF;
  IF p_words_read IS NULL OR p_words_read < 0 OR p_words_read > 100000
     OR p_minutes_read IS NULL OR p_minutes_read < 0 OR p_minutes_read > 120
     OR p_novel_id IS NULL OR p_chapter_id IS NULL
     OR p_date_key IS NULL OR p_date_key !~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
     OR p_hour_of_day IS NULL OR p_hour_of_day < 0 OR p_hour_of_day > 23
     OR (p_words_read = 0 AND p_minutes_read = 0) THEN
    RAISE EXCEPTION 'Invalid reading session';
  END IF;

  -- Serialize updates for this user's local-day key, so concurrent devices
  -- cannot overwrite one another or pass the daily cap at the same time.
  PERFORM pg_advisory_xact_lock(hashtextextended(uid::TEXT || ':' || p_date_key, 0));
  SELECT * INTO existing_row FROM public.phien_doc
   WHERE user_id = uid AND date_key = p_date_key;
  accepted_minutes := LEAST(p_minutes_read, GREATEST(0, 720 - COALESCE(existing_row.minutes_read, 0)));
  accepted_words := LEAST(p_words_read, GREATEST(0, 200000 - COALESCE(existing_row.words_read, 0)));
  IF accepted_minutes = 0 AND accepted_words = 0 THEN RETURN; END IF;

  INSERT INTO public.phien_doc(user_id, date_key, words_read, minutes_read)
  VALUES (uid, p_date_key, accepted_words, accepted_minutes)
  ON CONFLICT (user_id, date_key) DO UPDATE
    SET words_read = public.phien_doc.words_read + EXCLUDED.words_read,
        minutes_read = public.phien_doc.minutes_read + EXCLUDED.minutes_read;

  -- A chapter counts once during a quest's active window, even across sessions.
  IF p_novel_id > 0 AND p_chapter_id > 0 THEN
    PERFORM pg_advisory_xact_lock(hashtextextended(
      uid::TEXT || ':chapter:' || p_novel_id::TEXT || ':' || p_chapter_id::TEXT, 0
    ));
    FOR quest_row IN
      SELECT * FROM public.nhiem_vu
       WHERE goal_type = 'read_chapters' AND is_active = 1
         AND starts_at <= now_ms AND ends_at >= now_ms
    LOOP
      IF NOT EXISTS (
        SELECT 1 FROM public.nhat_ky_phien_doc log
         WHERE log.user_id = uid AND log.novel_id = p_novel_id
           AND log.chapter_id = p_chapter_id
           AND log.ended_at >= quest_row.starts_at AND log.ended_at <= quest_row.ends_at
      ) THEN
        INSERT INTO public.nhiem_vu_nguoi_dung AS current_progress(user_id, quest_id, progress, claimed)
        VALUES (uid, quest_row.id, 1, 0)
        ON CONFLICT (user_id, quest_id) DO UPDATE
          SET progress = LEAST(quest_row.goal_value, current_progress.progress + 1)
          WHERE current_progress.claimed = 0;
      END IF;
    END LOOP;
  END IF;

  INSERT INTO public.nhat_ky_phien_doc(
    user_id, novel_id, chapter_id, started_at, ended_at, words_read, hour_of_day
  ) VALUES (
    uid, p_novel_id, p_chapter_id,
    now_ms - accepted_minutes::BIGINT * 60000, now_ms, accepted_words, p_hour_of_day
  );

  IF accepted_minutes > 0 THEN
    FOR quest_row IN
      SELECT * FROM public.nhiem_vu
       WHERE goal_type = 'read_minutes' AND is_active = 1
         AND starts_at <= now_ms AND ends_at >= now_ms
    LOOP
      INSERT INTO public.nhiem_vu_nguoi_dung AS current_progress(user_id, quest_id, progress, claimed)
      VALUES (uid, quest_row.id, LEAST(accepted_minutes, quest_row.goal_value), 0)
      ON CONFLICT (user_id, quest_id) DO UPDATE
        SET progress = LEAST(quest_row.goal_value,
          current_progress.progress + EXCLUDED.progress)
        WHERE current_progress.claimed = 0;
    END LOOP;
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.advance_comment_quest_progress()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  quest_row public.nhiem_vu%ROWTYPE;
  now_ms BIGINT := FLOOR(EXTRACT(EPOCH FROM now()) * 1000);
BEGIN
  IF auth.uid() IS NULL OR NEW.user_id <> auth.uid()
     OR NOT public.is_current_user_active() THEN
    RAISE EXCEPTION 'Active account required' USING ERRCODE = '42501';
  END IF;
  FOR quest_row IN
    SELECT * FROM public.nhiem_vu
     WHERE goal_type = 'comment' AND is_active = 1
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

DROP TRIGGER IF EXISTS advance_comment_quest_progress_trigger ON public.binh_luan;
CREATE TRIGGER advance_comment_quest_progress_trigger
AFTER INSERT ON public.binh_luan
FOR EACH ROW EXECUTE FUNCTION public.advance_comment_quest_progress();

-- Do not allow clients to mint arbitrary quest progress. Progress is derived
-- from validated reading sessions and actual comment inserts above.
REVOKE ALL ON FUNCTION public.increment_quest_progress(TEXT, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.increment_quest_progress(TEXT, INTEGER) FROM authenticated;
REVOKE ALL ON FUNCTION public.record_reading_session(INTEGER, INTEGER, BIGINT, BIGINT, TEXT, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.advance_comment_quest_progress() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.record_reading_session(INTEGER, INTEGER, BIGINT, BIGINT, TEXT, INTEGER) TO authenticated;

NOTIFY pgrst, 'reload schema';
