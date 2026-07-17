CREATE OR REPLACE FUNCTION validate_student_data()
RETURNS trigger AS $$
BEGIN
-- Validasi NIM: harus 7 digit angka
IF NEW.nim IS NULL OR NOT (NEW.nim ~ '^\d{7}$') THEN
RAISE EXCEPTION 'Invalid NIM: must be 7 digits. Given: %', NEW.nim;
END IF;
-- Validasi email sederhana
IF NEW.email IS NULL OR NOT (NEW.email ~
'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
RAISE EXCEPTION 'Invalid email format: %', NEW.email;
END IF;
-- Set updated_at otomatis

NEW.updated_at := NOW();
RETURN NEW;
EXCEPTION
WHEN others THEN
-- Propagate clear error
RAISE;
END;
$$ LANGUAGE plpgsql;
-- Attach trigger to students
CREATE TRIGGER students_validate_before
BEFORE INSERT OR UPDATE ON students
FOR EACH ROW
EXECUTE FUNCTION validate_student_data();