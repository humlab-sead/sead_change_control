-- Deploy security: 20200107_DML_ADD_USER

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2020-01-07
  Description   Add user
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/
SELECT pg_reload_conf();

do $$
begin
    
    grant usage on schema public to mattias;
    grant usage on schema public to johan;

    grant humlab_read TO mattias;
    grant humlab_read to johan;

    if (select count(*) from pg_roles where rolname='love_eriksson') = 0 then
        create user love_eriksson
            with login nosuperuser inherit nocreatedb nocreaterole noreplication valid until '2020-06-01';
    end if;

    grant connect on database sead_staging, sead_production, sead_master_8, sead_master_9 to love_eriksson;
    alter user love_eriksson with encrypted password 'password';

    grant sead_read to love_eriksson;

end $$
;

do $$
declare
    p_username text;
    v_schema_template text;
    v_sql text;
	v_schema text;
begin

	p_username = 'love_eriksson';

    v_schema_template = '

        grant usage on schema #SCHEMA# to #USER#;

        grant select        on all tables    in schema #SCHEMA# to #USER#;
        grant select, usage on all sequences in schema #SCHEMA# to #USER#;
        grant execute       on all functions in schema #SCHEMA# to #USER#;

        alter default privileges in schema #SCHEMA# grant select, trigger on tables to #USER#;
        alter default privileges in schema #SCHEMA# grant select, usage on sequences to #USER#;

    ';

    v_schema_template = replace(v_schema_template, '#USER#', quote_ident(p_username));

	for v_schema in (select * from pg_namespace where nspowner > 10 or nspname = 'public')
	loop

		v_sql = replace(v_schema_template, '#SCHEMA#', v_schema);

		execute v_sql;

	end loop;

end $$
language plpgsql

