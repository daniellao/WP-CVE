CREATE TABLE delivery_record (
  id INTEGER PRIMARY KEY,
  profile_id INTEGER NOT NULL,
  feed_id INTEGER,
  cve_id TEXT,
  channel TEXT NOT NULL CHECK (channel IN ('email', 'sms')),
  status TEXT NOT NULL CHECK (status IN ('pending', 'successful', 'failed')),
  is_test INTEGER NOT NULL CHECK (is_test IN (0, 1)),
  provider_message_id TEXT UNIQUE,
  error_code TEXT,
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ')),
  updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ'))
) STRICT;

CREATE TABLE error_log (
  id INTEGER PRIMARY KEY,
  source TEXT NOT NULL CHECK (source IN ('cve_api', 'email', 'sms')),
  feed_id INTEGER,
  delivery_record_id INTEGER REFERENCES delivery_record (id) ON DELETE CASCADE,
  attempt INTEGER,
  http_status INTEGER,
  error_code TEXT,
  error_message TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ'))
) STRICT;

CREATE INDEX error_log_delivery_record_id ON error_log (delivery_record_id);
