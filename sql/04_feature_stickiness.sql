-- =============================================================
-- 04_feature_stickiness.sql
-- Sticky features are used repeatedly; one-hit features are tried
-- once and never revisited. This file tells you which is which.
--
-- Concepts: GROUP BY with multiple levels, HAVING, CASE WHEN,
--           subqueries, date span calculation with JULIANDAY
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: Average number of uses per user per feature
-- High avg = sticky. Low avg = tried once.
-- ---------------------------------------------------------------
WITH user_feature_counts AS (
    SELECT
        fe.user_id,
        fe.feature_id,
        COUNT(*) AS uses
    FROM feature_events fe
    WHERE fe.occurred_at >= '2024-01-01'
      AND fe.occurred_at <= '2024-01-30'
    GROUP BY fe.user_id, fe.feature_id
)

SELECT
    f.feature_name,
    f.category,
    COUNT(*)                                  AS user_feature_pairs,
    ROUND(AVG(ufc.uses), 2)                   AS avg_uses_per_user,
    MIN(ufc.uses)                             AS min_uses,
    MAX(ufc.uses)                             AS max_uses,
    CASE
        WHEN AVG(ufc.uses) >= 3  THEN 'Sticky'
        WHEN AVG(ufc.uses) >= 2  THEN 'Moderate'
        ELSE                          'One-time use'
    END                                       AS stickiness_label
FROM user_feature_counts ufc
JOIN features f ON ufc.feature_id = f.feature_id
GROUP BY f.feature_id, f.feature_name, f.category
ORDER BY avg_uses_per_user DESC;


-- ---------------------------------------------------------------
-- Query 2: One-hit wonders — users who used a feature exactly once
-- High one-hit % = low stickiness / discoverability problem
-- ---------------------------------------------------------------
WITH user_feature_counts AS (
    SELECT
        fe.user_id,
        fe.feature_id,
        COUNT(*) AS uses
    FROM feature_events fe
    WHERE fe.occurred_at >= '2024-01-01'
      AND fe.occurred_at <= '2024-01-30'
    GROUP BY fe.user_id, fe.feature_id
)

SELECT
    f.feature_name,
    COUNT(*)                                                   AS total_users,
    SUM(CASE WHEN ufc.uses = 1 THEN 1 ELSE 0 END)             AS one_time_users,
    SUM(CASE WHEN ufc.uses > 1 THEN 1 ELSE 0 END)             AS repeat_users,
    ROUND(
        100.0 * SUM(CASE WHEN ufc.uses = 1 THEN 1 ELSE 0 END)
        / CAST(COUNT(*) AS REAL),
        1
    )                                                          AS one_hit_pct
FROM user_feature_counts ufc
JOIN features f ON ufc.feature_id = f.feature_id
GROUP BY f.feature_name
ORDER BY one_hit_pct DESC;


-- ---------------------------------------------------------------
-- Query 3: Days between first and last use per feature
-- Wider spread = users keep coming back over time (sticky)
-- ---------------------------------------------------------------
SELECT
    f.feature_name,
    MIN(fe.occurred_at)                                         AS first_use_date,
    MAX(fe.occurred_at)                                         AS last_use_date,
    ROUND(
        JULIANDAY(MAX(fe.occurred_at)) - JULIANDAY(MIN(fe.occurred_at)),
        0
    )                                                           AS days_span,
    COUNT(DISTINCT fe.user_id)                                  AS unique_users
FROM feature_events fe
JOIN features f ON fe.feature_id = f.feature_id
WHERE fe.occurred_at >= '2024-01-01'
  AND fe.occurred_at <= '2024-01-30'
GROUP BY f.feature_name
ORDER BY days_span DESC;
