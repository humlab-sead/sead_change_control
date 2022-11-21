-- Revert utility:20221118_DDL_GENERATE_SQLITE_SCHEMA from pg

begin;

    drop function if exists sead_utility.fn_script_to_sqlite_columns();
    drop function if exists sead_utility.fn_script_to_sqlite_table(character varying, character varying);
    drop function if exists sead_utility.fn_script_to_sqlite_tables();

commit;
