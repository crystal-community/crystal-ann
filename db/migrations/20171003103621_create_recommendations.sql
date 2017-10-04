-- +micrate Up
CREATE TABLE recommendations (
  id BIGSERIAL PRIMARY KEY,
  announcement_id INTEGER NOT NULL,
  recommended_id INTEGER NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +micrate Down
DROP TABLE IF EXISTS recommendations;
