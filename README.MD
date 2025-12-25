# People Analytics DWH + Executive Dashboard  
**HRIS + ATS → BigQuery → Looker Studio**

## Overview
People Tech leaders need fast, reliable answers to:
- Where is **attrition risk** rising (team / tenure / manager)?
- Which orgs are unstable (**early attrition 0–90 days**)?
- Where is the **hiring funnel** bottleneck?
- Which roles have high **time-to-hire** and low **offer acceptance**?

This repository demonstrates an end-to-end People Analytics workflow:
**raw HRIS/ATS → staging (stg_*) → facts/dimensions → reporting (rpt_*) → executive dashboard**.

---

### Deliverables
- **BigQuery dataset:** `people_analytics`
- **Core model:** dimensions + facts + reporting tables
- **Reporting tables (examples):**
  - `rpt_attrition`
  - `rpt_early_attrition_0_90`
  - `rpt_hiring_funnel_req`
  - `rpt_offer_accept_overall`
  - `rpt_stage_bottlenecks`
  - `rpt_headcount_current`
- **Dashboard:** Looker Studio  
  - Link: https://lookerstudio.google.com/u/0/reporting/04c08ab2-e090-491c-90aa-0bcd38c23988/page/pDU

## Dashboard screenshots

### Executive Overview
‎assets/hero_executive_overview.png‎ 

### Hiring Funnel
assets/03_hiring_funnel_by_req.png


## Architecture
**Sources (HRIS, ATS) → Staging (stg_*) → Facts/Dimensions → Reports (rpt_*) → Looker Studio**

**Data note:** This repo can be run with real or synthetic/sample HRIS/ATS-like data.  
If using sample data, state it clearly (recommended for public repos).

---

## Data model (high level)

### Dimensions
- `dim_employee`
- `dim_requisition`

### Facts
- `fact_applications`
- `fact_offers`
- `fact_stage_events`
- `fact_terminations`

---

## How to run (BigQuery)

### Prerequisites
- Google Cloud project with **BigQuery enabled**
- `gcloud` + `bq` CLI installed
- Authenticated locally:
  - `gcloud auth login`
  - `gcloud config set project <PROJECT_ID>`

Example:
```bash
bash scripts/bq_run_all.sh core-rhythm-462516-n5 people_analytics US

