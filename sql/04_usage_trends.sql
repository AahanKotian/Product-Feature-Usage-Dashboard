-- =============================================================
-- 04_usage_trends.sql
-- Track how feature usage changes week over week
--
-- Concepts: date truncation with STRFTIME, GROUP BY date,
--           WHERE date filtering, ORDER BY date, trend analysis
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: Total feature events per day (overall platform activity)
-- Good for spotting spikes, drops, or weekend patterns
-- ---------------------------------------------------------------
SELECT
    DATE(used_at)           AS usage_date,
    COUNT(event_id)         AS total_events,
    COUNT(DISTINCT user_id) AS active_users
FROM feature_events
GROUP BY DATE(used_at)
ORDER BY usage_date;


-- ---------------------------------------------------------------
-- Query 2: Weekly usage per feature category
-- Use STRFTIME to bucket dates into calendar weeks
-- ---------------------------------------------------------------
SELECT
    STRFTIME('%Y-W%W', fe.used_at)  AS week,
    f.feature_category,
    COUNT(fe.event_id)               AS total_uses,
    COUNT(DISTINCT fe.user_id)       AS unique_users
FROM feature_events fe
JOIN features f ON fe.feature_id = f.feature_id
GROUP BY week, f.feature_category
ORDER BY week, f.feature_category;


-- ---------------------------------------------------------------
-- Query 3: Daily active users (DAU) for top 3 features
-- Useful for comparing engagement trajectories side by side
-- ---------------------------------------------------------------
SELECT
    DATE(fe.used_at)        AS usage_date,
    f.feature_name,
    COUNT(DISTINCT fe.user_id) AS daily_active_users
FROM feature_events fe
JOIN features f ON fe.feature_id = f.feature_id
WHERE f.feature_name IN ('Dashboard View', 'Search', 'Export to CSV')
GROUP BY DATE(fe.used_at), f.feature_name
ORDER BY usage_date, f.feature_name;


-- ---------------------------------------------------------------
-- Query 4: First-use date per feature per user
-- Tells you how long after signup users discover each feature
-- ---------------------------------------------------------------
SELECT
    f.feature_name,
    ROUND(AVG(
        JULIANDAY(first_use.first_used_at) - JULIANDAY(u.signed_up_at)
    ), 1)                       AS avg_days_to_first_use,
    COUNT(first_use.user_id)    AS users_who_tried_it
FROM features f
JOIN (
    -- Subquery: earliest use per user per feature
    SELECT
        feature_id,
        user_id,
        MIN(used_at) AS first_used_at
    FROM feature_events
    GROUP BY feature_id, user_id
) first_use ON f.feature_id = first_use.feature_id
JOIN users u ON first_use.user_id = u.user_id
GROUP BY f.feature_id, f.feature_name
ORDER BY avg_days_to_first_use ASC;


-- ---------------------------------------------------------------
-- Query 5: 7-day rolling active users for the whole platform
-- Shows momentum — are more users becoming active over time?
-- ---------------------------------------------------------------
SELECT
    DATE(a.used_at)                     AS reference_date,
    COUNT(DISTINCT b.user_id)           AS rolling_7d_active_users
FROM feature_events a
JOIN feature_events b
    ON  b.used_at >= DATE(a.used_at, '-6 days')
    AND b.used_at <= a.used_at
GROUP BY DATE(a.used_at)
ORDER BY reference_date;
