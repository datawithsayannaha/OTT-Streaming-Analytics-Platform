-- ===============================================
--                Materialized View
-- ================================================

DROP MATERIALIZED VIEW IF EXISTS reporting.mv_monthly_platform_metrics;

CREATE MATERIALIZED VIEW reporting.mv_monthly_platform_metrics AS
SELECT
	DATE_TRUNC('month', w.watch_start_time) AS month,
	COUNT(DISTINCT w.user_id) AS monthly_active_users,
	COUNT(w.watch_id) AS total_views,
	COALESCE(SUM(w.watch_duration_minutes),0) AS total_watch_minutes,
	ROUND(COALESCE(AVG(w.completion_percentage), 0), 2) AS avg_completion
FROM clean.watch_history w
GROUP BY DATE_TRUNC('month', w.watch_start_time);

REFRESH MATERIALIZED VIEW reporting.mv_monthly_platform_metrics;

SELECT * FROM reporting.mv_monthly_platform_metrics
ORDER BY month;