-- Layer A. State × ownership snapshot of stars and HF readmission publication.
-- Keep numerator and denominator. Do not average a missing star as zero.
-- No UCI tables.

SELECT
  p.state,
  p.hospital_ownership,
  COUNT(*) AS n_hospitals,
  SUM(CASE WHEN p.overall_rating IS NOT NULL THEN 1 ELSE 0 END) AS n_with_star,
  AVG(p.overall_rating) AS mean_star_among_rated,
  SUM(CASE WHEN u.score IS NOT NULL THEN 1 ELSE 0 END) AS n_with_hf_score,
  SUM(
    CASE
      WHEN u.compared_to_national = 'Worse than the national rate' THEN 1
      ELSE 0
    END
  ) AS n_hf_worse
FROM cms_facility_profile AS p
LEFT JOIN cms_unplanned_mart AS u
  ON u.facility_id = p.facility_id
 AND u.measure_id = 'READM_30_HF'
GROUP BY p.state, p.hospital_ownership
ORDER BY p.state, n_hospitals DESC;
