# Model card

Fill this after notebook `07` has been run. Leave it empty of numbers until then.

**Role.** Triage aid for 30-day return risk on UCI encounters. Not a clinical decision tool.

**Target.** `readmitted == '<30>'` vs not.

**Split.** By `patient_nbr`, not by encounter.

**Features.** Only fields known at or before the prediction point. Document exclusions (expired/hospice discharge, post-decision fields).

**Models.** Logistic regression first. One tree model as comparison.

**Metrics to report.** PR-AUC, recall and precision at the chosen threshold, calibration, false positives per 100 flagged (or reviews per 100 discharges). Accuracy is a footnote.

**What not to claim.** Causation. Generalization to current hospitals. A link to CMS Facility IDs.
