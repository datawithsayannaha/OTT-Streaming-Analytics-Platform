-- Final Tables

-- final_user_analytics

DROP TABLE IF EXISTS reporting.final_user_analytics;

CREATE TABLE reporting.final_user_analytics AS
SELECT * FROM reporting.vw_user_engagement;

-- final_content_analytics

DROP TABLE IF EXISTS reporting.final_content_analytics;

CREATE TABLE reporting.final_content_analytics AS
SELECT * FROM reporting.vw_content_performance;

-- final_revenue_analytics

DROP TABLE IF EXISTS reporting.final_revenue_analytics;

CREATE TABLE reporting.final_revenue_analytics AS
SELECT * FROM reporting.vw_revenue_summary;

-- complete_watch_analytics_report

DROP TABLE IF EXISTS reporting.complete_watch_analytics_report;

CREATE TABLE reporting.complete_watch_analytics_report AS
SELECT
    w.watch_id,
    w.user_id,
    u.full_name,
    u.gender,
    u.age,
    u.city,
    u.state,
    u.country AS user_country,
    u.signup_date,
    u.preferred_language,
    u.user_segment,

    w.content_id,
    c.title,
    c.content_type,
    c.director,
    c.cast_menbers,
    c.country AS content_country,
    c.listed_in,
    c.description,
    c.release_year,
    c.rating,
    c.duration_value,
    c.duration_unit,

    w.session_id,
    s.device_id,
    d.device_type,
    d.os,
    s.session_start,
    s.session_end,
    s.session_duration_minutes,
    s.traffic_source,

    w.watch_start_time,
    w.watch_duration_minutes,
    w.completion_percentage,
    w.is_completed,
    w.watch_device,

    cr.churn_risk,

    CASE
        WHEN w.completion_percentage >= 85 THEN 'High Completion'
        WHEN w.completion_percentage >= 50 THEN 'Medium Completion'
        ELSE 'Low Completion'
    END AS completion_bucket,

    CASE
        WHEN w.watch_duration_minutes >= 120 THEN 'Long Watch'
        WHEN w.watch_duration_minutes >= 45 THEN 'Medium Watch'
        ELSE 'Short Watch'
    END AS watch_duration_bucket

FROM clean.watch_history w
LEFT JOIN clean.users u
    ON w.user_id = u.user_id
LEFT JOIN clean.content c
    ON w.content_id = c.content_id
LEFT JOIN clean.sessions s
    ON w.session_id = s.session_id
LEFT JOIN clean.devices d
    ON s.device_id = d.device_id
LEFT JOIN analytics.user_churn_risk cr
    ON w.user_id = cr.user_id;
----------------------------------------------------------------

SELECT * FROM reporting.final_user_analytics;
SELECT * FROM reporting.final_content_analytics;
SELECT * FROM reporting.final_revenue_analytics;
SELECT * FROM reporting.complete_watch_analytics_report;