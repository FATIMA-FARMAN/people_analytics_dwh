import numpy as np
import pandas as pd
from datetime import datetime

np.random.seed(7)

def random_dates(start, end, n):
    start_u = start.value // 10**9
    end_u = end.value // 10**9
    return pd.to_datetime(np.random.randint(start_u, end_u, n), unit="s").normalize()

today = pd.Timestamp(datetime.now().date())
start_date = today - pd.Timedelta(days=730)

departments = ["Product", "Engineering", "Data", "Operations", "Customer Support", "Risk", "People"]
locations = ["Riyadh", "Dubai", "Remote"]
levels = ["Analyst", "Senior Analyst", "Specialist", "Manager"]
sources = ["LinkedIn", "Referral", "Indeed", "Company Website", "Recruiter"]

# ---------------- HRIS ----------------
n_employees = 220
employee_ids = [f"E{1000+i}" for i in range(n_employees)]
manager_ids = np.random.choice(employee_ids, size=n_employees, replace=True)

hire_dates = random_dates(start_date, today - pd.Timedelta(days=10), n_employees)
dept = np.random.choice(departments, size=n_employees, p=[0.15,0.22,0.12,0.16,0.15,0.10,0.10])
loc = np.random.choice(locations, size=n_employees, p=[0.45,0.25,0.30])
lvl = np.random.choice(levels, size=n_employees, p=[0.40,0.25,0.20,0.15])

employees = pd.DataFrame({
    "employee_id": employee_ids,
    "department": dept,
    "location": loc,
    "job_level": lvl,
    "manager_id": manager_ids,
    "hire_date": hire_dates
})

# realistic missing manager_id
employees.loc[np.random.rand(n_employees) < 0.07, "manager_id"] = np.nan

# terminations for ~12%
terminated_flag = np.random.rand(n_employees) < 0.12
terminated = employees[terminated_flag].copy()

term_dates = []
reasons = []
for _, r in terminated.iterrows():
    min_term = r["hire_date"] + pd.Timedelta(days=14)
    max_term = today - pd.Timedelta(days=1)
    td = random_dates(min_term, max_term, 1)[0] if min_term < max_term else max_term
    term_dates.append(td)
    reasons.append(np.random.choice(["Voluntary", "Performance", "End of Contract", "Role Change"]))

terminations = pd.DataFrame({
    "employee_id": terminated["employee_id"].values,
    "termination_date": term_dates,
    "termination_reason": reasons
})

# ---------------- ATS ----------------
n_reqs = 45
req_ids = [f"R{2000+i}" for i in range(n_reqs)]
req_open_dates = random_dates(today - pd.Timedelta(days=365), today - pd.Timedelta(days=30), n_reqs)

req_department = np.random.choice(departments, size=n_reqs, p=[0.15,0.25,0.12,0.16,0.12,0.10,0.10])
req_location = np.random.choice(locations, size=n_reqs, p=[0.45,0.25,0.30])
req_role = np.random.choice(["Data Analyst", "Ops Analyst", "Risk Analyst", "People Analyst", "Product Analyst"], size=n_reqs)

closed_flag = np.random.rand(n_reqs) < 0.70
req_close_dates = []
for i in range(n_reqs):
    if closed_flag[i]:
        req_close_dates.append(random_dates(req_open_dates[i] + pd.Timedelta(days=10), today, 1)[0])
    else:
        req_close_dates.append(pd.NaT)

requisitions = pd.DataFrame({
    "req_id": req_ids,
    "department": req_department,
    "location": req_location,
    "role_title": req_role,
    "open_date": req_open_dates,
    "close_date": req_close_dates
})

n_candidates = 600
candidate_ids = [f"C{3000+i}" for i in range(n_candidates)]
applications_rows = []

# each candidate applies 1–2 times
for cid in candidate_ids:
    k = 1 if np.random.rand() < 0.75 else 2
    chosen_reqs = np.random.choice(req_ids, size=k, replace=False)
    for rid in chosen_reqs:
        open_dt = requisitions.set_index("req_id").loc[rid, "open_date"]
        apply_dt = random_dates(open_dt, today, 1)[0]
        applications_rows.append([cid, rid, apply_dt, np.random.choice(sources)])

applications = pd.DataFrame(applications_rows, columns=["candidate_id", "req_id", "apply_date", "source"])
applications["application_id"] = ["A"+str(400000+i) for i in range(len(applications))]

stages = ["Applied", "Screen", "Interview", "Offer", "Hired", "Rejected"]
stage_rows = []

for _, a in applications.iterrows():
    path = ["Applied"]
    if np.random.rand() < 0.80: path.append("Screen")
    if "Screen" in path and np.random.rand() < 0.55: path.append("Interview")
    if "Interview" in path and np.random.rand() < 0.35: path.append("Offer")
    if "Offer" in path:
        path.append("Hired" if np.random.rand() < 0.75 else "Rejected")
    elif np.random.rand() < 0.35:
        path.append("Rejected")

    t = a["apply_date"]
    for s in path:
        enter = t
        exit_ = enter + pd.Timedelta(days=int(np.random.randint(1, 13)))
        stage_rows.append([a["application_id"], a["candidate_id"], a["req_id"], s, enter, exit_])
        t = exit_

stage_events = pd.DataFrame(stage_rows, columns=[
    "application_id","candidate_id","req_id","stage","stage_enter_date","stage_exit_date"
])

offers = stage_events[stage_events["stage"]=="Offer"][["application_id","candidate_id","req_id","stage_enter_date"]].copy()
offers.rename(columns={"stage_enter_date":"offer_date"}, inplace=True)
offers["offer_accepted"] = (np.random.rand(len(offers)) < 0.75).astype(int)

# ---------------- Save ----------------
employees.to_csv("data/hris_employees.csv", index=False)
terminations.to_csv("data/hris_terminations.csv", index=False)
requisitions.to_csv("data/ats_requisitions.csv", index=False)
applications.to_csv("data/ats_applications.csv", index=False)
stage_events.to_csv("data/ats_stage_events.csv", index=False)
offers.to_csv("data/ats_offers.csv", index=False)

print("Created 6 CSVs in /data")
