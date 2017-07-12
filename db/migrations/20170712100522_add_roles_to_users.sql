-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied

ALTER TABLE users ADD COLUMN role VARCHAR DEFAULT 'user';

UPDATE users SET role='admin' WHERE login='veelenga';

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back

ALTER TABLE users DROP COLUMN role;
