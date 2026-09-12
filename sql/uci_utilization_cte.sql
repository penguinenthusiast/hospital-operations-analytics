-- Layer B. Prior acute use (inpatient + ED in the year before the stay).
-- Bands are the locked 0 / 1 / 2+ cuts. Eligible stays only. No CMS tables.

WITH eligible AS (
  SELECT
    encounter_id,
    readmit_30,
    prior_acute_band,
    inpatient_band,
    emergency_band
  FROM uci_encounter_mart
  WHERE eligible_for_readmit = 1
)
SELECT
  prior_acute_band,
  SUM(readmit_30) AS n_readmit,
  COUNT(*) AS n_encounters,
  1.0 * SUM(readmit_30) / COUNT(*) AS readmit_30_rate
FROM eligible
GROUP BY prior_acute_band
ORDER BY prior_acute_band;
