# Architecture

```mermaid
flowchart LR
  HRIS[HRIS CSVs<br/>employees, terminations] --> STG[BigQuery staging<br/>stg_*]
  ATS[ATS CSVs<br/>requisitions, applications, offers, stage events] --> STG

  STG --> DIMS[Dimensions<br/>dim_*]
  STG --> FACTS[Facts<br/>fact_*]

  DIMS --> RPT[Reporting views<br/>rpt_*]
  FACTS --> RPT

  RPT --> LOOKER[Looker Studio Dashboard]
