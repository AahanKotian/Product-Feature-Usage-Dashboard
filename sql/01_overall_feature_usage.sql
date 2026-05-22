-- =============================================================
-- 01_overall_feature_usage.sql
-- Rank all features by total usage and unique users
--
-- Concepts: GROUP BY, COUNT, COUNT(DISTINCT), ORDER BY,
--           ROUND, LEFT JOIN (to catch zero-use features)
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: Total events and unique users per feature (ranked)
-- ---------------------------------------------------------------
SELECT
    f.feature_name,
    f.category,
    COUNT(fe.event_id)            AS total_uses,
    COUNT(DISTINCT fe.user_id)    AS unique_users,
    ROUND(
        CAST(COUNT(fe.event_id) AS REAL)
        / NULLIF(COUNT(DISTINCT fe.user_id), 0),
        1
    )                             AS avg_uses_per_user
FROM features f
LEFT JOIN feature_events fe
    ON  f.feature_id    = fe.feature_id
    AND fe.occurred_at >= '2024-01-01'
    AND fe.occurred_at <= '2024-01-30'
GROUP BY f.feature_id, f.feature_name, f.category
ORDER BY total_uses DESC;


-- ---------------------------------------------------------------
-- Query 2: Usage share — what % of all events does each feature own?
-- ---------------------------------------------------------------
WITH total_events AS (
    SELECT COUNT(*) AS grand_total
    FROM feature_events
    WHERE occurred_at >= '2024-01-01'
      AND occurred_at <= '2024-01-30'
)

SELECT
    f.feature_name,
    COUNT(fe.event_id)                                AS total_uses,
    ROUND(
        100.0 * COUNT(fe.event_id)
        / (SELECT grand_total FROM total_events),
        1
    )                                                 AS pct_of_all_usage
FROM features f
LEFT JOIN feature_events fe
    ON  f.feature_id   = fe.feature_id
    AND fe.occurred_at >= '2024-01-01'
    AND fe.occurred_at <= '2024-01-30'
GROUP BY f.feature_id, f.feature_name
ORDER BY total_uses DESC;


-- ---------------------------------------------------------------
-- Query 3: Daily active usage per feature (trend view)
-- Tells you if usage is growing, flat, or declining
-- ---------------------------------------------------------------
SELECT
    fe.occurred_at                AS date,
    f.feature_name,
    COUNT(DISTINCT fe.user_id)    AS daily_active_users
FROM feature_events fe
JOIN features f ON fe.feature_id = f.feature_id
WHERE fe.occurred_at >= '2024-01-01'
  AND fe.occurred_at <= '2024-01-30'
GROUP BY fe.occurred_at, f.feature_name
ORDER BY fe.occurred_at, daily_active_users DESC;
