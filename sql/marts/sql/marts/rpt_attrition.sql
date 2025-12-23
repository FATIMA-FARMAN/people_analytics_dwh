CREATE OR REPLACE TABLE `core-rhythm-462516-n5.people_analytics.rpt_attrition` AS
WITH base AS (
  SELECT
    department,
    COUNT(*) AS employees,
    COUNTIF(termination_date IS NOT NULL) AS terminated
  FROM `core-rhythm-462516-n5.people_analytics.dim_employee`
  GROUP BY department
)
SELECT
  department,
  employees,
  terminated,
  SAFE_DIVIDE(terminated, employees) AS attrition_rate
FROM base
ORDER BY attrition_rate DESC;
