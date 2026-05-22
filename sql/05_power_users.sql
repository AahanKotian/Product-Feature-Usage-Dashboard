-- =============================================================
-- 05_power_users.sql
-- Who are the heaviest feature users? Are they driving all usage?
--
-- Concepts: GROUP BY + ORDER BY, CASE WHEN activity tiers,
--           HAVING, subqueries, 80/20 analysis
-- =============================================================

-- ---------------------------------------------------------------
-- Query 1: Top 10 users by total feature interactions
-- ---------------------------------------------------------------
SELECT
    u.user_id,
    u.plan_type,
    u.device_type,
    u.country,
    COUNT(fe.event_id)                AS total_interactions,
    COUNT(DISTINCT fe.feature_id)     AS features_used
FROM users u
JOIN feature_events fe ON u.user_id = fe.user_id
WHERE fe.occurred_at >= '2024-01-01'
  AND fe.occurred_at <= '2024-01-30'
GROUP BY u.user_id, u.plan_type, u.device_type, u.country
ORDER BY total_interactions DESC
LIMIT 10;


-- ---------------------------------------------------------------
-- Query 2: Bucket users into activity tiers
-- Power / Regular / Light / Dormant
-- ---------------------------------------------------------------
WITH user_activity AS (
    SELECT
        u.user_id,
        u.plan_type,
        u.device_type,
        COUNT(fe.event_id) AS total_interactions
    FROM users u
    LEFT JOIN feature_events fe
        ON  u.user_id      = fe.user_id
        AND fe.occurred_at >= '2024-01-01'
        AND fe.occurred_at <= '2024-01-30'
    GROUP BY u.user_id, u.plan_type, u.device_type
)

SELECT
    plan_type,
    CASE
        WHEN total_interactions >= 10 THEN '1 - Power (10+ events)'
        WHEN total_interactions >= 5  THEN '2 - Regular (5–9 events)'
        WHEN total_interactions >= 1  THEN '3 - Light (1–4 events)'
        ELSE                               '4 - Dormant (0 events)'
    END                               AS activity_tier,
    COUNT(*)                          AS user_count,
    ROUND(AVG(total_interactions), 1) AS avg_interactions
FROM user_activity
GROUP BY plan_type, activity_tier
ORDER BY plan_type, activity_tier;


-- ---------------------------------------------------------------
-- Query 3: 80/20 check — do top 20% of users drive 80% of usage?
-- ---------------------------------------------------------------
WITH user_totals AS (
    SELECT
        fe.user_id,
        COUNT(*) AS interactions
    FROM feature_events fe
    WHERE fe.occurred_at >= '2024-01-01'
      AND fe.occurred_at <= '2024-01-30'
    GROUP BY fe.user_id
),
ranked AS (
    SELECT
        user_id,
        interactions,
        ROW_NUMBER() OVER (ORDER BY interactions DESC) AS rank,
        COUNT(*) OVER ()                               AS total_users,
        SUM(interactions) OVER ()                      AS total_interactions
    FROM user_totals
)

SELECT
    CASE
        WHEN rank <= total_users * 0.2  THEN 'Top 20% of users'
        ELSE                                 'Bottom 80% of users'
    END                                               AS user_segment,
    COUNT(*)                                          AS user_count,
    SUM(interactions)                                 AS total_interactions,
    ROUND(
        100.0 * SUM(interactions)
        / MAX(total_interactions),
        1
    )                                                 AS pct_of_all_usage
FROM ranked
GROUP BY user_segment
ORDER BY pct_of_all_usage DESC;


-- ---------------------------------------------------------------
-- Query 4: Users who have NEVER used the app in Jan 2024
-- These are churned or disengaged users
-- ---------------------------------------------------------------
SELECT
    u.user_id,
    u.plan_type,
    u.signed_up_at,
    u.country
FROM users u
LEFT JOIN feature_events fe
    ON  u.user_id      = fe.user_id
    AND fe.occurred_at >= '2024-01-01'
    AND fe.occurred_at <= '2024-01-30'
WHERE fe.event_id IS NULL
ORDER BY u.plan_type, u.signed_up_at;
