-- Deploy general: 20220923_DDL_DEPRECATE_CHRON_CONTROLS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2022-09-23
  Description   Deprecate chronology controls tables.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/93
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

            drop table if exists clearing_house.tbl_chron_controls;
            drop table if exists clearing_house.tbl_chron_control_types;

            /* ClearingHouse: delete data related to tables */
            -- delete from clearing_house.tbl_clearinghouse_submission_tables where table_name_underscored = 'tbl_chron_controls';
            -- delete from clearing_house_commit.tbl_sead_table_keys where table_name = 'tbl_chron_controls';

            -- delete from clearing_house.tbl_clearinghouse_submission_tables where table_name_underscored = 'tbl_chron_control_types';
            -- delete from clearing_house_commit.tbl_sead_table_keys where table_name = 'tbl_chron_control_types';

        end;

        /* PostgREST API: drop dependent objects and delete data */

        if sead_utility.view_exists('postgrest_api', 'chron_controls') then
            drop view postgrest_api.chron_controls;
        end if;

        if sead_utility.view_exists('postgrest_api', 'chron_control_type') then
            drop view postgrest_api.chron_control_type;
        end if;

        if sead_utility.view_exists('postgrest_default_api', 'chron_controls') then
            drop view postgrest_default_api.chron_controls;
        end if;

        if sead_utility.view_exists('postgrest_default_api', 'chron_control_type') then
            drop view postgrest_default_api.chron_control_type;
        end if;

        /* SEAD facet API: Drop dependent objects */
        begin

            /* Remove from facet.table_relation */
            delete -- select *
            from facet.table_relation
            where source_table_id in (
                    select table_id
                    from facet.table
                    where table_or_udf_name in ('tbl_chron_controls', 'tbl_chron_control_types')
                ) or 
                target_table_id in (
                    select table_id
                    from facet.table
                    where table_or_udf_name in ('tbl_chron_controls', 'tbl_chron_control_types')
                )
            ;


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
