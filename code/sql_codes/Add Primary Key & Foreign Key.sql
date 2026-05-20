-- Add Primary Key & Foreign Key 

ALTER TABLE clean.content ADD PRIMARY KEY (content_id);
ALTER TABLE clean.users ADD PRIMARY KEY (user_id);
ALTER TABLE clean.devices ADD PRIMARY KEY (device_id);
ALTER TABLE clean.subscriptions ADD PRIMARY KEY (subscription_id);
ALTER TABLE clean.payments ADD PRIMARY KEY (payment_id);
ALTER TABLE clean.sessions ADD PRIMARY KEY (session_id);
ALTER TABLE clean.watch_history ADD PRIMARY KEY (watch_id);
ALTER TABLE clean.user_events ADD PRIMARY KEY (event_id);


ALTER TABLE clean.devices
ADD CONSTRAINT fk_devices_users
FOREIGN KEY (user_id) REFERENCES clean.users(user_id);

ALTER TABLE clean.subscriptions
ADD CONSTRAINT fk_subscriptions_users
FOREIGN KEY (user_id) REFERENCES clean.users(user_id);

ALTER TABLE clean.payments
ADD CONSTRAINT fk_payments_users
FOREIGN KEY (user_id) REFERENCES clean.users(user_id);

ALTER TABLE clean.payments
ADD CONSTRAINT fk_payments_subscriptions
FOREIGN KEY (subscription_id) REFERENCES clean.subscriptions(subscription_id);

ALTER TABLE clean.sessions
ADD CONSTRAINT fk_sessions_users
FOREIGN KEY (user_id) REFERENCES clean.users(user_id);

ALTER TABLE clean.sessions
ADD CONSTRAINT fk_sessions_devices
FOREIGN KEY (device_id) REFERENCES clean.devices(device_id);

ALTER TABLE clean.watch_history
ADD CONSTRAINT fk_watch_users
FOREIGN KEY (user_id) REFERENCES clean.users(user_id);

ALTER TABLE clean.watch_history
ADD CONSTRAINT fk_watch_content
FOREIGN KEY (content_id) REFERENCES clean.content(content_id);

ALTER TABLE clean.watch_history
ADD CONSTRAINT fk_watch_sessions
FOREIGN KEY (session_id) REFERENCES clean.sessions(session_id);