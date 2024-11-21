-- Count number of students per skill level
SELECT sl.level, COUNT(s.id) as student_count
FROM "StudentLevel" sl
LEFT JOIN "Student" s ON sl.id = s."levelId"
GROUP BY sl.level;

-- Find lessons with more than 5 students in the group
SELECT l.id, l."startTime", pi.name as instructor_name, l."groupSize"
FROM "Lesson" l
JOIN "Instructor" i ON l."instructorId" = i.id
JOIN "PersonalInformation" pi ON i."personalInformationId" = pi.id
WHERE l."groupSize" > 5
ORDER BY l."startTime";

-- Calculate total payments received from each student in 2023
SELECT pi.name, SUM(sp.amount) as total_paid, 
       COUNT(sp.id) as number_of_payments
FROM "StudentPayment" sp
JOIN "Student" s ON sp."studentId" = s.id
JOIN "PersonalInformation" pi ON s."personalInformationId" = pi.id
WHERE EXTRACT(YEAR FROM sp."paymentDate") = 2023
GROUP BY pi.name
ORDER BY total_paid DESC;

-- Find instruments currently being rented and by whom
SELECT pi.name as student_name, ai."instrumentType", 
       ri."rentTime" as rental_start_date
FROM "AvailableInstrument" ai
JOIN "RentingInstrument" ri ON ai."rentingInstrumentId" = ri.id
JOIN "Student" s ON ri."studentId" = s.id
JOIN "PersonalInformation" pi ON s."personalInformationId" = pi.id
ORDER BY ri."rentTime" DESC;

-- Find the most popular lesson times
SELECT EXTRACT(HOUR FROM l."startTime") as hour_of_day, 
       COUNT(*) as lesson_count
FROM "Lesson" l
GROUP BY EXTRACT(HOUR FROM l."startTime")
ORDER BY lesson_count DESC;
