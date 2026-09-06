# Hospital operations analytics

A findings-first briefing, not a platform. Two public datasets, two grains, one operations question. They do not join.

## Primary question

How should a hospital operations or quality leader use public facility measures and encounter-level utilization data to see where readmission and resource use concentrate, and which encounter traits mark elevated 30-day return risk?

## Audience

**Decision-maker.** A hospital operations director or quality leader. They can prioritize review work. They cannot change CMS measure definitions, and they cannot treat this file as a live EHR.

**What they want to know.** Where readmission and resource use concentrate, which peer hospitals look worse on published CMS measures, and which encounter traits are worth a closer look at discharge.

**What this briefing can do.**

- Show CMS performance inside peer groups (type, ownership, region), not a national star leaderboard.
- Show crude 30-day return rates by UCI segment, with N and an interval.
- Score UCI encounters as a triage list: catch rate vs follow-up workload.

**What this briefing cannot do.**

- Join a CMS hospital to a UCI patient. There is no key.
- Say a hospital *causes* readmission, or that prior ED visits *cause* return.
- Recommend hiring, staffing ratios, or clinical protocols from these files alone.

Descriptive / benchmarking questions use Layer A (CMS), facility grain. Patient-level / predictive questions use Layer B (UCI), encounter grain. The model is a triage aid. If a later chart answers a different reader, it is out of scope.

## Two layers

**Layer A (CMS).** Hospital scoreboard. Compare like facilities on readmissions, patient experience, timely/effective care, and structure. Grain: facility (`Facility ID` / CCN).

**Layer B (UCI Diabetes 130-US Hospitals, 1999–2008).** Encounter microscope. Profile 30-day readmission and prior utilization, then fit an interpretable risk model used as a **triage aid**. Grain: encounter, with train/test splits by `patient_nbr`.

No crosswalk. UCI has no CCN. CMS has no encounter IDs. The years barely overlap. If a chart mixes a CMS star with a UCI `<30` rate, it is wrong.

## Locked scope

| Decision | Lock |
|---|---|
| Finish line | Strong portfolio |
| Communication layer | Power BI (`powerbi/`) |
| Analysis of record | Numbered notebooks |
| CMS files | General Information, Unplanned Hospital Visits, HCAHPS, Timely and Effective Care (few ED measures), footnote crosswalk, measure dates |
| UCI files | `diabetic_data.csv`, `IDS_mapping.csv` |
| CMS key | `Facility ID` (CCN) |
| UCI target | `readmitted == '<30'` vs not |
| Model role | Triage aid, not a clinical tool |
| Peer rule | Ownership × hospital type × region before any national rank |
| Out | Second LOS model, LLM restatement, Docker / MLflow / CMS refresh API |
| Out | Rural Emergency, PPS-exempt cancer, payment/MSPB, OAS CAHPS files |
| Out | Joining CMS hospitals to UCI encounters |

If a chart does not help the primary question, it does not go in the portfolio.

## Questions the briefing answers

1. Among similar hospitals, where does CMS readmission performance look worse than national?
2. Does patient experience move with readmission performance, as association only?
3. Which UCI segments have the highest crude 30-day return rates?
4. How strongly does prior ED/inpatient/outpatient utilization relate to `<30` readmission?
5. If we flag the top slice of model risk, what share of returns do we catch, and how much follow-up work does that create?

## Definition of done (Strong)

Clean CMS + UCI marts, KPI dictionary, SQL analyses, both EDAs, interpretable readmission model with threshold / workload analysis, four-page Power BI file, findings brief, limitations, README.

## Pipeline

0. Docs first: audience, KPI dictionary, source manifest. CMS stars and UCI `<30` are not the same "readmission rate."
1. Download only the files in `docs/source-manifest.md`. Store them unchanged under `data/raw/`.
2. Clean each layer into its own mart. Recode CMS `Not Available` to missing. Keep footnotes. Drop UCI leakage fields (expired, hospice, and anything known only after the decision point).
3. Load both marts into separate SQLite files. No join between them.
4. CMS EDA: peer groups first. UCI EDA: segments with N and confidence intervals.
5. Model on the encounter mart only. Split by patient. Logistic regression, then one tree model.
6. Power BI after the model exists. Four pages, source labeled on every KPI.
7. Findings, recommendations, limitations. Three to five claims. Each one names the evidence and what extra data would validate an action.

## Do not build

A "Hospital Operations Intelligence Platform." A blended warehouse. A national star-rating leaderboard of every hospital. A second LOS model. An LLM that restates KPIs. Docker or MLflow.

## Words

- **Grain.** What one row means (hospital, hospital × measure, or stay).
- **CCN / `facility_id`.** CMS hospital ID. Layer A only.
- **Suppression / missing.** CMS left the number blank (`Not Available`). Not zero. Not “this hospital is bad.”
- **Leakage.** Using a fact that already gives away the outcome (death in hospital).
- **Eligible stay.** UCI stay used for 30-day rates and the model. Not death, hospice, still-in, or invalid gender.
- **Triage aid.** The model sorts stays for review. It is not a diagnosis.
- **Peer group.** Compare like hospitals (type × ownership × region) before any national rank.

## Files

| Path | Role |
|---|---|
| `docs/kpi-dictionary.md` | Metric contracts |
| `docs/source-manifest.md` | Downloads |
| `data/raw/` | Unchanged downloads (not in git) |
| `data/processed/` | Clean marts |
| `data/reference/` | Provenance log |
| `sql/` | SQL questions (run from notebook `04`) |
| `database/` | Two SQLite files, not in git |
| `powerbi/` | Dashboard |

## Current status

CMS and UCI cleans are done (2026-09-05), plus a QA pass on duplicates, missingness, and label spelling. **Current step:** notebook `04` — load the processed marts into `database/cms.sqlite` and `database/uci.sqlite`, then run the queries in `sql/`. No join between the two databases. Raw files stay out of git.
