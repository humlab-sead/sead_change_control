alter user clearinghouse_worker createdb;

grant usage on schema public, sead_utility to clearinghouse_worker;
grant all privileges on all tables in schema public, sead_utility to clearinghouse_worker;
grant all privileges on all sequences in schema public, sead_utility to clearinghouse_worker;
grant execute on all functions in schema public, sead_utility to clearinghouse_worker;

alter default privileges in schema public, sead_utility grant all privileges on tables to clearinghouse_worker;
alter default privileges in schema public, sead_utility grant all privileges on sequences to clearinghouse_worker;

