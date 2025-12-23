CREATE OR REPLACE TABLE `core-rhythm-462516-n5.people_analytics.rpt_hiring_funnel` AS
WITH s AS (
  SELECT
    stage,
    COUNT(*) AS n
  FROM `core-rhythm-462516-n5.people_analytics.fact_stage_events`
  GROUP BY stage
)
SELECT
  stage,
  n
FROM s
ORDER BY n DESC;
