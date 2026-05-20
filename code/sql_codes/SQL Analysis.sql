-- =========================================
--                   SQL Analysis
-- =========================================
'''
1. TOP 10 Most Engaged Users
2. Most Rewatched Content
3. Average Gap Between User Sessions
4. Completion Rate by Genre
5. Monthly Active Users
6. User Retention Signal
7. Device-wise Watch Behavior
8. Revenue Contribution by User Segment
9. Rating-wise User Engagement
10. Release Year-wise Watch Trend
11. Top Titles by Engagement
12. Country Wise Content Demand 
13. Age Group vs Content Rating
14. Old vs New Content Engagement
15. Title Drop-off Analysis
16. Movie vs TV Show Count
17. TV Show Season Analysis
18. Latest Added Titles
19. Oldest Released Titles
20. Content Added by Month
21. TOP Genre
22. Genre-wise Watch Time
23. User Favourite Genre
24. Top 3 Genres Per User (DENSE_RANK)
25. Running Monthly Watch Time
26. 7-Days Moving Average Watch Trend
27. 30-Days Moving Average Watch Trend
28. User Watch Streak Analysis
29. Revenue Growth Month-over-Month
30. User Lifetime Value (LTV)
31. Multiple Watches Detection
32. Most Loyal Users by Active Months
33. Genre Retention Analysis
34. Cohort Analysis
'''
-- =========================================


-- 1. TOP 10 Most Engaged Users

SELECT 
	u.user_id,
	u.full_name,
	COUNT (w.watch_id) AS total_views,
	SUM(w.watch_duration_minutes) AS total_watch_minutes,
	RANK() OVER(
			ORDER BY SUM (w.watch_duration_minutes) DESC
	) AS engagement_rank
FROM clean.users u
JOIN clean.watch_history w
	ON u.user_id = w.user_id
GROUP BY u.user_id,u.full_name
LIMIT 10;

-- 2. Most Rewatched Content
SELECT
	c.title,
	COUNT(*) AS total_views,
	COUNT(DISTINCT w.user_id) AS unique_users,
	ROUND(COUNT(*)::NUMERIC / COUNT(DISTINCT w.user_id),2) AS rewatch_ratio
FROM clean.watch_history w
JOIN clean.content c
	ON w.content_id = c.content_id
GROUP BY c.title
HAVING COUNT(*) >50 
ORDER BY rewatch_ratio DESC;

-- 3. Average Gap Between User Sessions

WITH session_gaps AS(
	SELECT
		user_id,
		session_start,
		LAG(session_start) OVER(
			PARTITION BY user_id
			ORDER BY session_start
		) AS previous_session
		FROM clean.sessions
)
SELECT
	user_id,
	ROUND(AVG(EXTRACT(EPOCH FROM(session_start - previous_session))/3600),2) AS avg_gap_hours
FROM session_gaps
WHERE previous_session IS NOT NULL
GROUP BY user_id;

-- 4. Completion Rate by Genre

SELECT
    cg.genre_name,
    ROUND(
        AVG(w.completion_percentage),
        2
    ) AS avg_completion_rate
FROM clean.watch_history w
JOIN clean.content_genres cg
    ON w.content_id = cg.content_id
GROUP BY cg.genre_name
ORDER BY avg_completion_rate DESC;

-- 5. Monthly Active Users

SELECT
	DATE_TRUNC('month',watch_start_time) AS month,
	COUNT(DISTINCT user_id) AS monthly_active_users
FROM clean.watch_history
GROUP BY DATE_TRUNC('month',watch_start_time)
ORDER BY month;

-- 6. User Retention Signal

-- Users who returned after 7 days.

WITH user_activity AS (
    SELECT
        user_id,
        DATE(watch_start_time) AS activity_date
    FROM clean.watch_history
),
return_users AS (
    SELECT
        a.user_id,
        a.activity_date,
        LEAD(a.activity_date) OVER (
            PARTITION BY a.user_id
            ORDER BY a.activity_date
        ) AS next_activity_date
    FROM user_activity a
)
SELECT
    COUNT(DISTINCT user_id) AS retained_users
FROM return_users
WHERE next_activity_date IS NOT NULL
  AND next_activity_date - activity_date >= 7;

-- 7. Device-wise Watch Behavior

SELECT
    watch_device,
    COUNT(*) AS total_views,
    SUM(watch_duration_minutes) AS total_watch_time,
    ROUND(AVG(completion_percentage),2) AS avg_completion
FROM clean.watch_history
GROUP BY watch_device
ORDER BY total_watch_time DESC;

-- 8. Revenue Contribution by User Segment

SELECT
    u.user_segment,
    COUNT(DISTINCT p.user_id) AS paying_users,
    SUM(p.amount) AS total_revenue
FROM clean.payments p
JOIN clean.users u
    ON p.user_id = u.user_id
WHERE p.payment_status = 'Success'
GROUP BY u.user_segment
ORDER BY total_revenue DESC;

-- 9. Rating-wise User Engagement

SELECT
    c.rating,
    COUNT(w.watch_id) AS total_views,
    COUNT(DISTINCT w.user_id) AS unique_viewers,
    SUM(w.watch_duration_minutes) AS total_watch_minutes,
    ROUND(AVG(w.completion_percentage), 2) AS avg_completion
FROM clean.watch_history w
JOIN clean.content c
    ON w.content_id = c.content_id
GROUP BY c.rating
ORDER BY total_watch_minutes DESC;

-- 10. Release Year-wise Watch Trend

SELECT
    c.release_year,
    COUNT(w.watch_id) AS total_views,
    SUM(w.watch_duration_minutes) AS total_watch_minutes
FROM clean.watch_history w
JOIN clean.content c
    ON w.content_id = c.content_id
GROUP BY c.release_year
ORDER BY c.release_year;

-- 11. Top Titles by Engagement

SELECT
    c.title,
    c.content_type,
    c.release_year,
    c.rating,
    COUNT(w.watch_id) AS total_views,
    COUNT(DISTINCT w.user_id) AS unique_viewers,
    SUM(w.watch_duration_minutes) AS total_watch_minutes,
    ROUND(AVG(w.completion_percentage), 2) AS avg_completion
FROM clean.watch_history w
JOIN clean.content c
    ON w.content_id = c.content_id
GROUP BY
    c.title, c.content_type, c.release_year, c.rating
ORDER BY total_watch_minutes DESC
LIMIT 20;

-- 12. Country Wise Content Demand 

SELECT
	c.country AS content_country,
	COUNT(w.watch_id) AS total_views,
	COUNT(DISTINCT w.user_id) AS unique_viewers,
	SUM(w.watch_duration_minutes) AS total_watch_minutes
FROM clean.watch_history w
JOIN clean.content c
	ON w.content_id = c.content_id
WHERE c.country <> 'Unknown'
GROUP BY c.country
ORDER BY total_watch_minutes DESC
LIMIT 20;

 -- 13. Age Group vs Content Rating

 SELECT
 	CASE 
	 	WHEN u.age BETWEEN 18 AND 24 THEN '18-24'
		WHEN u.age BETWEEN 25 AND 34 THEN '25-34'
        WHEN u.age BETWEEN 35 AND 44 THEN '35-44'
        WHEN u.age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
	c.rating,
	COUNT(w.watch_id) AS total_views,
	SUM(w.watch_duration_minutes) AS total_watch_minutes
FROM clean.watch_history w
JOIN clean.users u
	ON w.user_id = u.user_id
JOIN clean.content c
	ON w.content_id = c.content_id
GROUP BY age_group,c.rating
ORDER BY age_group,total_watch_minutes DESC;

-- 14. Old vs New Content Engagement

SELECT
    CASE
        WHEN c.release_year >= 2020 THEN 'New Content'
        WHEN c.release_year BETWEEN 2010 AND 2019 THEN 'Modern Content'
        WHEN c.release_year BETWEEN 2000 AND 2009 THEN 'Old Content'
        ELSE 'Classic Content'
    END AS content_age_bucket,
    COUNT(w.watch_id) AS total_views,
    SUM(w.watch_duration_minutes) AS total_watch_minutes,
    ROUND(AVG(w.completion_percentage), 2) AS avg_completion
FROM clean.watch_history w
JOIN clean.content c
    ON w.content_id = c.content_id
GROUP BY content_age_bucket
ORDER BY total_watch_minutes DESC;

-- 15. Title Drop-off Analysis

SELECT
    c.title,
    c.content_type,
    COUNT(w.watch_id) AS total_views,
    ROUND(AVG(w.completion_percentage), 2) AS avg_completion,
    COUNT(*) FILTER (WHERE w.completion_percentage < 40) AS low_completion_views,
    ROUND(
        COUNT(*) FILTER (WHERE w.completion_percentage < 40)::NUMERIC
        / COUNT(*) * 100,
        2
    ) AS dropoff_rate_pct
FROM clean.watch_history w
JOIN clean.content c
    ON w.content_id = c.content_id
GROUP BY c.title, c.content_type
HAVING COUNT(w.watch_id) >= 20
ORDER BY dropoff_rate_pct DESC;

-- 16. Movie vs TV Show Count

SELECT
    content_type,
    COUNT(*) AS total_content
FROM clean.content
GROUP BY content_type
ORDER BY total_content DESC;

-- 17. TV Show Season Analysis

SELECT
    MIN(duration_value) AS min_seasons,
    MAX(duration_value) AS max_seasons,
    ROUND(AVG(duration_value), 2) AS avg_seasons
FROM clean.content
WHERE content_type = 'TV Show'
  AND duration_unit ILIKE 'Season%';

-- 18. Latest Added Titles

SELECT
    title,
    content_type,
    date_added,
    rating
FROM clean.content
WHERE date_added IS NOT NULL
ORDER BY date_added DESC
LIMIT 20;

-- 19. Oldest Released Titles

SELECT
    title,
    content_type,
    release_year,
    rating
FROM clean.content
ORDER BY release_year ASC
LIMIT 20;

-- 20. Content Added by Month

SELECT
    DATE_TRUNC('month', date_added) AS added_month,
    COUNT(*) AS total_added
FROM clean.content
WHERE date_added IS NOT NULL
GROUP BY DATE_TRUNC('month', date_added)
ORDER BY added_month;

-- 21. TOP Genre

SELECT
	genre_name,
	COUNT(*) AS total_titles
FROM clean.content_genres
GROUP BY genre_name;


-- 22. Genre-wise Watch Time

SELECT
    cg.genre_name,
    SUM(w.watch_duration_minutes) AS total_watch_time
FROM clean.watch_history w
JOIN clean.content_genres cg
    ON w.content_id = cg.content_id
GROUP BY cg.genre_name;

-- 23. User Favourite Genre

SELECT
	w.user_id,
	cg.genre_name,
	COUNT(*) AS total_views
FROM clean.watch_history w
JOIN clean.content_genres cg
	ON w.content_id = cg.content_id
GROUP BY w.user_id, cg.genre_name;

-- 24. Top 3 Genres Per User (DENSE_RANK)

WITH user_genre_watch AS (
    SELECT
        w.user_id,
        cg.genre_name,
        COUNT(*) AS total_views,
        SUM(w.watch_duration_minutes) AS total_watch_time
    FROM clean.watch_history w
    JOIN clean.content_genres cg
        ON w.content_id = cg.content_id
    GROUP BY w.user_id, cg.genre_name
),
ranked_genres AS (
    SELECT
        *,
        DENSE_RANK() OVER(
            PARTITION BY user_id
            ORDER BY total_watch_time DESC
        ) AS genre_rank
    FROM user_genre_watch
)
SELECT * FROM ranked_genres WHERE genre_rank <= 3;
		
-- 25. Running Monthly Watch Time

WITH monthly_watch AS (
    SELECT
        DATE_TRUNC('month', watch_start_time) AS watch_month,
        SUM(watch_duration_minutes) AS monthly_watch_time
    FROM clean.watch_history
    GROUP BY DATE_TRUNC('month', watch_start_time)
)
SELECT
    watch_month,
    monthly_watch_time,
    SUM(monthly_watch_time) OVER(
        ORDER BY watch_month
    ) AS cumulative_watch_time
FROM monthly_watch;

-- 26. 7-Days Moving Average Watch Trend

WITH daily_watch AS (
    SELECT
        DATE(watch_start_time) AS watch_date,
        SUM(watch_duration_minutes) AS total_watch
    FROM clean.watch_history
    GROUP BY DATE(watch_start_time)
)
SELECT
    watch_date,
    total_watch,
    ROUND(
        AVG(total_watch) OVER(
            ORDER BY watch_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_avg_7_days
FROM daily_watch;

-- 27. 30-Days Moving Average Watch Trend

WITH thirty_days_watch AS (
    SELECT
        DATE(watch_start_time) AS watch_date,
        SUM(watch_duration_minutes) AS total_watch
    FROM clean.watch_history
    GROUP BY DATE(watch_start_time)
)

SELECT
    watch_date,
    total_watch,
    ROUND(
        AVG(total_watch) OVER(
            ORDER BY watch_date
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_avg_30_days

FROM thirty_days_watch
ORDER BY watch_date;

-- 28. User Watch Streak Analysis

WITH daily_activity AS(
	SELECT DISTINCT
		user_id,
		DATE(watch_start_time) AS activity_date
	FROM clean.watch_history
),
streak_groups AS(
	SELECT
		user_id,
		activity_date,
		activity_date - 
		ROW_NUMBER() OVER(
			PARTITION BY user_id
			ORDER BY activity_date
		)::INT AS streak_group
	FROM daily_activity
)
SELECT 
	user_id,
	MIN(activity_date) AS streak_start,
	MAX(activity_date) AS streak_end,
	COUNT(*) AS streak_days
FROM streak_groups
GROUP BY user_id,streak_group
ORDER BY streak_days DESC;

-- 29. Revenue Growth Month-over-Month

WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', payment_date) AS revenue_month,
        SUM(amount) AS total_revenue
    FROM clean.payments
    WHERE payment_status = 'Success'
    GROUP BY DATE_TRUNC('month', payment_date)
),
growth AS (
    SELECT
        revenue_month,
        total_revenue,
        LAG(total_revenue) OVER(ORDER BY revenue_month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    revenue_month,
    total_revenue,
    previous_month_revenue,
    ROUND(
        (total_revenue - previous_month_revenue)::NUMERIC
        / NULLIF(previous_month_revenue, 0) * 100,
        2
    ) AS revenue_growth_pct
FROM growth;

-- 30. User Lifetime Value (LTV)

SELECT
    u.user_id,
    u.full_name,
    COUNT(DISTINCT p.payment_id) AS total_payments,
    SUM(p.amount) AS lifetime_value,
    ROUND(AVG(p.amount),2) AS avg_payment
FROM clean.users u
JOIN clean.payments p
    ON u.user_id = p.user_id
WHERE p.payment_status = 'Success'
GROUP BY u.user_id, u.full_name
ORDER BY lifetime_value DESC;

-- 31. Multiple Watches Detection

WITH daily_content_watch AS (
    SELECT
        user_id,
        DATE(watch_start_time) AS watch_date,
        COUNT(*) AS titles_watched,
        SUM(watch_duration_minutes) AS total_watch_time
    FROM clean.watch_history
    GROUP BY user_id, DATE(watch_start_time)
)
SELECT
    *,
    CASE
        WHEN titles_watched >= 3
         AND total_watch_time >= 200
        THEN 'Multiple Watcher'
        ELSE 'Normal Viewer'
    END AS viewer_type
FROM daily_content_watch;

-- 32. Most Loyal Users by Active Months

WITH monthly_activity AS (
    SELECT DISTINCT
        user_id,
        DATE_TRUNC('month', watch_start_time) AS active_month
    FROM clean.watch_history
)
SELECT
    user_id,
    COUNT(active_month) AS active_months,
    DENSE_RANK() OVER(
        ORDER BY COUNT(active_month) DESC
    ) AS loyalty_rank
FROM monthly_activity
GROUP BY user_id;

-- 33. Genre Retention Analysis

WITH first_genre AS (
    SELECT
        w.user_id,
        cg.genre_name,
        MIN(DATE(w.watch_start_time)) AS first_watch_date
    FROM clean.watch_history w
    JOIN clean.content_genres cg
        ON w.content_id = cg.content_id
    GROUP BY w.user_id, cg.genre_name
),
repeat_watch AS (
    SELECT
        f.user_id,
        f.genre_name,
        COUNT(*) AS repeat_views
    FROM first_genre f
    JOIN clean.watch_history w
        ON f.user_id = w.user_id
    JOIN clean.content_genres cg
        ON w.content_id = cg.content_id
    WHERE cg.genre_name = f.genre_name
      AND DATE(w.watch_start_time) > f.first_watch_date
    GROUP BY f.user_id, f.genre_name
)
SELECT
    genre_name,
    AVG(repeat_views) AS avg_repeat_views
FROM repeat_watch
GROUP BY genre_name
ORDER BY avg_repeat_views DESC;

-- 34. Cohort Analysis

WITH user_cohort AS (
    SELECT
        user_id,
        DATE_TRUNC('month', signup_date) AS cohort_month
    FROM clean.users
),
user_activity AS (
    SELECT DISTINCT
        user_id,
        DATE_TRUNC('month', watch_start_time) AS activity_month
    FROM clean.watch_history
),
cohort_data AS (
    SELECT
        uc.cohort_month,
        ua.activity_month,
        (
            EXTRACT(YEAR FROM AGE(ua.activity_month, uc.cohort_month)) * 12
            + EXTRACT(MONTH FROM AGE(ua.activity_month, uc.cohort_month))
        ) AS month_number,
        COUNT(DISTINCT ua.user_id) AS active_users
    FROM user_cohort uc
    JOIN user_activity ua
        ON uc.user_id = ua.user_id
    GROUP BY uc.cohort_month, ua.activity_month
)
SELECT *
FROM cohort_data
WHERE month_number >= 0
ORDER BY cohort_month, month_number;



