-- +micrate Up
ALTER TABLE users ADD COLUMN handle VARCHAR;

-- +micrate Down
ALTER TABLE users DROP COLUMN handle;
