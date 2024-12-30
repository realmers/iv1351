-- The goal here is to create OLAP, Online Analytical Processing, queries and views. Such queries serve to analyze the business and to create reports. You're also required to analyze the efficiency of one of the queries with EXPLAIN ANALYZE. Even though that's not standard SQL, it's available in both PostgreSQL and MySQL. You also have to make sure the database contains sufficient data to check that all queries work as intended. If needed, update the script that inserts data, created in task two. You're allowed to change the database you created in task two if needed. The queries that shall be created are explained below, only OLAP queries will be created here. The OLTP (Online Transaction Processing) queries used by the business itself, which in the case of Soundgood is to rent out instruments, register taken and given lessons, etc, will be created in task 4, together with the program executing them.

-- Create view for lesson statistics
CREATE VIEW lesson_statistics AS
WITH monthly_counts AS (
    SELECT 
        EXTRACT(MONTH FROM "Lesson"."startTime") as month,
        EXTRACT(YEAR FROM "Lesson"."startTime") as year,
        COUNT(*) as total,
        SUM(CASE WHEN "Lesson"."lessonType" = 'individual' THEN 1 ELSE 0 END) as individual,
        SUM(CASE WHEN "Lesson"."lessonType" = 'group' THEN 1 ELSE 0 END) as group_lessons,
        SUM(CASE WHEN "Lesson"."lessonType" = 'ensemble' THEN 1 ELSE 0 END) as ensemble
    FROM "Lesson"
    GROUP BY 
        EXTRACT(YEAR FROM "Lesson"."startTime"),
        EXTRACT(MONTH FROM "Lesson"."startTime")
)
SELECT 
    TO_CHAR(TO_DATE(month::text, 'MM'), 'Mon') as "Month",
    total as "Total",
    individual as "Individual",
    group_lessons as "Group",
    ensemble as "Ensemble"
FROM monthly_counts
WHERE year = 2024
ORDER BY month;

-- Query to show lesson statistics
SELECT * FROM lesson_statistics;

-- Performance analysis
EXPLAIN ANALYZE SELECT * FROM lesson_statistics;

-- Create view for instructors with high lesson counts
CREATE OR REPLACE VIEW instructor_lesson_count AS
WITH monthly_instructor_lessons AS (
    SELECT 
        i.id AS instructor_id,
        pi."firstName",
        pi."lastName",
        COUNT(*) AS lesson_count
    FROM "Lesson" l
    JOIN "Instructor" i ON l."instructorId" = i.id
    JOIN "PersonalInformation" pi ON i."personalInformationId" = pi.id
    WHERE EXTRACT(MONTH FROM l."startTime") = EXTRACT(MONTH FROM CURRENT_DATE)
    AND EXTRACT(YEAR FROM l."startTime") = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY i.id, pi."firstName", pi."lastName"
    HAVING COUNT(*) > 1  -- Adjust threshold as needed
)
SELECT 
    instructor_id AS "Instructor Id",
    "firstName" AS "First Name",
    "lastName" AS "Last Name",
    lesson_count AS "No of Lessons"
FROM monthly_instructor_lessons
ORDER BY lesson_count DESC;

-- Query to show instructor workload
SELECT * FROM instructor_lesson_count;

-- Performance analysis
EXPLAIN ANALYZE SELECT * FROM instructor_lesson_count;
