-- Churn Risk Analysis

DROP TABLE IF EXISTS analytics.user_churn_risk;
CREATE TABLE analytics.user_churn_risk AS
WITH last_activity AS(
	SELECT
		user_id,
		MAX(watch_start_time) AS last_watch_date,
		COUNT(*) AS total_views,
		SUM(watch_duration_minutes) AS total_watch_minutes
	FROM clean.watch_history
	GROUP BY user_id
)
SELECT
	u.user_id,
	u.full_name,
	u.city,
	la.last_watch_date,
	COALESCE(la.total_views,0) AS total_views,
	COALESCE(la.total_watch_minutes,0) AS total_watch_minutes,
	CASE
		WHEN la.last_watch_date IS NULL THEN 'No Activity'
		WHEN la.last_watch_date < CURRENT_DATE - INTERVAL '60 days' THEN 'High Risk'
        WHEN la.last_watch_date < CURRENT_DATE - INTERVAL '30 days' THEN 'Medium Risk'
        ELSE 'Active'
    END AS churn_risk
FROM clean.users u
LEFT JOIN last_activity la
    ON u.user_id = la.user_id;


-- Churn distribution

SELECT
	churn_risk,
	COUNT(*) AS total_users
FROM analytics.user_churn_risk
GROUP BY churn_risk
ORDER BY total_users DESC;

-- Top high-risk users

SELECT * FROM analytics.user_churn_risk WHERE churn_risk = 'High Risk' 
ORDER BY total_watch_minutes DESC
LIMIT 20;

-- Average watch time by churn group

SELECT
    churn_risk,
    COUNT(*) AS total_users,
    ROUND(AVG(total_watch_minutes), 2) AS avg_watch_minutes
FROM analytics.user_churn_risk
GROUP BY churn_risk
ORDER BY avg_watch_minutes DESC;
		