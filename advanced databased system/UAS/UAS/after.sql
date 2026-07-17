-- AFTER: Laporan performa dokter (Statistical Report)
CREATE OR REPLACE VIEW DoctorPerformanceReport AS
SELECT 
    d.doctor_id,
    d.doctor_name,
    d.specialization,
    COUNT(f.feedback_id) AS total_feedbacks,
    AVG(f.rating) AS average_rating,
    COUNT(DISTINCT f.patient_id) AS total_patients
FROM doctors d
LEFT JOIN feedbacks f ON d.doctor_id = f.doctor_id
GROUP BY d.doctor_id, d.doctor_name, d.specialization
ORDER BY average_rating DESC;

-- Menampilkan laporan
SELECT * FROM DoctorPerformanceReport;
