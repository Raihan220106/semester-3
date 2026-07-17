INSERT INTO doctors (doctor_name, specialization, experience_years)
VALUES 
('Dr. Andi', 'Cardiology', 10),
('Dr. Budi', 'Neurology', 8),
('Dr. Clara', 'Dermatology', 5);

INSERT INTO patients (patient_name, gender, age)
VALUES
('Rina', 'Female', 30),
('Adi', 'Male', 42),
('Sari', 'Female', 25),
('Tono', 'Male', 55);

INSERT INTO feedbacks (doctor_id, patient_id, rating, feedback_text)
VALUES
(1, 1, 4.5, 'Sangat ramah dan profesional'),
(1, 2, 5.0, 'Pelayanan cepat dan memuaskan'),
(2, 3, 3.5, 'Cukup baik tapi agak lama'),
(3, 4, 4.0, 'Dokter sopan dan informatif');
