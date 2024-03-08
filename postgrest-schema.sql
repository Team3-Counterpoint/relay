create schema api;

CREATE TABLE api.todolists (
  id serial PRIMARY KEY,
  title text NOT NULL UNIQUE,
  username text NOT NULL
);

CREATE TABLE api.todos (
  id serial PRIMARY KEY,
  title text NOT NULL,
  done boolean NOT NULL DEFAULT false,
  username text NOT NULL,
  todolist_id integer
    NOT NULL
    REFERENCES api.todolists (id)
    ON DELETE CASCADE
);

CREATE TABLE api.users (
  username text PRIMARY KEY,
  password text NOT NULL
);

-- Insert sample users
INSERT INTO api.users (username, password) VALUES
('user1', 'password1'),
('user2', 'password2'),
('user3', 'password3');

-- Insert sample todolists
INSERT INTO api.todolists (title, username) VALUES
('Grocery List', 'user1'),
('Work Tasks', 'user1'),
('Home Projects', 'user2'),
('Travel Plans', 'user3');

-- Insert sample todos
INSERT INTO api.todos (title, done, username, todolist_id) VALUES
('Buy milk', false, 'user1', 1),
('Finish report', false, 'user1', 2),
('Paint the living room', true, 'user2', 3),
('Book flight tickets', false, 'user3', 4),
('Pack suitcase', false, 'user3', 4);

create role web_anon nologin;

-- Anonymous user read privileges
grant usage on schema api to web_anon;
grant select on api.todolists to web_anon;
grant select on api.todos to web_anon;

create role authenticator noinherit login password 'mysecretpassword';
grant web_anon to authenticator;

-- Read & write privileges for todos table for todo_user
create role todo_user nologin;
grant todo_user to authenticator;

grant usage on schema api to todo_user;
grant all on api.todos to todo_user;
grant usage, select on sequence api.todos_id_seq to todo_user;