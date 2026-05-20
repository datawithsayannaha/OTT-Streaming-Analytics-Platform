-- Function

CREATE OR REPLACE FUNCTION analytics.get_user_engagement_level(total_minutes NUMERIC)
RETURNS TEXT AS $$
BEGIN
    RETURN CASE
        WHEN total_minutes >= 3000 THEN 'Power User'
        WHEN total_minutes >= 1000 THEN 'Regular User'
        WHEN total_minutes > 0 THEN 'Light User'
        ELSE 'Inactive User'
    END;
END;
$$ LANGUAGE plpgsql;

SELECT analytics.get_user_engagement_level(5000);

SELECT analytics.get_user_engagement_level(1500);

SELECT analytics.get_user_engagement_level(200);

SELECT analytics.get_user_engagement_level(0);

SELECT
    user_id,
    SUM(watch_duration_minutes) AS total_watch_time,
    analytics.get_user_engagement_level(
        SUM(watch_duration_minutes)
    ) AS engagement_level
FROM clean.watch_history
GROUP BY user_id;