-- ===============================================
--                   Create Views
-- ================================================

-- Final user engagement view

DROP VIEW IF EXISTS reporting.vw_user_engagement;

CREATE VIEW reporting.vw_user_engagement AS
SELECT
    u.user_id,
    u.full_name,
    u.gender,
    u.age,
    u.city,
    u.state,
    u.signup_date,
    COUNT(w.watch_id) AS total_views,
    COUNT(DISTINCT w.content_id) AS unique_content_watched,
    COALESCE(SUM(w.watch_duration_minutes), 0) AS total_watch_minutes,
    ROUND(COALESCE(AVG(w.completion_percentage), 0), 2) AS avg_completion_percentage,
    MAX(w.watch_start_time) AS last_watch_date,
    CASE
        WHEN COALESCE(SUM(w.watch_duration_minutes), 0) >= 3000 THEN 'Power User'
        WHEN COALESCE(SUM(w.watch_duration_minutes), 0) >= 1000 THEN 'Regular User'
        WHEN COALESCE(SUM(w.watch_duration_minutes), 0) > 0 THEN 'Light User'
        ELSE 'Inactive User'
    END AS engagement_level
FROM clean.users u
LEFT JOIN clean.watch_history w
    ON u.user_id = w.user_id
GROUP BY
    u.user_id, u.full_name, u.gender, u.age, u.city, u.state, u.signup_date;



-- Final content performance view

DROP VIEW IF EXISTS reporting.vw_content_performance;

CREATE VIEW reporting.vw_content_performance AS
SELECT
    c.content_id,
    c.title,
    c.content_type,
    c.release_year,
    c.rating,
    c.duration_value,
    c.duration_unit,
    COUNT(w.watch_id) AS total_views,
    COUNT(DISTINCT w.user_id) AS unique_viewers,
    COALESCE(SUM(w.watch_duration_minutes), 0) AS total_watch_minutes,
    ROUND(COALESCE(AVG(w.completion_percentage), 0), 2) AS avg_completion_percentage
FROM clean.content c
LEFT JOIN clean.watch_history w
    ON c.content_id = w.content_id
GROUP BY
    c.content_id, c.title, c.content_type, c.release_year, c.rating, c.duration_value, c.duration_unit;



-- Final revenue view

DROP VIEW IF EXISTS reporting.vw_revenue_summary;

CREATE VIEW reporting.vw_revenue_summary AS
SELECT
	DATE_TRUNC('month' , payment_date) AS revenue_month,
	payment_method,
	COUNT(payment_id) AS total_transactions,
	COALESCE(SUM(amount),0) AS total_revenue,
	COUNT(*) FILTER (WHERE payment_status = 'Success') AS successful_payments,
    COUNT(*) FILTER (WHERE payment_status = 'Failed') AS failed_payments
FROM clean.payments
GROUP BY DATE_TRUNC('month', payment_date), payment_method;


-----------------------------------------------------
SELECT * FROM reporting.vw_user_engagement LIMIT 10;
SELECT * FROM reporting.vw_content_performance LIMIT 10;
SELECT * FROM reporting.vw_revenue_summary LIMIT 10;