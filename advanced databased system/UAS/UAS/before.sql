SELECT 
    d.doctor_id,
    d.doctor_name,
    d.specialization,
    f.rating,
    f.feedback_text
FROM doctors d
LEFT JOIN feedbacks f ON d.doctor_id = f.doctor_id
ORDER BY d.doctor_name;
