# Source manifest

Download these files only. Store them unchanged under `data/raw/cms/` or `data/raw/uci/`. Do not download the rest of the Hospitals catalog.

Provenance pass: **2026-09-05**. Counts, hashes, and the four questions are in [`data/reference/provenance_phase1.md`](../data/reference/provenance_phase1.md). **Downloaded** below is the file `mtime` on this machine.

Catalog pages (checked earlier, not re-fetched on the pass date): several hospital files last modified July 2026, released 2026-08-13. Footnote Crosswalk (`y9us-9xdf`) last modified 2025-09-18, released 2026-08-13.

---

## Layer A. CMS

Topic page: [Hospitals, Provider Data Catalog](https://data.cms.gov/provider-data/topics/hospitals)

On each dataset page, use **Download full dataset (CSV)**.

| Dataset | Catalog ID | Grain | URL | File on disk | Downloaded (mtime) |
|---|---|---|---|---|---|
| Hospital General Information | `xubh-q36u` | Facility | https://data.cms.gov/provider-data/dataset/xubh-q36u | `data/raw/cms/Hospital_General_Information.csv` | 2026-08-29 |
| Unplanned Hospital Visits - Hospital | `632h-zaca` | Facility × measure | https://data.cms.gov/provider-data/dataset/632h-zaca | `data/raw/cms/Unplanned_Hospital_Visits-Hospital.csv` | 2026-08-29 |
| Patient survey (HCAHPS) - Hospital | `dgck-syfz` | Facility × survey item | https://data.cms.gov/provider-data/dataset/dgck-syfz | `data/raw/cms/HCAHPS-Hospital.csv` | 2026-08-29 |
| Timely and Effective Care - Hospital | `yv7e-xc69` | Facility × measure | https://data.cms.gov/provider-data/dataset/yv7e-xc69 | `data/raw/cms/Timely_and_Effective_Care-Hospital.csv` | 2026-08-29 |

**Support files**

| File | Catalog / source | Grain | File on disk | Downloaded (mtime) |
|---|---|---|---|---|
| Footnote Crosswalk | `y9us-9xdf` https://data.cms.gov/provider-data/dataset/y9us-9xdf | Footnote code | `data/raw/cms/Footnote_Crosswalk.csv` | 2026-09-05 |
| Measure Dates | Hospitals topic page, or the bulk zip | Measure | `data/raw/cms/Measure_Dates.csv` | 2026-09-05 |
| [Hospital data dictionary (PDF)](https://data.cms.gov/provider-data/sites/default/files/data_dictionaries/hospital/HOSPITAL_Data_Dictionary.pdf) | Reference | — | `data/reference/HOSPITAL_Data_Dictionary.pdf` | on disk |

**Join key.** `Facility ID` (CCN) on every CMS hospital file. Confirmed present. General Information has 5,419 unique IDs. Measure files have fewer hospitals. Expected.

**Optional, only if a KPI needs it.** Unplanned Hospital Visits - National (`cvcs-xecj`). Complications and Deaths: skip.

**Skip.** Rural Emergency Hospital variants, PPS-exempt cancer hospital files, payment / MSPB, OAS CAHPS, birthing-friendly extras.

---

## Layer B. UCI

| File | Grain | URL | File on disk | Downloaded (mtime) |
|---|---|---|---|---|
| `diabetic_data.csv` | Encounter (101,766 unique `encounter_id`) | https://archive.ics.uci.edu/dataset/296/diabetes+130-us+hospitals+for+years+1999-2008 | `data/raw/uci/diabetic_data.csv` | 2023-07-12 (already on disk) |
| `IDS_mapping.csv` | Stacked ID lookups | same page | `data/raw/uci/IDS_mapping.csv` | 2023-07-12 (already on disk) |

License: CC BY 4.0. Cite Strack et al. 2014 when you write the README findings.

---

## Provenance rule

Notebook `01` records path, `mtime`, size, row count, key, and SHA-256 in `data/reference/`. Raw files are not edited. The provenance pass is done. CMS and UCI cleans, SQLite, SQL, CMS peer charts, and UCI segment charts are done. **Current step:** notebook `07`, triage model.
