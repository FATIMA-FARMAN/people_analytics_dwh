# People Analytics DWH + Executive Dashboard  
**HRIS + ATS → BigQuery → Looker Studio**

## Overview
People Tech leaders need fast, reliable answers to:

- Where is **attrition risk** rising (team/tenure/manager)?
- Which orgs are **unstable** (early attrition 0–90 days)?
- Where is the **hiring funnel** bottleneck?
- Which roles have high **time-to-hire** and low **offer acceptance**?

This repository demonstrates an end-to-end people analytics workflow:


---

## Deliverables
- **BigQuery dataset**: `people_analytics`
- **Core model**: dimensions + facts + reporting tables
- **Reporting tables (examples)**:
  - `rpt_attrition_by_department`
  - `rpt_early_attrition_0_90`
  - `rpt_hiring_funnel_req`
  - `rpt_offer_accept_overall`
  - `rpt_stage_bottlenecks`
- **Dashboard**: LOOKER_STUDIO_LINK_HERE

---

## Architecture
**Sources (HRIS, ATS)** → **Staging (stg_*)** → **Facts/Dimensions** → **Reports (rpt_*)** → **Looker Studio**

> Data note: If you used synthetic/sample data, state it clearly here.
> “This repo uses synthetic HRIS/ATS-like data for demonstration.”

##Dashboard screenshots 
![Executive Overview](assets/dashboard_overview.png)
![Hiring Funnel](assets/dashboard_funnel.png)
 
## Metrics (Definitions)
A lightweight metric dictionary is maintained in: `docs/metrics_dictionary.md`.

Core definitions covered:

- **Attrition rate**: defined by period + denominator (active headcount / average headcount for the period).
- **Early attrition (0–90 days)**: terminations occurring within 0–90 days of hire date.
- **Time-to-hire**: days between requisition opened date and hire date (or offer accepted → hire, depending on data availability).
- **Offer accept rate**: accepted offers / total offers (in the selected period).
- **Stage bottlenecks**: stage duration summary using **avg days** and **p90 days** per stage.

## Notes for Reviewers
This project mirrors People Tech analytics workflows in high-growth fintechs:
**clean reporting tables + leadership-friendly outputs**.

Focus areas:
- **Correctness**
- **Clarity**
- **Reproducibility**
- **Stakeholder-ready reporting**

---

## Repo structure
```text
people_analytics_dwh/
├─ README.md
├─ scripts/
│  └─ bq_run_all.sh
├─ sql/
│  ├─ analysis/                  # ad-hoc QA queries
│  └─ marts/                     # reporting layer SQL (rpt_*.sql)
├─ docs/                         # diagrams, metric dictionary, notes
├─ assets/                       # screenshots for README
└─ data/                         # optional sample data (if used)
