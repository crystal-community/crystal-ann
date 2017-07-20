-- +micrate Up
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR,
  login VARCHAR,
  uid VARCHAR,
  provider VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE UNIQUE INDEX uid_provider_idx ON users (uid, provider);

ALTER TABLE announcements ADD COLUMN user_id BIGSERIAL REFERENCES users (id);

-- +micrate Down

ALTER TABLE announcements DROP COLUMN user_id CASCADE;

DROP TABLE IF EXISTS users;
