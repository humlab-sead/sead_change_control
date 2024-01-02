grant usage on schema public to humlab_read, sead_read;

grant select on all tables in schema public to humlab_read, sead_read;
grant select, usage on all sequences in schema public to humlab_read, sead_read;
grant execute on all functions in schema public to humlab_read, sead_read;

alter default privileges in schema public grant select on tables to humlab_read, sead_read;
alter default privileges in schema public grant select, usage on sequences to humlab_read, sead_read;

alter default privileges for role sead_master in schema public grant select on tables to humlab_read, sead_read;
alter default privileges for role sead_master in schema public grant select, usage on sequences to humlab_read, sead_read;
alter default privileges for role sead_master in schema public grant all on functions to humlab_read, sead_read;

do $$ begin
   execute format('grant all privileges on database %I to humlab_admin;', current_database());
end $$;

grant all privileges on all tables in schema public to humlab_admin;
grant all privileges on all sequences in schema public to humlab_admin;
grant all privileges on all functions in schema public to humlab_admin;

alter default privileges grant all privileges on tables to humlab_admin;
alter default privileges grant all privileges on sequences to humlab_admin;
alter default privileges grant all privileges on functions to humlab_admin;
