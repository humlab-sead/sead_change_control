-- Deploy sead_change_control:20220922_DDL_CHRONOLOGY_SCHEMA_CHANGES to pg

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
    declare create_script text;

    begin

        if sead_utility.table_exists('public'::text, 'tbl_chron_control_types'::text) = FALSE then
            raise exception sqlstate 'GUARD';
        end if;

        /* ClearingHouse */
        begin

            /* drop dependent objects */
            drop function if exists clearing_house_commit.resolve_chron_control(int);
            drop function if exists clearing_house_commit.resolve_chron_control_type(int);
            drop view if exists clearing_house.view_chron_controls;

            drop view if exists clearing_house.view_chron_control_types;
            drop table if exists clearing_house.tbl_chron_control_types;
            drop table if exists clearing_house.tbl_chron_controls;

            /* ClearingHouse: delete data related to tables */
            delete from clearing_house.tbl_clearinghouse_submission_tables where table_name_underscored = 'tbl_chron_controls';
            delete from clearing_house_commit.tbl_sead_table_keys where table_name = 'tbl_chron_controls';

            delete from clearing_house.tbl_clearinghouse_submission_tables where table_name_underscored = 'tbl_chron_control_types';
            delete from clearing_house_commit.tbl_sead_table_keys where table_name = 'tbl_chron_control_types';

        end;

        /* PostgREST API: drop dependent objects and delete data */

        begin
            drop view if exists postgrest_api.chron_controls;
            drop view if exists postgrest_default_api.chron_control;
        end;

        /* SEAD facet API: Drop dependent objects */
        begin

            -- FIXME #103 Delete of records disabled
            -- delete from facet.table where table_or_udf_name = 'tbl_chron_controls';

            drop view if exists postgrest_api.chron_control_types;
            delete -- select *
            from facet.table
            where is_udf = FALSE
            and table_or_udf_name not like 'facet.%'
            and table_or_udf_name != 'countries'
            and table_or_udf_name not in (
                select table_name
                from sead_utility.view_table_columns
            );

            delete -- select *
            from facet.facet_table
            where table_id in (
                select table_id
                from facet.table
                where table_or_udf_name in ('tbl_chron_controls', 'tbl_chron_control_types')
            );

            delete -- select *
			from facet.table where table_or_udf_name in ('tbl_chron_controls', 'tbl_chron_control_types');
            
        end;

        /* Drop tables */

        drop table if exists public.tbl_chron_controls;
        drop table if exists public.tbl_chron_control_types;


    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
