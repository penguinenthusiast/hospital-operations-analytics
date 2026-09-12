-- Layer A. Rank hospitals inside a peer group on heart-failure 30-day readmission.
-- Peer = hospital type × ownership × Census region. Lower score is better.
-- Rank is computed on every published score, then you may filter the result.
-- Do not treat rank 1 of 1 as a peer finding. No UCI tables.

WITH peer AS (
  SELECT
    u.facility_id,
    p.facility_name,
    p.hospital_type,
    p.hospital_ownership,
    p.census_region,
    p.state,
    u.measure_id,
    u.score,
    u.compared_to_national,
    u.denominator
  FROM cms_unplanned_mart AS u
  INNER JOIN cms_facility_profile AS p
    ON p.facility_id = u.facility_id
  WHERE u.measure_id = 'READM_30_HF'
    AND u.score IS NOT NULL
),
ranked AS (
  SELECT
    facility_id,
    facility_name,
    hospital_type,
    hospital_ownership,
    census_region,
    state,
    measure_id,
    score,
    compared_to_national,
    denominator,
    RANK() OVER (
      PARTITION BY hospital_type, hospital_ownership, census_region
      ORDER BY score ASC
    ) AS rank_in_peer,
    COUNT(*) OVER (
      PARTITION BY hospital_type, hospital_ownership, census_region
    ) AS n_in_peer
  FROM peer
)
SELECT *
FROM ranked
ORDER BY census_region, hospital_type, hospital_ownership, rank_in_peer;
