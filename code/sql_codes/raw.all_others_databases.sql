CREATE TABLE raw.users (
    user_id INT,
    full_name TEXT,
    gender TEXT,
    age INT,
    city TEXT,
    state TEXT,
    country TEXT,
    signup_date DATE,
    preferred_language TEXT,
    user_segment TEXT
);

CREATE TABLE raw.devices (
    device_id INT,
    user_id INT,
    device_type TEXT,
    os TEXT,
    app_version TEXT,
    registered_date DATE
);

CREATE TABLE raw.subscriptions (
    subscription_id INT,
    user_id INT,
    plan_type TEXT,
    start_date DATE,
    end_date DATE,
    status TEXT,
    monthly_price NUMERIC(10,2),
    billing_cycle TEXT
);

CREATE TABLE raw.payments (
    payment_id INT,
    user_id INT,
    subscription_id INT,
    payment_date DATE,
    amount NUMERIC(10,2),
    payment_method TEXT,
    payment_status TEXT
);

CREATE TABLE raw.sessions (
    session_id INT,
    user_id INT,
    device_id INT,
    session_start TIMESTAMP,
    session_end TIMESTAMP,
    session_duration_minutes INT,
    traffic_source TEXT
);

CREATE TABLE raw.watch_history (
    watch_id INT,
    user_id INT,
    content_id INT,
    session_id INT,
    watch_start_time TIMESTAMP,
    watch_duration_minutes INT,
    completion_percentage INT,
    is_completed BOOLEAN,
    watch_device TEXT
);

CREATE TABLE raw.user_events (
    event_id INT,
    user_id INT,
    session_id INT,
    content_id INT,
    event_time TIMESTAMP,
    event_type TEXT,
    event_metadata TEXT
);