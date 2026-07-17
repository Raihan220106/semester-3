-- student_stats
CREATE TABLE IF NOT EXISTS student_stats (
student_id INTEGER PRIMARY KEY REFERENCES students(id),
total_courses INTEGER DEFAULT 0,
avg_grade DECIMAL(3,2) DEFAULT 0,
last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- grades (if not already created in environment)
CREATE TABLE IF NOT EXISTS grades (
id SERIAL PRIMARY KEY,
student_id INTEGER REFERENCES students(id),
course_code VARCHAR(10),
grade DECIMAL(3,2) CHECK (grade >= 0 AND grade <= 4.0),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);