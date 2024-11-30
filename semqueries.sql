CREATE VIEW lesson_counts_by_month AS
WITH lesson_types AS (
    SELECT 
        EXTRACT(MONTH FROM l."startTime") as month,
        CASE 
            WHEN i."id" IS NOT NULL THEN 'individual'
            WHEN g."id" IS NOT NULL THEN 'group'
            WHEN e."id" IS NOT NULL THEN 'ensemble'
        END as lesson_type
    FROM "Lesson" l
    LEFT JOIN "Individual" i ON l."id" = i."lessonId"
    LEFT JOIN "Group" g ON l."id" = g."lessonId"
    LEFT JOIN "Ensemble" e ON l."id" = e."lessonId"
    WHERE EXTRACT(YEAR FROM l."startTime") = 2023
)
SELECT 
    to_char(to_date(month::text, 'MM'), 'Mon') as "Month",
    COUNT(*) as "Total",
    COUNT(CASE WHEN lesson_type = 'individual' THEN 1 END) as "Individual",
    COUNT(CASE WHEN lesson_type = 'group' THEN 1 END) as "Group",
    COUNT(CASE WHEN lesson_type = 'ensemble' THEN 1 END) as "Ensemble"
FROM lesson_types
GROUP BY month
ORDER BY month;
