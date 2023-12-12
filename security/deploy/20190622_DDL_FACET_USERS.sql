-- Deploy security: 20190622_DDL_FACET_USERS
do $$
begin
    if not exists (select from pg_catalog.pg_roles where rolname = 'querysead_owner') then

        create user querysead_owner
            with login nosuperuser inherit nocreatedb nocreaterole noreplication valid until 'infinity';

    end if;

    if not exists (select from pg_catalog.pg_roles where rolname = 'querysead_worker') then

        create user querysead_worker
            with login nosuperuser inherit nocreatedb nocreaterole noreplication valid until 'infinity';

    end if;
    grant usage on schema public to querysead_owner, querysead_worker, sead_read, sead_write;
    grant connect on database sead_staging to querysead_worker, querysead_owner;

    revoke all on all tables in schema public from querysead_owner, querysead_worker;

    grant select        on all tables    in schema public to public, querysead_worker, sead_read, sead_write;
    grant select, usage on all sequences in schema public to public, querysead_worker, sead_read, sead_write;
    grant execute       on all functions in schema public to public, querysead_worker, sead_read, sead_write;

    alter default privileges in schema public grant select, trigger on tables    to querysead_owner, querysead_worker;
    
-- alter user querysead_owner with encrypted password 'xxx';
-- alter user querysead_worker with encrypted password 'xxx';
end $$ language plpgsql;

