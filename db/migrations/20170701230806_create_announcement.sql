-- +micrate Up
CREATE TABLE announcements (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR,
  description TEXT,
  type INTEGER,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +micrate Down
DROP TABLE IF EXISTS announcements;
