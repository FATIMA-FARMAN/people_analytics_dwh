-- View latest Data Quality results
SELECT *
FROM `core-rhythm-462516-n5.people_analytics.dq_results`
ORDER BY run_ts DESC, status DESC;
