-- Drop the existing view if it exists
DROP VIEW IF EXISTS monthly_lesson_counts;

-- Create a view for lesson counts per month
CREATE VIEW monthly_lesson_counts AS
WITH lesson_counts AS (
  SELECT 
    EXTRACT(MONTH FROM "startTime") as month,
    COUNT(*) as total,
    COUNT(CASE WHEN "lessonType" = 'individual' THEN 1 END) as individual,
    COUNT(CASE WHEN "lessonType" = 'group' THEN 1 END) as group_lessons,
    COUNT(CASE WHEN "lessonType" = 'ensemble' THEN 1 END) as ensemble
  FROM "Lesson"
  WHERE EXTRACT(YEAR FROM "startTime") = 2023
  GROUP BY EXTRACT(MONTH FROM "startTime")
)
SELECT 
  TO_CHAR(TO_DATE(month::text, 'MM'), 'Month') as month,
  total,
  individual,
  group_lessons as "group",
  ensemble
FROM lesson_counts
ORDER BY month DESC;

-- Analyze query performance
EXPLAIN ANALYZE 
SELECT * FROM monthly_lesson_counts;
