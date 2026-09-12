-- Layer B. Crude 30-day return rate by age, admission type, and prior-acute band.
-- Eligible stays only. Cells with fewer than 50 stays are dropped.
-- No CMS tables.

SELECT
  age,
  admission_type,
  prior_acute_band,
  SUM(readmit_30) AS n_readmit,
  COUNT(*) AS n_encounters,
  1.0 * SUM(readmit_30) / COUNT(*) AS readmit_30_rate
FROM uci_encounter_mart
WHERE eligible_for_readmit = 1
GROUP BY age, admission_type, prior_acute_band
HAVING COUNT(*) >= 50
ORDER BY readmit_30_rate DESC, n_encounters DESC;
