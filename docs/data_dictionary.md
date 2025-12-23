# Data Dictionary (v1)

## Source extracts (CSV)
| File | What it contains | Grain / keys |
|---|---|---|
| data/hris_employees.csv | Employee master data | employee_id |
| data/hris_terminations.csv | Termination events | employee_id, termination_date |
| data/ats_requisitions.csv | Job requisitions | requisition_id |
| data/ats_applications.csv | Candidate applications | application_id, requisition_id, candidate_id |
| data/ats_offers.csv | Offers and outcomes | offer_id, application_id |
| data/ats_stage_events.csv | Stage history (pipeline events) | application_id, stage, event_ts |

## Warehouse layers (BigQuery)
| Layer | Objects | Purpose |
|---|---|---|
| Staging | `stg_*` | Raw loads of CSVs with minimal typing/cleanup |
| Dimensions | `dim_*` | Entities for reporting (employee, requisition, stage, dept, location) |
| Facts | `fact_*` | Events/measures (applications, offers, stage events, attrition) |
| Reporting | `rpt_*` | Final views optimized for Looker Studio |
