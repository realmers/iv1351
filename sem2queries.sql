-- Example Queries

-- 1. Get all instructors
SELECT * FROM "Instructor";

-- 2. Get all available time slots for a specific instructor
SELECT * FROM "AvailableTimeSlot" WHERE "instructorId" = 1;

-- 3. Get all payments made to instructors
SELECT * FROM "InstructorPayment";

-- 4. Get all students and their levels
SELECT s."name" AS student_name, sl."level" AS student_level
FROM "Student" s
JOIN "StudentLevel" sl ON s."levelId" = sl."id";

-- 5. Get all lessons scheduled in a specific room
SELECT * FROM "Lesson" WHERE "roomId" = 1;

-- 6. Get all payments made by students
SELECT * FROM "StudentPayment";

-- 7. Get all instruments rented by students
SELECT ai."instrumentType", ri."studentId", ri."rentTime"
FROM "AvailableInstrument" ai
JOIN "RentingInstrument" ri ON ai."rentingInstrumentId" = ri."id";

-- 8. Get all lessons for a specific student
SELECT * FROM "Lesson" WHERE "studentId" = 1;

-- 9. Get all rooms and their capacities
SELECT * FROM "Room";

-- 10. Get all students who have siblings
SELECT * FROM "Student" WHERE "siblingId" IS NOT NULL;

-- 11. Get all lessons scheduled by a specific instructor
SELECT * FROM "Lesson" WHERE "instructorId" = 1;
