CREATE OR REPLACE TABLE `core-rhythm-462516-n5.people_analytics.rpt_headcount` AS
SELECT
  CURRENT_DATE() AS as_of_date,
  COUNTIF(termination_date IS NULL) AS active_headcount,
  COUNT(*) AS total_employees
FROM `core-rhythm-462516-n5.people_analytics.dim_employee`;
