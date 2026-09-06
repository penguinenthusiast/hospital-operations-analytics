# KPI dictionary

A KPI is a contract, not a column name. Do not chart a metric that is not on this page. Scope locks live in `PROJECT_PLAN.md`.

Every entry uses: name, layer/source, grain, numerator, denominator, time window, exclusions, direction, peer rule (CMS only), interpretation, and what it is not.

---

## How to read a row

CMS already computed most Layer A rates. You are using their published `score` and `compared_to_national`, not recomputing claims. Still write what *they* counted so you do not treat a hybrid hospital-wide measure and a heart-failure measure as one number.

UCI rates you compute yourself. Crude. Unadjusted.

---

## Layer A. CMS, grain = facility unless noted

### Overall hospital star rating

- **Source.** Hospital General Information, `Hospital overall rating`.
- **Grain.** Facility.
- **Numerator / denominator.** CMS composite across measure groups. You do not rebuild the latent-variable model.
- **Window.** Current Care Compare release (record from Measure Dates / the download page).
- **Exclusions.** `Not Available` (often not enough measures or groups). Keep the rating footnote.
- **Direction.** Higher better (1–5).
- **Peer rule.** Do not rank the nation on this alone. Compare inside type × ownership × region.
- **Interpretation.** A coarse published summary of measured groups.
- **What it is not.** A UCI readmission rate. A staffing recommendation.

### Readmission group counts

- **Source.** Hospital General Information (`READM` better / no different / worse counts).
- **Grain.** Facility.
- **Numerator.** Count of published readmission measures in each bucket.
- **Denominator.** Count of readmission measures CMS assigned to that facility.
- **Window.** Same release as General Information.
- **Exclusions.** Facilities with `Not Available` group counts / footnotes.
- **Direction.** More "worse than national" is the flag for review, not a rate.
- **Peer rule.** Same peer group as stars.
- **Interpretation.** Executive snapshot: how the hospital's readmission suite sits vs national.
- **What it is not.** A single 30-day rate. Not comparable to UCI `<30`.

### Heart failure 30-day readmission (`READM_30_HF`)

- **Source.** Unplanned Hospital Visits, `Measure ID = READM_30_HF`.
- **Grain.** Facility × measure.
- **Numerator / denominator.** CMS risk-standardized 30-day HF readmission. Use published `score`, `denominator`, `lower_estimate`, `higher_estimate`.
- **Window.** `start_date` / `end_date` on the row (multi-year).
- **Exclusions.** `Not Available` or suppressing footnotes (too few cases, not reported).
- **Direction.** Lower score better. Also use `compared_to_national`.
- **Peer rule.** Ownership × type × region before calling an outlier.
- **Interpretation.** Among similar hospitals, is HF return performance worse than national?
- **What it is not.** The UCI `<30` flag. Pneumonia or COPD readmission.

Same contract for **`READM_30_PN`**, **`READM_30_COPD`**, and **`READM_30_AMI`** if volume allows. Do not build the story on `Hybrid_HWR` (often `Not Available`).

### Excess days in acute care (`EDAC_30_HF`, `EDAC_30_PN`)

- **Source.** Unplanned Hospital Visits.
- **Grain.** Facility × measure.
- **Numerator / denominator.** CMS excess days per 100 discharges (return-day / utilization), published `score`.
- **Window.** Row `start_date` / `end_date`.
- **Exclusions.** Suppressed / `Not Available`.
- **Direction.** Lower excess days better. Read the measure's "compared to national" coding; some EDAC rows use "average days per 100 discharges" instead of a better/worse label.
- **Peer rule.** Same as readmission measures.
- **Interpretation.** Extra acute days after discharge, not a second readmission rate.
- **What it is not.** `READM_30_*`.

### HCAHPS overall rating

- **Source.** Patient survey (HCAHPS). Locked IDs: `H_HSP_RATING_STAR_RATING` and `H_HSP_RATING_LINEAR_SCORE` for overall rating; `H_STAR_RATING` for the summary star; `H_COMP_1_STAR_RATING` / `H_COMP_1_LINEAR_SCORE` for nurse communication.
- **Grain.** Facility × survey item.
- **Numerator / denominator.** CMS-adjusted survey results. Use the published star or linear mean, plus completed-survey count when present.
- **Window.** Survey `Start Date` / `End Date`.
- **Exclusions.** Low completed-survey footnotes, `Not Available`. Ignore `Not Applicable` cells that are just the other column on that row type.
- **Direction.** Higher better.
- **Peer rule.** Same peer group. Correlate with readmission as association only.
- **Interpretation.** How patients rated the stay, after CMS's survey adjustment.
- **What it is not.** Proof that experience *causes* readmission.

Add at most one communication composite if the executive page needs a second experience number.

### ED throughput (Timely and Effective Care)

- **Source.** Timely and Effective Care. Locked ID: `OP_18b` (median minutes in the ED before leaving, excluding transfers and psychiatric/mental health patients). `EDV` is volume (very high / high / medium / low), a filter, not a KPI.
- **Grain.** Facility × measure.
- **Numerator / denominator.** Published score (usually minutes).
- **Window.** Row dates.
- **Exclusions.** Suppressed rows. Do not import the rest of the TE measure list onto the dashboard.
- **Direction.** Lower time better, unless the measure documentation says otherwise.
- **Peer rule.** Same peer group. ED mix differs a lot by hospital type.
- **Interpretation.** One throughput signal, not a full operations model.
- **What it is not.** UCI `time_in_hospital`.

### Profile filters (not KPIs)

Hospital type, ownership, emergency services, state. Slicers only.

---

## Layer B. UCI, grain = encounter or segment

### 30-day readmission prevalence

- **Source.** `diabetic_data.csv` field `readmitted`.
- **Grain.** Encounter, or a segment (age band, admission type, discharge group, utilization band).
- **Numerator.** Encounters with `readmitted == '<30>'`.
- **Denominator.** Eligible encounters after exclusions.
- **Window.** 1999–2008. No encounter date in the file.
- **Exclusions.** Locked in notebook 03: discharge codes 11, 13, 14, 19, 20, 21 (died or hospice), 12 (still a patient), and invalid gender. Use `eligible_for_readmit == True`.
- **Direction.** Lower better. Report with N and a confidence interval.
- **Interpretation.** Crude share of stays that returned within 30 days in this old diabetes extract.
- **What it is not.** CMS `READM_30_*`. Not risk-adjusted. `>30` is not this KPI.

### Prior-utilization bands

- **Source.** `number_inpatient`, `number_emergency`, `number_outpatient` (year before the stay).
- **Grain.** Encounter, then banded. Locked cuts: **0 / 1 / 2+** for inpatient, ED, outpatient, and prior acute (inpatient + ED).
- **Numerator / denominator.** For a rate: `<30` count in the band / encounters in the band.
- **Window.** Prior year relative to that stay, as UCI defined it.
- **Exclusions.** Same eligibility as the prevalence KPI.
- **Direction.** Higher prior use is expected to sit with higher `<30` rates. Association only.
- **Interpretation.** The main operational lever this dataset can speak to.
- **What it is not.** Proof that cutting ED visits would cut readmission.

### Length of stay

- **Source.** `time_in_hospital` (days, 1–14 by construction).
- **Grain.** Encounter, or by admission type / discharge group.
- **Numerator / denominator.** Mean or median days. Say which.
- **Window.** That stay.
- **Exclusions.** Same eligibility set unless you are describing all stays, including deaths. If deaths are in, say so.
- **Direction.** Not simply "lower better." Very short and very long stays mean different things.
- **Interpretation.** Throughput / burden context next to readmission, not a second target for Strong.
- **What it is not.** CMS ED minutes. A second LOS model.

### Segment readmission rates

Same numerator/denominator as 30-day prevalence, split by age band, admission type, discharge disposition (after leakage exclusions), and ICD-9 diagnosis group. Each cell needs N. If N is tiny, do not quote the rate.

---

## Model metrics (not operations KPIs)

These describe the triage aid, not the hospital.

- **PR-AUC.** Ranking quality under class imbalance. Primary.
- **Recall and precision at a chosen threshold.** Catch rate vs how many flags are wrong.
- **Workload.** False positives per 100 flagged, or extra reviews per 100 discharges at that threshold.
- **Calibration.** Do predicted probabilities match observed `<30>` rates?
- **Accuracy.** Footnote only. Most encounters are not `<30`.

ROC-AUC can sit next to PR-AUC. It is not the number you lead with.
