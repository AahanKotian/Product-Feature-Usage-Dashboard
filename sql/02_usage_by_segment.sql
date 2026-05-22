-- =============================================================
-- 02_usage_by_segment.sql
-- Break down feature usage by plan_type and device_type
--
-- Concepts: JOIN across 3 tables, GROUP BY multiple columns,
--           CASE WHEN for labels, pivoting with aggregation
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: Feature usage by plan type
-- Key question: "Are advanced features only used by enterprise?"
-- ---------------------------------------------------------------
SELECT
    f.feature_name,
    f.category,
    u.plan_type,
    COUNT(fe.event_id)            AS total_uses,
    COUNT(DISTINCT fe.user_id)    AS unique_users
FROM feature_events fe
JOIN users    u ON fe.user_id    = u.user_id
JOIN features f ON fe.feature_id = f.feature_id
WHERE fe.occurred_at >= '2024-01-01'
  AND fe.occurred_at <= '2024-01-30'
GROUP BY f.feature_name, f.category, u.plan_type
ORDER BY f.feature_name, u.plan_type;


-- ---------------------------------------------------------------
-- Query 2: Pivot — one row per feature, columns for each plan
-- ---------------------------------------------------------------
SELECT
    f.feature_name,
    f.category,
    COUNT(DISTINCT CASE WHEN u.plan_type = 'free'       THEN fe.user_id END) AS free_users,
    COUNT(DISTINCT CASE WHEN u.plan_type = 'pro'        THEN fe.user_id END) AS pro_users,
    COUNT(DISTINCT CASE WHEN u.plan_type = 'enterprise' THEN fe.user_id END) AS enterprise_users,
    COUNT(DISTINCT fe.user_id)                                                AS total_unique_users
FROM features f
LEFT JOIN feature_events fe ON f.feature_id   = fe.feature_id
                            AND fe.occurred_at >= '2024-01-01'
                            AND fe.occurred_at <= '2024-01-30'
LEFT JOIN users u           ON fe.user_id = u.user_id
GROUP BY f.feature_name, f.category
ORDER BY total_unique_users DESC;


-- ---------------------------------------------------------------
-- Query 3: Feature usage by device type
-- Key question: "Do mobile users miss out on certain features?"
-- ---------------------------------------------------------------
SELECT
    f.feature_name,
    u.device_type,
    COUNT(fe.event_id)            AS total_uses,
    COUNT(DISTINCT fe.user_id)    AS unique_users
FROM feature_events fe
JOIN users    u ON fe.user_id    = u.user_id
JOIN features f ON fe.feature_id = f.feature_id
WHERE fe.occurred_at >= '2024-01-01'
  AND fe.occurred_at <= '2024-01-30'
GROUP BY f.feature_name, u.device_type
ORDER BY f.feature_name, u.device_type;


-- ---------------------------------------------------------------
-- Query 4: Adoption rate per feature per plan
-- "What % of pro users have ever used Export?"
-- ---------------------------------------------------------------
WITH plan_totals AS (
    SELECT plan_type, COUNT(DISTINCT user_id) AS total_users
    FROM users
    GROUP BY plan_type
)

SELECT
    f.feature_name,
    u.plan_type,
    COUNT(DISTINCT fe.user_id)                AS users_who_used,
    pt.total_users                            AS total_plan_users,
    ROUND(
        100.0 * COUNT(DISTINCT fe.user_id)
        / CAST(pt.total_users AS REAL),
        1
    )                                         AS adoption_rate_pct
FROM features f
LEFT JOIN feature_events fe ON f.feature_id   = fe.feature_id
                            AND fe.occurred_at >= '2024-01-01'
                            AND fe.occurred_at <= '2024-01-30'
LEFT JOIN users u           ON fe.user_id = u.user_id
JOIN plan_totals pt         ON u.plan_type = pt.plan_type
GROUP BY f.feature_name, u.plan_type, pt.total_users
ORDER BY f.feature_name, u.plan_type;
