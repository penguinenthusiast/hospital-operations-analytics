# Findings brief

Write this last. Three to five findings. Each one has evidence, a proposed action, expected operational benefit, and what extra data would be needed to validate the action.

The final three-to-five claims wait until notebook `07` exists. Working notes below are not the briefing.

## SQL working notes (2026-09-06)

Not the briefing. Association only. Layers stay apart.

- **CMS `READM_30_HF`.** 3,253 published scores. CMS: 38 worse than national, 21 better, 3,194 no different. Rank inside type × ownership × region on every published score. Several worse hospitals are also last in a large peer (Bronson Methodist MI 28.4, 357/357; St. Barnabas NY 27.6, 317/317). Ignore 1-of-1 ranks.
- **CMS stars.** 3,174 of 5,419 rated. Mean 3.21 among the rated. Proprietary: 502 of 1,063 rated, mean 2.79. Voluntary non-profit private: 1,619 of 2,322 rated, mean 3.31. Puerto Rico: 7 of 59 rated. Missing is not zero.
- **UCI eligible `<30`.** 11,312 / 99,337 = 11.4%. Prior acute 0 / 1 / 2+: 8.4% / 12.4% / 20.4%. Emergency 11.8%, elective 10.5%. Not a CMS HF score.

## CMS chart working notes (2026-09-07)

Notebook `05`. Same layer. No UCI.

- **Large peers.** 28 groups have 20+ published HF scores (2,968 of 3,253). Widest: Midwest voluntary non-profit private acute-care, 17.7 to 28.4.
- **Review list.** CMS-worse and peer n ≥ 20: 29 hospitals (includes Bronson Methodist MI 357/357 and St. Barnabas NY 317/317).
- **Experience.** HCAHPS overall linear vs HF score: r = -0.17 (n=2,960). Weak. Association only.
- **Figures.** `figures/cms_publication_by_region.png`, `cms_hf_score_by_large_peer.png`, `cms_hf_vs_hcahps.png`, `cms_star_by_state.png`.

## UCI chart working notes (2026-09-07)

Notebook `06`. Eligible stays only. No CMS.

- **Overall.** 11,312 / 99,337 = 11.4% (about 11.2% to 11.6%).
- **Prior acute.** 0 / 1 / 2+: 8.4% / 12.4% / 20.4%. Main operational cut. Association only.
- **Age.** [20-30) 14.3%; [50-60) 9.8%; [70-80) 12.1%. Not a straight climb.
- **Discharge (n ≥ 200).** Home 9.3%; SNF 14.7%; rehab 27.7% (552 / 1,992).
- **LOS.** Median 4 days. Rate rises from 8.4% at 1 day to ~14–15% around days 8–10. Context, not a second target.
- **Figures.** `figures/uci_rate_by_prior_acute.png`, `uci_rate_by_age.png`, `uci_rate_by_admission.png`, `uci_rate_by_los.png`.

## Limitations to keep

- UCI is 1999–2008, diabetes-related stays, LOS 1–14 days.
- No hospital link between UCI and CMS.
- Observational association only.
- CMS measure definitions and star methods change across releases.
- The model is a triage aid, not a clinical tool.
