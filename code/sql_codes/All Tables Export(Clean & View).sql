-- All Tables Export(Clean & View)

-- Clean Tables Export

COPY clean.content
TO 'E:/postgresql project  DA/OTT Streaming Analytics Platform/clean_tables/clean_content.csv'
DELIMITER ','
CSV HEADER;

COPY clean.users
TO 'E:/postgresql project  DA/OTT Streaming Analytics Platform/clean_tables/clean_users.csv'
DELIMITER ','
CSV HEADER;

COPY clean.watch_history
TO 'E:/postgresql project  DA/OTT Streaming Analytics Platform/clean_tables/clean_watch_history.csv'
DELIMITER ','
CSV HEADER;

COPY clean.sessions
TO 'E:/postgresql project  DA/OTT Streaming Analytics Platform/clean_tables/clean_sessions.csv'
DELIMITER ','
CSV HEADER;

COPY clean.payments
TO 'E:/postgresql project  DA/OTT Streaming Analytics Platform/clean_tables/clean_payments.csv'
DELIMITER ','
CSV HEADER;

COPY clean.content_genres
TO 'E:/postgresql project  DA/OTT Streaming Analytics Platform/clean_tables/clean_content_genres.csv'
DELIMITER ','
CSV HEADER;


-- Views Export

COPY (SELECT * FROM reporting.vw_user_engagement)
TO 'E:/postgresql project  DA/OTT Streaming Analytics Platform/views_export/vw_user_engagement.csv'
DELIMITER ','
CSV HEADER;

COPY (SELECT *FROM reporting.vw_content_performance)
TO 'E:/postgresql project  DA/OTT Streaming Analytics Platform/views_export/vw_content_performance.csv'
DELIMITER ','
CSV HEADER;

COPY (SELECT * FROM reporting.vw_revenue_summary)
TO 'E:/postgresql project  DA/OTT Streaming Analytics Platform/views_export/vw_revenue_summary.csv'
DELIMITER ','
CSV HEADER;

-- Materialized View Export

COPY (SELECT * FROM reporting.mv_monthly_platform_metrics)
TO 'E:/postgresql project  DA/OTT Streaming Analytics Platform/views_export/mv_monthly_platform_metrics.csv'
DELIMITER ','
CSV HEADER;