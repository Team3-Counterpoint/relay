create schema api;

create role authenticator noinherit login password 'mysecretpassword';

-- Create web anon role and grant usage on schema api, and then grant default read privileges
-- on all tables in schema api to allow viewing openAPI spec from browser at localhost:3000
-- without a token.
create role web_anon nologin;
grant usage on schema api to web_anon;
grant web_anon to authenticator;

alter default privileges in schema api
grant select on tables to web_anon;


-- creating placeholder account for admin, dev_admin ,  with full access
-- to api schema. making sure that JWT setup is working. 
create role dev_admin nologin;
grant usage on schema api to dev_admin;
grant dev_admin to authenticator;

-- These ALTER DEFAULT PRIVILEGES do what I thought the commented out grant
-- options did below-- grant all access in schema api EVEN FOR OBJECTS THAT
-- AREN'T YET CREATED. Grant only works on previously created objects.
alter default privileges in schema api grant all on TABLES TO dev_admin;
alter default privileges in schema api grant all on SEQUENCES TO dev_admin;
alter default privileges in schema api grant all on FUNCTIONS TO dev_admin;
-- grant all on all tables in schema api to dev_admin;
-- grant all on all sequences in schema api to dev_admin;



-- Need to do:
-- look more into security. locking down db to only our dev_admin and 
-- web_anon users.


--  Below is instructions for initializing schema in postgres docker image

/* If you would like to do additional initialization in an image derived from this one, 
add one or more *.sql, *.sql.gz, or *.sh scripts under /docker-entrypoint-initdb.d 
(creating the directory if necessary). After the entrypoint calls initdb to create 
the default postgres user and database, it will run any *.sql files, run any executable 
*.sh scripts, and source any non-executable *.sh scripts found in that directory to do 
further initialization before starting the service.
*/