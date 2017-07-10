-- +micrate Up
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR,
  uid VARCHAR,
  provider VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

ALTER TABLE announcements ADD COLUMN user_id BIGSERIAL REFERENCES users (id);

-- +micrate Down

ALTER TABLE announcements DROP COLUMN user_id;

DROP TABLE IF EXISTS users;
