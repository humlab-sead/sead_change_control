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

    call sead_utility.drop_udf('clearing_house_commit', 'resolve_chron_control');
    call sead_utility.drop_udf('clearing_house_commit', 'resolve_chron_control_type');
    call sead_utility.drop_view('clearing_house.view_chron_control');
    call sead_utility.drop_view('clearing_house.view_chron_controls');
    call sead_utility.drop_view('clearing_house.view_chron_control_type');
    call sead_utility.drop_table('clearing_house.tbl_chron_controls');
    call sead_utility.drop_table('clearing_house.tbl_chron_control_types');
    call sead_utility.drop_view('postgrest_api.chron_control');
    call sead_utility.drop_view('postgrest_api.chron_control_type');
    call sead_utility.drop_view('postgrest_default_api.chron_control');
    call sead_utility.drop_view('postgrest_default_api.chron_control_type');
    call sead_utility.drop_table('public.tbl_chron_controls');
    call sead_utility.drop_table('public.tbl_chron_control_types');


    /* ClearingHouse: delete data related to tables */
    -- delete from clearing_house.tbl_clearinghouse_submission_tables where table_name_underscored = 'tbl_chron_controls';
    -- delete from clearing_house_commit.tbl_sead_table_keys where table_name = 'tbl_chron_controls';

    -- delete from clearing_house.tbl_clearinghouse_submission_tables where table_name_underscored = 'tbl_chron_control_types';
    -- delete from clearing_house_commit.tbl_sead_table_keys where table_name = 'tbl_chron_control_types';


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

commit;
