# People Analytics DWH + Executive Dashboard  
**HRIS + ATS → BigQuery → Looker Studio**

## Overview
People Tech leaders need fast, reliable answers to:

- Where is **attrition risk** rising (team/tenure/manager)?
- Which orgs are **unstable** (early attrition 0–90 days)?
- Where is the **hiring funnel** bottleneck?
- Which roles have high **time-to-hire** and low **offer acceptance**?

This repository demonstrates an end-to-end people analytics workflow:

**Synthetic HRIS + ATS → BigQuery warehouse (staging + marts) → executive-ready reporting views (`rpt_*`) → Looker Studio dashboard**

---

## Architecture diagram

```mermaid
flowchart TD
  A[HRIS CSVs<br/>employees, terminations] --> B[BigQuery Staging<br/>stg_*]
  C[ATS CSVs<br/>requisitions, applications,<br/>stage_events, offers] --> B

  B --> D[Warehouse Marts<br/>dim_* + fact_*]
  D --> E[Reporting Layer<br/>rpt_* views]
  E --> F[Looker Studio<br/>Executive Dashboard]
## Layering convention
- `stg_*` = raw/staging tables (loaded from CSV)
- `dim_*` = dimensions
- `fact_*` = facts
- `rpt_*` = reporting views (recommended dashboard sources)

---

## Quickstart (BigQuery)

### Prerequisites
- Google Cloud SDK installed (includes `gcloud` + `bq`)
- Access to a GCP project with BigQuery enabled

### Run

1) Authenticate:
```bash
gcloud auth login
gcloud auth application-default login

## Overview
This project builds a lightweight People Analytics data warehouse in BigQuery and a set of executive-ready reporting tables (headcount, attrition, hiring funnel, offer accept).
It includes repeatable SQL pipelines plus data quality checks that produce PASS/WARN/FAIL outputs for key tables and columns.
 - [sql/analysis/DATA_QUALITY_CHECKS.sql](sql/analysis/DATA_QUALITY_CHECKS.sql)
- [sql/analysis/VIEW_DQ_RESULTS.sql](sql/analysis/VIEW_DQ_RESULTS.sql)
## Data Quality Checks

Run checks:
- [sql/analysis/DATA_QUALITY_CHECKS.sql](sql/analysis/DATA_QUALITY_CHECKS.sql)

View latest results:
- [sql/analysis/VIEW_DQ_RESULTS.sql](sql/analysis/VIEW_DQ_RESULTS.sql)

Results table:
- `people_analytics.dq_results`

## Next milestones
- [ ] Load data into BigQuery + build staging tables
- [ ] Create marts (facts/dims) for headcount, attrition, funnel
- [ ] Build Looker Studio dashboard + publish link
- [ ] Add final screenshots + executive summary insights
