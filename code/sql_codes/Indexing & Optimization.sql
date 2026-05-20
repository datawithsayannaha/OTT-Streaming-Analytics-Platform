-- Indexing & Optimization

-- Before Index 

EXPLAIN ANALYZE
SELECT * FROM clean.watch_history
WHERE user_id = 1000;

-- Single Column Index

CREATE INDEX idx_watch_history_user_id
ON clean.watch_history(user_id);

-- After Index

EXPLAIN ANALYZE
SELECT * FROM clean.watch_history
WHERE user_id = 1000;

-- Composite Index

CREATE INDEX idx_watch_user_time
ON clean.watch_history(user_id, watch_start_time);

EXPLAIN ANALYZE
SELECT *
FROM clean.watch_history
WHERE user_id = 1000
  AND watch_start_time >= '2024-01-01';

-- Partial Index

CREATE INDEX idx_successful_payments
ON clean.payments(payment_date)
WHERE payment_status = 'Success';

EXPLAIN ANALYZE
SELECT *
FROM clean.payments
WHERE payment_status = 'Success'
  AND payment_date >= '2024-01-01';

-- JSONB Index

CREATE INDEX idx_content_metadata_gin
ON clean.content
USING GIN(metadata);

EXPLAIN ANALYZE
SELECT *
FROM clean.content
WHERE metadata -> 'genres' ? 'Dramas';