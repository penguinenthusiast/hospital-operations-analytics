# Hospital operations and readmission briefing

An **insights briefing**, not a platform. The question is how a hospital operations or quality leader can use public facility measures and encounter-level utilization data to see where readmission and resource use concentrate, and which encounter traits mark elevated 30-day return risk.

Two layers. They do not join.

- **Layer A (CMS).** Compare like hospitals on readmissions, experience, and structure. Grain: facility.
- **Layer B (UCI, 1999–2008).** Profile 30-day return and prior utilization, then score encounters as a triage aid. Grain: encounter.

Official CMS files say `Facility ID`. That is the CCN. UCI has no hospital identifier you can match to it.

---

## How to read this repo

1. This page — the finding, once it exists.
2. [`NOTES.md`](NOTES.md) — glossary, phase diary, file map.
3. [`PROJECT_PLAN.md`](PROJECT_PLAN.md) — locked Strong scope (why the layers stay apart, why Phase 7–9 are out).
4. [`docs/kpi-dictionary.md`](docs/kpi-dictionary.md) — what each number is allowed to mean.
5. Notebooks, in order. `01` is provenance. `02` is the CMS clean. `03` is the UCI clean. `04`–`07` are still stubs.

| Notebook | Phase | What it does |
|---|---|---|
| `01_phase1_acquisition.ipynb` | 1 | Download / record provenance. Raw files stay unchanged. |
| `02_phase2_cms_clean.ipynb` | 2 | CMS: inspect → clean → validate → facility mart. |
| `03_phase2_uci_clean.ipynb` | 2 | UCI: inspect → clean → validate → encounter mart. |
| `04_phase2_sql_marts.ipynb` | 2 | Two SQLite files. SQL questions. No crosswalk. |
| `05_phase3_cms_benchmarking.ipynb` | 3 | Peer-group benchmarking. |
| `06_phase4_uci_eda.ipynb` | 4 | Segment rates, LOS, prior utilization. |
| `07_phase6_readmission_model.ipynb` | 6 | Triage model. Threshold workload. |

Phase 0 is docs, not a notebook. Phase 5 is Power BI. Phase 10 is this README plus [`docs/findings-brief.md`](docs/findings-brief.md).

---

## Status / process

**2026-09-05. Phase 1 provenance pass.** I already had the four CMS hospital CSVs from 29 Aug (General Information, Unplanned Visits, HCAHPS, Timely and Effective Care). Today I added `Footnote_Crosswalk.csv` and `Measure_Dates.csv`. The UCI files were already on disk (timestamps from 2023). I ran notebook `01`: no cleaning. For each file I wrote down path, when it landed here, size, row/column counts, SHA-256, and whether the key was present (`Facility ID` on CMS, `encounter_id` on UCI).

All eight required CSVs check out. General Information is 5,419 hospitals, one row each. The measure files have fewer unique hospitals (about 4,600–4,790). That is normal, not a broken join. UCI is 101,766 encounters and 71,518 patients; 11,357 stays are `<30`. Write-up is [`data/reference/provenance_phase1.md`](data/reference/provenance_phase1.md). Manifest checkboxes are filled in [`docs/source-manifest.md`](docs/source-manifest.md).

I did not download the hospital data dictionary PDF. Optional.

**2026-09-05. Phase 2 CMS clean (notebook `02`).** Inspect, clean, validate, then save. I did not touch the raw CMS files or anything UCI.

What I did: read Facility ID as text so `010001` stays `010001`. Recoded `Not Available` and `Not Applicable` to real missing. Kept every footnote. Never filled a missing score with 0. Added Census region for peer groups. Cleaned all Unplanned Visits rows. Kept five HCAHPS items (summary star, overall rating star/linear, nurse communication). Kept the ED block from Timely and Effective Care and locked `OP_18b` as the throughput KPI. Left-joined those selected measures onto the 5,419-hospital backbone.

Checks that passed: one row per CCN on the profile and the wide mart; every measure-file hospital already sits on General Information; leftover placeholder strings are gone from score columns.

5,419 hospitals in the mart. 3,174 have a star rating. 3,253 have a published HF readmission score. 4,081 have `OP_18b`. The rest are missing on purpose.

Processed CMS files are in `data/processed/` (`cms_facility_mart.csv` is the wide table).

**2026-09-05. Phase 2 UCI clean (notebook `03`).** Same inspect / clean / check / save pass on the stay file. I turned `?` into missing, attached admission/discharge/source labels, flagged 30-day return, and marked stays we should not score (death, hospice, still in the hospital, invalid gender). Prior visits are grouped 0 / 1 / 2+. The main diagnosis is grouped into ICD-9 chapters. Weight is dropped (97% missing).

101,766 stays, 71,518 people, 11,357 thirty-day returns. 99,337 stays are eligible for a 30-day rate. Saved `data/processed/uci_encounter_mart.csv`. Next is notebook `04` (SQL).

---

## Setup

```text
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

Power BI Desktop is separate. Open files in `powerbi/` after the marts exist.

---

## What's in git (and what is not)

**In the repo:** docs, notebooks, SQL, later processed marts and figures.

**Not in git:** raw CMS/UCI dumps (rebuild from the manifest), `.venv`, SQLite rebuilds.

Public CMS hospital data and a de-identified UCI teaching extract. Not a clinical product. Not affiliated with CMS or the UCI archive.
