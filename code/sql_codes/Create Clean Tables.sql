-- Create Clean Tables

-- clean.content

DROP TABLE IF EXISTS clean.content;

CREATE TABLE clean.content AS

SELECT
	REPLACE(n.show_id, 's', '')::INT AS content_id,
	n.type AS content_type,
	n.title,
	COALESCE(n.director,'Unknown') AS director,
	COALESCE(n.cast_members,'Unknown') AS cast_menbers,
	COALESCE(n.country,'Unknown') AS country,

	CASE
		WHEN n.date_added IS NULL OR TRIM(n.date_added)='' THEN NULL
		ELSE TO_DATE(TRIM(n.date_added),'Month DD, YYYY')
	END AS date_added,

	n.release_year,
	COALESCE(n.rating,'Unknown') AS rating,

	CASE 
        WHEN n.duration IS NULL OR TRIM(n.duration) = '' THEN 0
        ELSE SPLIT_PART(n.duration, ' ', 1)::INT
    END AS duration_value,

    CASE 
        WHEN n.duration IS NULL OR TRIM(n.duration) = '' THEN 'Unknown'
        ELSE SPLIT_PART(n.duration, ' ', 2)
    END AS duration_unit,

	COALESCE(n.listed_in,'Unknown') AS listed_in,
	COALESCE(n.description,'No Description Available') AS description,

	JSONB_BUILD_OBJECT(
        'genres', string_to_array(COALESCE(n.listed_in, 'Unknown'), ', '),
        'cast', string_to_array(COALESCE(n.cast_members, 'Unknown'), ', '),
        'country', COALESCE(n.country, 'Unknown'),
        'rating', COALESCE(n.rating, 'Unknown')
    ) AS metadata
FROM raw.netflix_titles n;


SELECT * FROM clean.content LIMIT 10;

-- clean.users

DROP TABLE IF EXISTS clean.users;
CREATE TABLE clean.users AS
SELECT DISTINCT
    user_id,
    full_name,
    gender,
    age,
    city,
    state,
    country,
    signup_date,
    preferred_language,
    user_segment
FROM raw.users
WHERE user_id IS NOT NULL;

SELECT * FROM clean.users LIMIT 10;

-- clean.devices

DROP TABLE IF EXISTS clean.devices;
CREATE TABLE clean.devices AS
SELECT DISTINCT *
FROM raw.devices
WHERE device_id IS NOT NULL
  AND user_id IS NOT NULL;

SELECT * FROM clean.devices LIMIT 10;

-- clean.subscriptions
  
DROP TABLE IF EXISTS clean.subscriptions;
CREATE TABLE clean.subscriptions AS
SELECT DISTINCT *
FROM raw.subscriptions
WHERE subscription_id IS NOT NULL
  AND user_id IS NOT NULL;

SELECT * FROM clean.subscriptions LIMIT 10;

-- clean.payments

DROP TABLE IF EXISTS clean.payments;
CREATE TABLE clean.payments AS
SELECT DISTINCT *
FROM raw.payments
WHERE payment_id IS NOT NULL
	AND amount >= 0;

SELECT * FROM clean.payments LIMIT 10;

-- clean.sessions

DROP TABLE IF EXISTS clean.sessions;
CREATE TABLE clean.sessions AS
SELECT DISTINCT *
FROM raw.sessions
WHERE session_id IS NOT NULL
  AND session_duration_minutes > 0;

SELECT * FROM clean.sessions LIMIT 10;

-- clean.watch_history

DROP TABLE IF EXISTS clean.watch_history;
CREATE TABLE clean.watch_history AS
SELECT DISTINCT *
FROM raw.watch_history
WHERE watch_id IS NOT NULL
  AND completion_percentage BETWEEN 0 AND 100
  AND watch_duration_minutes > 0;

SELECT * FROM clean.watch_history LIMIT 10;

-- user_events

DROP TABLE IF EXISTS clean.user_events;
CREATE TABLE clean.user_events AS
SELECT DISTINCT
    event_id,
    user_id,
    session_id,
    content_id,
    event_time,
    event_type,
    event_metadata
FROM raw.user_events
WHERE event_id IS NOT NULL;

SELECT * FROM clean.user_events LIMIT 10;