# Provenance pass

Recorded 2026-09-05. Raw files were not edited. Notebook: `notebooks/01_phase1_acquisition.ipynb`. Machine table: `provenance_phase1.csv`.

Catalog pages (from earlier checks, not re-fetched today): several hospital files showed last modified July 2026 and released 2026-08-13. Footnote Crosswalk page (`y9us-9xdf`) showed last modified 2025-09-18, released 2026-08-13.

`mtime_local` is when the file landed on this machine, not the CMS collection window.

---

## Which file is on disk, and where?

All eight required CSVs are present. No extras.

| File on disk | Path |
|---|---|
| `Hospital_General_Information.csv` | `data/raw/cms/` |
| `Unplanned_Hospital_Visits-Hospital.csv` | `data/raw/cms/` |
| `HCAHPS-Hospital.csv` | `data/raw/cms/` |
| `Timely_and_Effective_Care-Hospital.csv` | `data/raw/cms/` |
| `Footnote_Crosswalk.csv` | `data/raw/cms/` |
| `Measure_Dates.csv` | `data/raw/cms/` |
| `diabetic_data.csv` | `data/raw/uci/` |
| `IDS_mapping.csv` | `data/raw/uci/` |

Optional dictionary PDF is in `data/reference/HOSPITAL_Data_Dictionary.pdf`.

---

## When did it get here?

| File | mtime on this machine |
|---|---|
| Four hospital CSVs (General Information, Unplanned Visits, HCAHPS, Timely and Effective Care) | 2026-08-29 ~02:48 |
| `Footnote_Crosswalk.csv`, `Measure_Dates.csv` | 2026-09-05 ~05:02 |
| `diabetic_data.csv`, `IDS_mapping.csv` | 2023-07-12 (older copy already on disk) |

---

## How big? Rows, columns, size

| File | Size | Rows | Cols |
|---|---|---:|---:|
| `Hospital_General_Information.csv` | 1.4 MB | 5,419 | 38 |
| `Unplanned_Hospital_Visits-Hospital.csv` | 18.2 MB | 67,060 | 20 |
| `HCAHPS-Hospital.csv` | 100.6 MB | 325,720 | 22 |
| `Timely_and_Effective_Care-Hospital.csv` | 32.6 MB | 138,084 | 16 |
| `Footnote_Crosswalk.csv` | 3.5 KB | 32 | 2 |
| `Measure_Dates.csv` | 19 KB | 171 | 6 |
| `diabetic_data.csv` | 18.3 MB | 101,766 | 50 |
| `IDS_mapping.csv` | 2.5 KB | 67 | 2 |

SHA-256 for each file is in `provenance_phase1.csv`.

Unplanned Visits measure IDs (14): `EDAC_30_AMI`, `EDAC_30_HF`, `EDAC_30_PN`, `Hybrid_HWR`, `OP_32`, `OP_35_ADM`, `OP_35_ED`, `OP_36`, `READM_30_AMI`, `READM_30_CABG`, `READM_30_COPD`, `READM_30_HF`, `READM_30_HIP_KNEE`, `READM_30_PN`.

UCI `readmitted`: `NO` 54,864, `>30` 35,545, `<30` 11,357. Unique `patient_nbr`: 71,518.

---

## Expected grain and key?

| File | Expected | On disk |
|---|---|---|
| General Information | Facility. Key `Facility ID` | 5,419 rows, 5,419 unique IDs. One row per hospital. |
| Unplanned Visits | Facility × measure. Key `Facility ID` | 67,060 rows, 4,790 unique IDs. Has `Measure ID`, `Footnote`. |
| HCAHPS | Facility × survey item. Key `Facility ID` | 325,720 rows, 4,790 unique IDs. Has `HCAHPS Measure ID`. |
| Timely and Effective Care | Facility × measure. Key `Facility ID` | 138,084 rows, 4,658 unique IDs. Has `Measure ID`, `Footnote`. |
| Footnote Crosswalk | Footnote code | 32 unique codes. Columns `Footnote`, `Footnote Text`. |
| Measure Dates | Measure | 171 unique `Measure ID`. |
| `diabetic_data.csv` | Encounter. Key `encounter_id` | 101,766 rows, 101,766 unique IDs. Also `patient_nbr`, `readmitted`. |
| `IDS_mapping.csv` | ID labels | Stacked tables (admission, then discharge, then source). No single key. That is how UCI ships it. |

General Information has more facilities (5,419) than the measure files (about 4,600–4,790). Not every hospital appears in every measure file. Do not treat that as a failed join later. It is expected.

Pass result: required raw set is complete. CMS and UCI cleans are done. Current step is notebook `04` (two SQLite files). Do not edit these raw files.
