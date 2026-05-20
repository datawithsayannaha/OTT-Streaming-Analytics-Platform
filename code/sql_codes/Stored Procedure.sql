-- Stored Procedure

CREATE OR REPLACE PROCEDURE reporting.refresh_all_reports()
LANGUAGE plpgsql
AS $$
BEGIN
    REFRESH MATERIALIZED VIEW reporting.mv_monthly_platform_metrics;
END;
$$;


CALL reporting.refresh_all_reports();

SELECT *
FROM reporting.mv_monthly_platform_metrics
ORDER BY month;