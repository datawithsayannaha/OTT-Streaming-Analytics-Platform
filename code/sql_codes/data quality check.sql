-- data quality check

-- Duplicate check

SELECT user_id, COUNT(*)
FROM raw.users
GROUP BY user_id
HAVING COUNT(*)>1

SELECT watch_id, COUNT(*)
FROM raw.watch_history
GROUP BY watch_id
HAVING COUNT(*) > 1;

SELECT device_id, COUNT(*) FROM raw.devices GROUP BY device_id HAVING COUNT(*) > 1;
SELECT subscription_id, COUNT(*) FROM raw.subscriptions GROUP BY subscription_id HAVING COUNT(*) > 1;
SELECT payment_id, COUNT(*) FROM raw.payments GROUP BY payment_id HAVING COUNT(*) > 1;
SELECT session_id, COUNT(*) FROM raw.sessions GROUP BY session_id HAVING COUNT(*) > 1;
SELECT event_id, COUNT(*) FROM raw.user_events GROUP BY event_id HAVING COUNT(*) > 1;

SELECT show_id, COUNT(*) FROM raw.netflix_titles GROUP BY show_id HAVING COUNT(*) > 1;

-- Null check

SELECT COUNT(*) AS null_user_id
FROM raw.users
WHERE user_id IS NULL;

SELECT COUNT(*) AS null_content_id
FROM raw.watch_history
WHERE content_id IS NULL;

SELECT COUNT(*) AS null_device_user_id FROM raw.devices WHERE user_id IS NULL;
SELECT COUNT(*) AS null_subscription_user_id FROM raw.subscriptions WHERE user_id IS NULL;
SELECT COUNT(*) AS null_payment_user_id FROM raw.payments WHERE user_id IS NULL;
SELECT COUNT(*) AS null_session_user_id FROM raw.sessions WHERE user_id IS NULL;
SELECT COUNT(*) AS null_watch_user_id FROM raw.watch_history WHERE user_id IS NULL;
SELECT COUNT(*) AS null_event_user_id FROM raw.user_events WHERE user_id IS NULL;

SELECT COUNT(*) AS null_show_id FROM raw.netflix_titles WHERE show_id IS NULL;
SELECT COUNT(*) AS null_title FROM raw.netflix_titles WHERE title IS NULL;

SELECT COUNT(*) AS null_type FROM raw.netflix_titles WHERE type IS NULL;

SELECT COUNT(*) AS null_release_year FROM raw.netflix_titles WHERE release_year IS NULL;

SELECT *
FROM raw.netflix_titles
WHERE duration IS NULL
   OR duration = '';

SELECT *
FROM raw.netflix_titles
WHERE listed_in IS NULL;

SELECT *
FROM raw.netflix_titles
WHERE date_added IS NULL;

SELECT * 
FROM raw.netflix_titles
WHERE rating IS NULL;

-- =========================================
-- NULL VALUE CHECK SUMMARY
-- =========================================

SELECT 
    'raw.users' AS table_name,
    'user_id' AS column_name,
    COUNT(*) AS null_count
FROM raw.users
WHERE user_id IS NULL

UNION ALL

SELECT 
    'raw.watch_history',
    'content_id',
    COUNT(*)
FROM raw.watch_history
WHERE content_id IS NULL

UNION ALL

SELECT 
    'raw.devices',
    'user_id',
    COUNT(*)
FROM raw.devices
WHERE user_id IS NULL

UNION ALL

SELECT 
    'raw.subscriptions',
    'user_id',
    COUNT(*)
FROM raw.subscriptions
WHERE user_id IS NULL

UNION ALL

SELECT 
    'raw.payments',
    'user_id',
    COUNT(*)
FROM raw.payments
WHERE user_id IS NULL

UNION ALL

SELECT 
    'raw.sessions',
    'user_id',
    COUNT(*)
FROM raw.sessions
WHERE user_id IS NULL

UNION ALL

SELECT 
    'raw.watch_history',
    'user_id',
    COUNT(*)
FROM raw.watch_history
WHERE user_id IS NULL

UNION ALL

SELECT 
    'raw.user_events',
    'user_id',
    COUNT(*)
FROM raw.user_events
WHERE user_id IS NULL

UNION ALL

SELECT 
    'raw.netflix_titles',
    'show_id',
    COUNT(*)
FROM raw.netflix_titles
WHERE show_id IS NULL

UNION ALL

SELECT 
    'raw.netflix_titles',
    'title',
    COUNT(*)
FROM raw.netflix_titles
WHERE title IS NULL

UNION ALL

SELECT 
    'raw.netflix_titles',
    'type',
    COUNT(*)
FROM raw.netflix_titles
WHERE type IS NULL

UNION ALL

SELECT 
    'raw.netflix_titles',
    'release_year',
    COUNT(*)
FROM raw.netflix_titles
WHERE release_year IS NULL

UNION ALL

SELECT 
    'raw.netflix_titles',
    'duration',
    COUNT(*)
FROM raw.netflix_titles
WHERE duration IS NULL
   OR duration = ''

UNION ALL

SELECT 
    'raw.netflix_titles',
    'listed_in',
    COUNT(*)
FROM raw.netflix_titles
WHERE listed_in IS NULL

UNION ALL

SELECT 
    'raw.netflix_titles',
    'date_added',
    COUNT(*)
FROM raw.netflix_titles
WHERE date_added IS NULL

UNION ALL

SELECT 
    'raw.netflix_titles',
    'rating',
    COUNT(*)
FROM raw.netflix_titles
WHERE rating IS NULL

ORDER BY table_name, column_name;

-- Invalid Values

SELECT *
FROM raw.watch_history
WHERE completion_percentage<0
	OR completion_percentage>100

SELECT *
FROM raw.sessions
WHERE session_duration_minutes <= 0;

SELECT *
FROM raw.payments
WHERE amount < 0;

SELECT * FROM raw.users WHERE age < 18 OR age > 80;

SELECT * FROM raw.subscriptions WHERE monthly_price < 0;

SELECT * FROM raw.netflix_titles
WHERE release_year < 1900
   OR release_year > EXTRACT(YEAR FROM CURRENT_DATE);



SELECT DISTINCT type FROM raw.netflix_titles;

SELECT DISTINCT rating
FROM raw.netflix_titles
ORDER BY rating;