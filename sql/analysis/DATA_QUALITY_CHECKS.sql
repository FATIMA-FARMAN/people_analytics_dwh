<<<<<<< HEAD
-- =====================================================================
-- People Analytics DWH — Data Quality Checks (BigQuery)
-- Writes results to: `<project>.<dataset>.dq_results`
--
-- What it checks (generic, no fixed schema required):
--  1) Row count per table
--  2) Duplicate rows per table (based on row hash)
--  3) Null profile per column (null_pct) with PASS/WARN/FAIL
--
-- Notes:
--  - Duplicate check uses FARM_FINGERPRINT(TO_JSON_STRING(row)).
--  - Null thresholds are generic; tune to your expectations.
-- =====================================================================

DECLARE project_id STRING DEFAULT 'core-rhythm-462516-n5';
DECLARE dataset_id STRING DEFAULT 'people_analytics';

DECLARE run_id STRING DEFAULT FORMAT_TIMESTAMP('%Y%m%d_%H%M%S', CURRENT_TIMESTAMP());

-- Thresholds (edit if you want stricter/looser)
DECLARE null_warn_threshold FLOAT64 DEFAULT 0.05;  -- 5%
DECLARE null_fail_threshold FLOAT64 DEFAULT 0.20;  -- 20%

-- Create results table if missing
EXECUTE IMMEDIATE FORMAT("""
CREATE TABLE IF NOT EXISTS `%s.%s.dq_results` (
  run_id       STRING,
  run_ts       TIMESTAMP,
  check_name   STRING,
  table_name   STRING,
  column_name  STRING,
  metric_name  STRING,
  metric_value FLOAT64,
  status       STRING,
  details      STRING
)
""", project_id, dataset_id);

-- Optional: remove prior rows for same run_id (re-run safety)
EXECUTE IMMEDIATE FORMAT("""
DELETE FROM `%s.%s.dq_results`
WHERE run_id = @run_id
""", project_id, dataset_id)
USING run_id AS run_id;

-- Loop all relevant tables in dataset
FOR t IN (
  SELECT table_id AS table_name
  FROM `${project_id}.${dataset_id}.__TABLES__`
  WHERE STARTS_WITH(table_id, 'stg_')
     OR STARTS_WITH(table_id, 'dim_')
     OR STARTS_WITH(table_id, 'fact_')
     OR STARTS_WITH(table_id, 'rpt_')
  ORDER BY table_id
) DO

  -- 1) Row count
  EXECUTE IMMEDIATE FORMAT("""
    INSERT INTO `%s.%s.dq_results`
    (run_id, run_ts, check_name, table_name, column_name, metric_name, metric_value, status, details)
    SELECT
      @run_id,
      CURRENT_TIMESTAMP(),
      'table_row_count',
      '%s',
      NULL,
      'row_count',
      CAST(COUNT(*) AS FLOAT64),
      IF(COUNT(*) > 0, 'PASS', 'WARN'),
      IF(COUNT(*) > 0, 'OK', 'Table is empty')
    FROM `%s.%s.%s`
  """, project_id, dataset_id, t.table_name, project_id, dataset_id, t.table_name)
  USING run_id AS run_id;

  -- 2) Duplicate rows (row-hash based)
  EXECUTE IMMEDIATE FORMAT("""
    INSERT INTO `%s.%s.dq_results`
    (run_id, run_ts, check_name, table_name, column_name, metric_name, metric_value, status, details)
    WITH base AS (
      SELECT FARM_FINGERPRINT(TO_JSON_STRING(x)) AS row_hash
      FROM `%s.%s.%s` x
    ),
    agg AS (
      SELECT
        COUNT(*) AS total_rows,
        COUNT(DISTINCT row_hash) AS distinct_rows
      FROM base
    )
    SELECT
      @run_id,
      CURRENT_TIMESTAMP(),
      'duplicate_rows',
      '%s',
      NULL,
      'duplicate_row_count',
      CAST(total_rows - distinct_rows AS FLOAT64),
      IF(total_rows - distinct_rows = 0, 'PASS', 'FAIL'),
      CONCAT('total_rows=', CAST(total_rows AS STRING), ', distinct_rows=', CAST(distinct_rows AS STRING))
    FROM agg
  """, project_id, dataset_id,
      project_id, dataset_id, t.table_name,
      t.table_name)
  USING run_id AS run_id;

  -- 3) Null profile per column (null_pct)
  FOR c IN (
    SELECT column_name
    FROM `${project_id}.${dataset_id}.INFORMATION_SCHEMA.COLUMNS`
    WHERE table_name = t.table_name
    ORDER BY ordinal_position
  ) DO
    DECLARE col_ident STRING DEFAULT FORMAT("`%s`", c.column_name);

    EXECUTE IMMEDIATE FORMAT("""
      INSERT INTO `%s.%s.dq_results`
      (run_id, run_ts, check_name, table_name, column_name, metric_name, metric_value, status, details)
      WITH stats AS (
        SELECT
          COUNT(*) AS total_rows,
          COUNTIF(%s IS NULL) AS null_rows
        FROM `%s.%s.%s`
      )
      SELECT
        @run_id,
        CURRENT_TIMESTAMP(),
        'null_profile',
        '%s',
        '%s',
        'null_pct',
        SAFE_DIVIDE(CAST(null_rows AS FLOAT64), CAST(total_rows AS FLOAT64)) AS null_pct,
        CASE
          WHEN total_rows = 0 THEN 'WARN'
          WHEN SAFE_DIVIDE(CAST(null_rows AS FLOAT64), CAST(total_rows AS FLOAT64)) = 0 THEN 'PASS'
          WHEN SAFE_DIVIDE(CAST(null_rows AS FLOAT64), CAST(total_rows AS FLOAT64)) >= @null_fail THEN 'FAIL'
          WHEN SAFE_DIVIDE(CAST(null_rows AS FLOAT64), CAST(total_rows AS FLOAT64)) >= @null_warn THEN 'WARN'
          ELSE 'PASS'
        END AS status,
        CONCAT('null_rows=', CAST(null_rows AS STRING), ', total_rows=', CAST(total_rows AS STRING))
      FROM stats
    """,
      project_id, dataset_id,
      col_ident,
      project_id, dataset_id, t.table_name,
      t.table_name,
      c.column_name
    )
    USING run_id AS run_id, null_warn_threshold AS null_warn, null_fail_threshold AS null_fail;
  END FOR;

END FOR;

-- Convenience: show failed/warn checks for this run
SELECT *
FROM `${project_id}.${dataset_id}.dq_results`
WHERE run_id = run_id
  AND status IN ('FAIL', 'WARN')
ORDER BY status DESC, check_name, table_name, column_name;
=======
-- People Analytics DWH - Data Quality Checks
-- Dataset: core-rhythm-462516-n5.people_analytics

-- A) Confirm object types (prevents table/view confusion)
SELECT table_name, table_type
FROM `core-rhythm-462516-n5.people_analytics.INFORMATION_SCHEMA.TABLES`
WHERE table_name IN ('rpt_offer_accept_overall','rpt_hiring_funnel_req')
ORDER BY table_name;

-- B) Offer accept sanity (0..1) and made >= accepted
SELECT
  offer_accept_rate,
  offers_accepted,
  offers_made,
  refreshed_at,
  (offer_accept_rate < 0 OR offer_accept_rate > 1) AS bad_rate,
  (offers_made < offers_accepted) AS bad_counts
FROM `core-rhythm-462516-n5.people_analytics.rpt_offer_accept_overall`;

-- C) Funnel sanity: no negative stage counts (adjust column names if needed)
SELECT
  COUNT(*) AS bad_rows
FROM `core-rhythm-462516-n5.people_analytics.rpt_hiring_funnel_req`
WHERE
  applications < 0 OR interviews < 0 OR offers_made < 0 OR offers_accepted < 0;

-- D) Orphan checks (adjust join keys if your schema differs)
SELECT
  COUNT(*) AS orphan_offers
FROM `core-rhythm-462516-n5.people_analytics.fact_offers f`
LEFT JOIN `core-rhythm-462516-n5.people_analytics.dim_requisition r`
  ON f.requisition_id = r.requisition_id
WHERE r.requisition_id IS NULL;
>>>>>>> 3857335 (Add DQ checks and results viewer query)
