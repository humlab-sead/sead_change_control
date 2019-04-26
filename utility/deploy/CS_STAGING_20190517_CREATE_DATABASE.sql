-- Deploy utility:CS_STAGING_20190517_CREATE_DATABASE to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description   
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    begin
        begin
            if current_database() != 'postgres' then
                raise exception 'this script must be run in postgres db!';
            end if;
        end $$;
        
        select pg_terminate_backend(pid)
        from pg_stat_activity
        where datname='sead_production';
        
        -- This command needs to be run in a separate session:
        create database sead_staging
            with owner      = sead_master
                 template   = sead_production
                 encoding   = 'UTF8'
                 lc_collate = 'en_US.UTF-8'
                 lc_ctype   = 'en_US.UTF-8'
                 tablespace = pg_default;

        grant temporary, connect on database sead_staging to public;
        grant all on database sead_staging to sead_master;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
