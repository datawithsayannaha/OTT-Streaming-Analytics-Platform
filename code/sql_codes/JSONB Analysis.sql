-- JSONB Analysis

-- 1. Genre from metadata

SELECT
	title,
	metadata -> 'genres' AS genres
FROM clean.content
LIMIT 20;

-- 2. Cast search

SELECT *
FROM clean.content
WHERE metadata -> 'cast' ? 'Shah Rukh Khan';

-- 3. Rating filter

SELECT
    title,
    metadata ->> 'rating' AS rating
FROM clean.content
WHERE metadata ->> 'rating' = 'TV-MA';

-- 4. Country extraction 

SELECT
    title,
    metadata ->> 'country' AS content_country
FROM clean.content
LIMIT 20;

-- 5. Titles containing a specific genre from JSONB

SELECT
    title,
    metadata -> 'genres' AS genres
FROM clean.content
WHERE metadata -> 'genres' ? 'Dramas';

-- 6. Count content by JSONB rating

SELECT
    metadata ->> 'rating' AS rating,
    COUNT(*) AS total_titles
FROM clean.content
GROUP BY metadata ->> 'rating'
ORDER BY total_titles DESC;