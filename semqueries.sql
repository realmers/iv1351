/*
 * lesson_statistics view
 * Purpose: Shows monthly lesson counts for the year 2024, broken down by lesson type
 * - Aggregates lessons by month and type (individual, group, ensemble)
 * - Converts month numbers to month names for readability
 * - Shows total lessons and subtotals for each lesson type
 */
CREATE OR REPLACE VIEW lesson_statistics AS
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


SELECT * FROM lesson_statistics;


EXPLAIN ANALYZE SELECT * FROM lesson_statistics;

----------------------------------------------------------------------------------------------------------------------------
/*
 * sibling_statistics view
 * Purpose: Provides statistics about sibling relationships among students
 * - Groups students by their sibling relationships
 * - Counts how many students have 0, 1, 2, or more siblings
 * - Shows the distribution of sibling group sizes in the school
 */
CREATE OR REPLACE VIEW sibling_statistics AS
WITH sibling_counts AS (
    SELECT 
        id AS studentId, 
        COALESCE("siblingId", id) AS sibling_group,
        COUNT(id) OVER (PARTITION BY COALESCE("siblingId", id)) - 1 AS sibling_count
    FROM "Student"
)
SELECT 
    sibling_count AS "No of Siblings",
    COUNT(*) AS "No of Students"
FROM sibling_counts
GROUP BY sibling_count
ORDER BY sibling_count;

SELECT * FROM sibling_statistics;

EXPLAIN ANALYZE SELECT * FROM sibling_statistics;

----------------------------------------------------------------------------------------------------------------------

/*
 * instructor_lesson_count view
 * Purpose: Identifies instructors with high teaching workload in the current month
 * - Counts lessons per instructor for the current month
 * - Includes only instructors with more than 1 lesson
 * - Shows instructor details and their lesson count
 * - Useful for workload analysis and resource planning
 */
CREATE OR REPLACE VIEW instructor_lesson_count AS
WITH monthly_instructor_lessons AS (
    SELECT 
        "Instructor".id AS instructor_id,
        "PersonalInformation"."firstName",
        "PersonalInformation"."lastName",
        COUNT(*) AS lesson_count
    FROM "Lesson" 
    JOIN "Instructor" ON "Lesson"."instructorId" = "Instructor".id
    JOIN "PersonalInformation" ON "Instructor"."personalInformationId" = "PersonalInformation".id
    WHERE EXTRACT(MONTH FROM "Lesson"."startTime") = EXTRACT(MONTH FROM CURRENT_DATE)
    AND EXTRACT(YEAR FROM "Lesson"."startTime") = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY "Instructor".id, "PersonalInformation"."firstName", "PersonalInformation"."lastName"
    HAVING COUNT(*) > 1  -- Adjust threshold as needed
)
SELECT 
    instructor_id AS "Instructor Id",
    "firstName" AS "First Name",
    "lastName" AS "Last Name",
    lesson_count AS "No of Lessons"
FROM monthly_instructor_lessons
ORDER BY lesson_count DESC;

SELECT * FROM instructor_lesson_count;


EXPLAIN ANALYZE SELECT * FROM instructor_lesson_count;

----------------------------------------------------------------------------------------------------------------------------

/*
 * ensemble_schedule view
 * Purpose: Displays upcoming ensemble lessons for the next 7 days with seat availability
 * - Shows day of week and genre for each ensemble
 * - Calculates and categorizes available seats (No Seats, 1-2 Seats, Many Seats)
 * - Ordered by day of week and genre
 * - Helps students find and register for available ensemble lessons
 */
CREATE OR REPLACE VIEW ensemble_schedule AS
WITH ensemble_details AS (
    SELECT 
        "Lesson".id,
        "Lesson"."startTime",
        "Ensemble".genre,
        "Lesson"."currentAmountOfStudents",
        "LessonCapacity"."maximumAmountOfStudents",
        ("LessonCapacity"."maximumAmountOfStudents" - "Lesson"."currentAmountOfStudents") as free_seats
    FROM "Lesson"
    JOIN "Ensemble" ON "Ensemble"."lessonId" = "Lesson".id
    JOIN "LessonCapacity" ON "Ensemble"."lessonCapacityId" = "LessonCapacity".id
    WHERE 
        "Lesson"."startTime" >= CURRENT_DATE 
        AND "Lesson"."startTime" < CURRENT_DATE + INTERVAL '7 days'
)
SELECT 
    TO_CHAR("startTime", 'Day') as "Day",
    genre as "Genre",
    CASE 
        WHEN free_seats = 0 THEN 'No Seats'
        WHEN free_seats BETWEEN 1 AND 2 THEN '1 or 2 Seats'
        ELSE 'Many Seats'
    END as "No of Free Seats"
FROM ensemble_details
ORDER BY 
    EXTRACT(DOW FROM "startTime"),
    genre;


SELECT * FROM ensemble_schedule;

EXPLAIN ANALYZE SELECT * FROM ensemble_schedule;
