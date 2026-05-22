-- =============================================================
-- 01_feature_rankings.sql
-- Rank all features by total usage and unique users
--
-- Concepts: GROUP BY, COUNT, COUNT(DISTINCT), ORDER BY, LIMIT,
--           JOIN, ROUND, CAST
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: All features ranked by total event count (last 90 days)
-- ---------------------------------------------------------------
SELECT
    f.feature_name,
    f.feature_category,
    COUNT(fe.event_id)              AS total_uses,
    COUNT(DISTINCT fe.user_id)      AS unique_users
FROM features f
LEFT JOIN feature_events fe
    ON  f.feature_id = fe.feature_id
    AND fe.used_at >= DATE('2024-01-01', '-90 days')   -- last 90 days
GROUP BY f.feature_id, f.feature_name, f.feature_category
ORDER BY total_uses DESC;


-- ---------------------------------------------------------------
-- Query 2: Top 3 most-used features (the ones driving retention)
-- ---------------------------------------------------------------
SELECT
    f.feature_name,
    COUNT(fe.event_id)          AS total_uses,
    COUNT(DISTINCT fe.user_id)  AS unique_users
FROM feature_events fe
JOIN features f ON fe.feature_id = f.feature_id
WHERE fe.used_at >= DATE('2024-01-01', '-90 days')
GROUP BY f.feature_id, f.feature_name
ORDER BY total_uses DESC
LIMIT 3;


-- ---------------------------------------------------------------
-- Query 3: Bottom 3 least-used features (underutilization candidates)
-- Only include features that have been launched at least 60 days
-- ago (give new features time to gain traction)
-- ---------------------------------------------------------------
SELECT
    f.feature_name,
    f.feature_category,
    f.launched_at,
    COUNT(fe.event_id)          AS total_uses,
    COUNT(DISTINCT fe.user_id)  AS unique_users
FROM features f
LEFT JOIN feature_events fe ON f.feature_id = fe.feature_id
WHERE f.launched_at <= DATE('2024-01-01', '-60 days')  -- mature features only
GROUP BY f.feature_id, f.feature_name, f.feature_category, f.launched_at
ORDER BY total_uses ASC
LIMIT 3;


-- ---------------------------------------------------------------
-- Query 4: Usage share — what % of all events does each feature own?
-- ---------------------------------------------------------------
SELECT
    f.feature_name,
    COUNT(fe.event_id)          AS total_uses,
    ROUND(
        100.0 * COUNT(fe.event_id)
        / CAST((SELECT COUNT(*) FROM feature_events) AS REAL),
        1
    )                           AS pct_of_all_usage
FROM feature_events fe
JOIN features f ON fe.feature_id = f.feature_id
GROUP BY f.feature_id, f.feature_name
ORDER BY total_uses DESC;
