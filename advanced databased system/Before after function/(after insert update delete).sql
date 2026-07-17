CREATE OR REPLACE FUNCTION audit_student_changes()
RETURNS trigger AS $$
DECLARE
v_old jsonb;
v_new jsonb;
v_record_id integer;
BEGIN
IF TG_OP = 'INSERT' THEN
v_old := NULL;
v_new := to_jsonb(NEW);
v_record_id := NEW.id;
ELSIF TG_OP = 'UPDATE' THEN
v_old := to_jsonb(OLD);
v_new := to_jsonb(NEW);
v_record_id := NEW.id;
ELSIF TG_OP = 'DELETE' THEN
v_old := to_jsonb(OLD);
v_new := NULL;
v_record_id := OLD.id;
ELSE
-- safety
v_old := NULL;
v_new := NULL;
v_record_id := NULL;
END IF;
INSERT INTO audit_log(table_name, record_id, operation, old_values,
new_values, changed_at, changed_by)
VALUES('students', v_record_id, TG_OP, v_old, v_new, NOW(),
current_user);

RETURN NULL; -- AFTER trigger
EXCEPTION
WHEN others THEN
-- Log atau re-raise untuk memastikan audit tidak tumpang tindih
RAISE;
END;
$$ LANGUAGE plpgsql;
-- Attach trigger
CREATE TRIGGER students_audit_after
AFTER INSERT OR UPDATE OR DELETE ON students
FOR EACH ROW
EXECUTE FUNCTION audit_student_changes();