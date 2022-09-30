TRUNCATE TABLE posts, user_accounts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO user_accounts (email_address, username) VALUES ('name@email.com', 'Miles');
INSERT INTO posts (title, contents, views, user_account_id) VALUES ('Post 1', 'How are you?', '3', '1');
INSERT INTO posts (title, contents, views, user_account_id) VALUES ('Post 2', 'What are you doing today?', '5', '1');
