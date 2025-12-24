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

## Repo Structure assets/ dashboard screenshots data/ synthetic HRIS + ATS CSVs docs/ metrics dictionary, executive summary, data model diagram sql/ staging, marts, analysis queries notebooks/ data generation / exploration --- ## Data (Synthetic) Files in /data: - hris_employees.csv - hris_terminations.csv - ats_requisitions.csv - ats_applications.csv - ats_stage_events.csv - ats_offers.csv --- ## Documentation - Metrics definitions: docs/METRICS_DICTIONARY.md - Executive summary: docs/executive_summary.md - Data quality checks: sql/analysis/DATA_QUALITY_CHECKS.sql --- ## Executive KPIs - Active Headcount - Net Headcount Growth - Attrition Rate (Voluntary / Involuntary) - Attrition Risk by Department & Tenure - Time-to-Hire - Offer Acceptance Rate - Hiring Funnel Conversion ## Overview This project builds a lightweight People Analytics data warehouse in BigQuery and a set of executive-ready reporting tables (headcount, attrition, hiring funnel, offer accept). It includes repeatable SQL pipelines plus data quality checks that produce PASS/WARN/FAIL outputs for key tables and columns. - [sql/analysis/DATA_QUALITY_CHECKS.sql](sql/analysis/DATA_QUALITY_CHECKS.sql) - [sql/analysis/VIEW_DQ_RESULTS.sql](sql/analysis/VIEW_DQ_RESULTS.sql) ## Data Quality Checks Run checks: - [sql/analysis/DATA_QUALITY_CHECKS.sql](sql/analysis/DATA_QUALITY_CHECKS.sql) View latest results: - [sql/analysis/VIEW_DQ_RESULTS.sql](sql/analysis/VIEW_DQ_RESULTS.sql) Results table: - people_analytics.dq_results ## Next milestones - [ ] Load data into BigQuery + build staging tables - [ ] Create marts (facts/dims) for headcount, attrition, funnel
