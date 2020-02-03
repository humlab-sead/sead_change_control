-- Deploy security:20200107_DML_ADD_USER to pg

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
SELECT pg_reload_conf();

drop user if exists love_eriksson;

create user love_eriksson
	with login nosuperuser inherit nocreatedb nocreaterole noreplication valid until '2020-06-01';

grant connect on database sead_staging, sead_production, sead_master_8, sead_master_9 to love_eriksson;
alter user love_eriksson with encrypted password 'password';

grant sead_read to love_eriksson;


begin;
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

	    raise notice '%', v_sql;

		-- execute v_sql:

	end loop;

end $$
language plpgsql

