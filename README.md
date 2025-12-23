# People Analytics DWH + Executive Dashboard (HRIS + ATS → BigQuery → Looker Studio)

## Why this project
People Tech leaders need fast, reliable answers to:
- Where is **attrition risk** rising (by team/tenure/manager)?
- Which orgs are **unstable** (early attrition 0–90 days)?
- Where is the **hiring funnel** bottleneck?
- Which roles have high **time-to-hire** and low offer acceptance?

This repo demonstrates an end-to-end analytics workflow: **HRIS + ATS → modeled warehouse tables → executive dashboards**.

---

## Live Dashboard (Looker Studio)
View-only link: https://lookerstudio.google.com/s/qtmtqTS2tmc
 ### Screenshots
![Executive Overview](assets/01_exec_overview.png)
![Attrition + Bottleneck](assets/02_attrition_bottleneck.png)
![Hiring Funnel](assets/03_hiring_funnel.png)


---

## Architecture
**Source systems (simulated):**
- HRIS: employees, terminations
- ATS: requisitions, applications, stage events, offers

**Pipeline:**
1) CSV sources → BigQuery staging  
2) SQL transformations → marts (facts/dims)  
3) Looker Studio dashboard → Executive KPIs + drilldowns

---

## Dashboard Pages (planned)
### Page 1 — Executive Overview
- KPI cards: headcount, hires, exits, attrition %, early attrition %, open reqs, time-to-hire, offer acceptance
- Charts: attrition by dept, funnel conversion, time-to-hire by dept/role
- “Risk & Actions” box

### Page 2 — Attrition Deep Dive
- Attrition by department + tenure bands
- Early attrition analysis (0–90 days)
- Team/manager risk table

### Page 3 — Hiring Funnel Health
- Conversion rates by stage
- Bottleneck stage duration
- Time-to-hire distributions
- Source quality (optional)

---

## Repo Structure
assets/     dashboard screenshots  
data/       synthetic HRIS + ATS CSVs  
docs/       metrics dictionary, executive summary, data model diagram  
sql/        staging, marts, analysis queries  
notebooks/  data generation / exploration  

---

## Data (Synthetic)
Files in `/data`:
- `hris_employees.csv`
- `hris_terminations.csv`
- `ats_requisitions.csv`
- `ats_applications.csv`
- `ats_stage_events.csv`
- `ats_offers.csv`

---

## Documentation
- Metrics definitions: `docs/METRICS_DICTIONARY.md`
- Executive summary: `docs/executive_summary.md`
- Data quality checks: `sql/analysis/DATA_QUALITY_CHECKS.sql`

---

## Next milestones
- [ ] Load data into BigQuery + build staging tables
- [ ] Create marts (facts/dims) for headcount, attrition, funnel
- [ ] Build Looker Studio dashboard + publish link
- [ ] Add final screenshots + executive summary insights
