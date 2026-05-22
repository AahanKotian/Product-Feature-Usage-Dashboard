-- =============================================================
-- 03_underutilized_features.sql
-- Identify the bottom features by usage — the buried ones
--
-- Concepts: ORDER BY ASC, HAVING, subqueries, LIMIT,
--           comparing to average (benchmark queries)
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: Bottom 3 features by total uses
-- The direct answer to the resume bullet point
-- ---------------------------------------------------------------
SELECT
    f.feature_name,
    f.category,
    f.launched_at,
    COUNT(fe.event_id)            AS total_uses,
    COUNT(DISTINCT fe.user_id)    AS unique_users
FROM features f
LEFT JOIN feature_events fe
    ON  f.feature_id   = fe.feature_id
    AND fe.occurred_at >= '2024-01-01'
    AND fe.occurred_at <= '2024-01-30'
GROUP BY f.feature_id, f.feature_name, f.category, f.launched_at
ORDER BY total_uses ASC
LIMIT 3;


-- ---------------------------------------------------------------
-- Query 2: Features used by fewer than 15% of all users
-- HAVING filters on the aggregated adoption rate
-- ---------------------------------------------------------------
WITH user_count AS (
    SELECT COUNT(DISTINCT user_id) AS total_users FROM users
)

SELECT
    f.feature_name,
    f.category,
    COUNT(DISTINCT fe.user_id)                    AS unique_users,
    (SELECT total_users FROM user_count)           AS total_users,
    ROUND(
        100.0 * COUNT(DISTINCT fe.user_id)
        / (SELECT total_users FROM user_count),
        1
    )                                             AS adoption_pct
FROM features f
LEFT JOIN feature_events fe
    ON  f.feature_id   = fe.feature_id
    AND fe.occurred_at >= '2024-01-01'
    AND fe.occurred_at <= '2024-01-30'
GROUP BY f.feature_id, f.feature_name, f.category
HAVING adoption_pct < 15
ORDER BY adoption_pct ASC;


-- ---------------------------------------------------------------
-- Query 3: Features below average usage with severity label
-- ---------------------------------------------------------------
WITH feature_usage AS (
    SELECT
        f.feature_id,
        f.feature_name,
        f.category,
        COUNT(fe.event_id) AS total_uses
    FROM features f
    LEFT JOIN feature_events fe
        ON  f.feature_id   = fe.feature_id
        AND fe.occurred_at >= '2024-01-01'
        AND fe.occurred_at <= '2024-01-30'
    GROUP BY f.feature_id, f.feature_name, f.category
),
avg_usage AS (
    SELECT ROUND(AVG(total_uses), 1) AS avg_uses FROM feature_usage
)

SELECT
    fu.feature_name,
    fu.category,
    fu.total_uses,
    au.avg_uses                                       AS avg_across_features,
    ROUND(fu.total_uses - au.avg_uses, 1)             AS vs_average,
    CASE
        WHEN fu.total_uses < au.avg_uses * 0.5  THEN 'Severely underutilized'
        WHEN fu.total_uses < au.avg_uses         THEN 'Below average'
        ELSE                                          'At or above average'
    END                                               AS status
FROM feature_usage fu
CROSS JOIN avg_usage au
ORDER BY fu.total_uses ASC;


-- ---------------------------------------------------------------
-- Query 4: Recently launched features with low uptake
-- ---------------------------------------------------------------
SELECT
    f.feature_name,
    f.category,
    f.launched_at,
    COUNT(fe.event_id)            AS total_uses,
    COUNT(DISTINCT fe.user_id)    AS unique_users
FROM features f
LEFT JOIN feature_events fe
    ON  f.feature_id   = fe.feature_id
    AND fe.occurred_at >= '2024-01-01'
    AND fe.occurred_at <= '2024-01-30'
WHERE f.launched_at >= '2023-01-01'
GROUP BY f.feature_id, f.feature_name, f.category, f.launched_at
HAVING unique_users < 10
ORDER BY unique_users ASC;
