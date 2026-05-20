SELECT *
FROM raw.user_events
LIMIT 10;

SELECT COUNT(*) FROM raw.netflix_titles;
SELECT COUNT(*) FROM raw.users;
SELECT COUNT(*) FROM raw.devices;
SELECT COUNT(*) FROM raw.subscriptions;
SELECT COUNT(*) FROM raw.payments;
SELECT COUNT(*) FROM raw.sessions;
SELECT COUNT(*) FROM raw.watch_history;
SELECT COUNT(*) FROM raw.user_events;

SELECT 'users' AS table_name, COUNT(*) FROM raw.users
UNION ALL
SELECT 'devices', COUNT(*) FROM raw.devices
UNION ALL
SELECT 'subscriptions', COUNT(*) FROM raw.subscriptions
UNION ALL
SELECT 'payments', COUNT(*) FROM raw.payments
UNION ALL
SELECT 'sessions', COUNT(*) FROM raw.sessions
UNION ALL
SELECT 'watch_history', COUNT(*) FROM raw.watch_history
UNION ALL
SELECT 'user_events', COUNT(*) FROM raw.user_events;