CREATE OR REPLACE FUNCTION update_student_statistics()
RETURNS trigger AS $$
DECLARE
v_student_old integer;
v_student_new integer;
v_total integer;
v_avg numeric(3,2);
BEGIN
-- Tentukan student yang perlu di-recalc
IF TG_OP = 'INSERT' THEN

v_student_new := NEW.student_id;
-- recalc for NEW.student_id
SELECT COALESCE(COUNT(*),0), COALESCE(AVG(grade),0)
INTO v_total, v_avg
FROM grades
WHERE student_id = v_student_new;
INSERT INTO student_stats(student_id, total_courses, avg_grade,
last_updated)
VALUES (v_student_new, v_total, ROUND(v_avg::numeric,2), NOW())
ON CONFLICT (student_id) DO UPDATE
SET total_courses = EXCLUDED.total_courses,
avg_grade = EXCLUDED.avg_grade,
last_updated = NOW();
ELSIF TG_OP = 'UPDATE' THEN
v_student_old := OLD.student_id;
v_student_new := NEW.student_id;
-- If student_id changed, recalc for both
IF v_student_old IS NOT NULL AND v_student_old <> v_student_new THEN
SELECT COALESCE(COUNT(*),0), COALESCE(AVG(grade),0)
INTO v_total, v_avg
FROM grades
WHERE student_id = v_student_old;
INSERT INTO student_stats(student_id, total_courses, avg_grade,

last_updated)

VALUES (v_student_old, v_total, ROUND(v_avg::numeric,2), NOW())
ON CONFLICT (student_id) DO UPDATE
SET total_courses = EXCLUDED.total_courses,
avg_grade = EXCLUDED.avg_grade,
last_updated = NOW();
END IF;
-- Recalc for new student
SELECT COALESCE(COUNT(*),0), COALESCE(AVG(grade),0)
INTO v_total, v_avg
FROM grades
WHERE student_id = v_student_new;
INSERT INTO student_stats(student_id, total_courses, avg_grade,
last_updated)
VALUES (v_student_new, v_total, ROUND(v_avg::numeric,2), NOW())
ON CONFLICT (student_id) DO UPDATE
SET total_courses = EXCLUDED.total_courses,
avg_grade = EXCLUDED.avg_grade,
last_updated = NOW();
ELSIF TG_OP = 'DELETE' THEN

v_student_old := OLD.student_id;
SELECT COALESCE(COUNT(*),0), COALESCE(AVG(grade),0)
INTO v_total, v_avg
FROM grades
WHERE student_id = v_student_old;
IF v_total = 0 THEN
-- No grades left: set defaults
INSERT INTO student_stats(student_id, total_courses, avg_grade,

last_updated)

VALUES (v_student_old, 0, 0, NOW())
ON CONFLICT (student_id) DO UPDATE
SET total_courses = 0,
avg_grade = 0,
last_updated = NOW();
ELSE
INSERT INTO student_stats(student_id, total_courses, avg_grade,

last_updated)

VALUES (v_student_old, v_total, ROUND(v_avg::numeric,2), NOW())
ON CONFLICT (student_id) DO UPDATE
SET total_courses = EXCLUDED.total_courses,
avg_grade = EXCLUDED.avg_grade,
last_updated = NOW();
END IF;
END IF;
RETURN NULL; -- AFTER trigger
EXCEPTION
WHEN others THEN
RAISE EXCEPTION 'Error updating student statistics: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- Attach trigger to grades
CREATE TRIGGER grades_update_stats_after
AFTER INSERT OR UPDATE OR DELETE ON grades
FOR EACH ROW
EXECUTE FUNCTION update_student_statistics();