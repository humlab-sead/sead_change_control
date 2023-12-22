grant usage on schema public to humlab_read, sead_read;

grant select on all tables in schema public to humlab_read, sead_read;
grant select, usage on all sequences in schema public to humlab_read, sead_read;
grant execute on all functions in schema public to humlab_read, sead_read;

alter default privileges in schema public grant select on tables to humlab_read, sead_read;
alter default privileges in schema public grant select, usage on sequences to humlab_read, sead_read;

alter default privileges for role humlab_admin in schema public grant select on tables to humlab_read, sead_read;
alter default privileges for role humlab_admin in schema public grant select, usage on sequences to humlab_read, sead_read;
alter default privileges for role humlab_admin in schema public grant all on functions to humlab_read, sead_read;
