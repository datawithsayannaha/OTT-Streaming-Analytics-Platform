-- Final CSV Export

COPY reporting.final_user_analytics
TO 'E:/postgresql project  DA/OTT Streaming Analytics Platform/final_reports_tables/final_user_analytics.csv'
DELIMITER ','
CSV HEADER;

COPY reporting.final_content_analytics
TO 'E:/postgresql project  DA/OTT Streaming Analytics Platform/final_reports_tables/final_content_analytics.csv'
DELIMITER ','
CSV HEADER;

COPY reporting.final_revenue_analytics
TO 'E:/postgresql project  DA/OTT Streaming Analytics Platform/final_reports_tables/final_revenue_analytics.csv'
DELIMITER ','
CSV HEADER;

COPY reporting.complete_watch_analytics_report
TO 'E:/postgresql project  DA/OTT Streaming Analytics Platform/final_reports_tables/complete_watch_analytics_report.csv'
DELIMITER ','
CSV HEADER;