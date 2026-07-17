-- Tabel dokter
CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    doctor_name VARCHAR(100),
    specialization VARCHAR(100),
    experience_years INT
);

-- Tabel pasien
CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    patient_name VARCHAR(100),
    gender VARCHAR(10),
    age INT
);

-- Tabel feedback (relasi pasien dan dokter)
CREATE TABLE feedbacks (
    feedback_id SERIAL PRIMARY KEY,
    doctor_id INT REFERENCES doctors(doctor_id),
    patient_id INT REFERENCES patients(patient_id),
    rating NUMERIC(2,1),
    feedback_text TEXT
);
