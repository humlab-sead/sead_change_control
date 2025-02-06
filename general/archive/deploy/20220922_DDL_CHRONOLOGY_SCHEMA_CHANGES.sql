-- Deploy general: 20220922_DDL_CHRONOLOGY_SCHEMA_CHANGES

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2022-09-22
  Description   Changes to chronology tables.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/92
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

SET client_min_messages = ERROR;

begin;
do $$
begin
    declare create_script text;

    
    begin

        if sead_utility.column_exists('public'::text, 'tbl_chronologies'::text, 'is_default'::text) = FALSE then
            raise exception SQLSTATE 'GUARD';
        end if;

        /*
            tbl_chronologies - can be simplified as follows
            Column	        Action	    Notes
            chronology_id	keep this
            chronology_name	keep this	A text identifier easy recognition
            date_prepared	keep this
            date_updated	keep this
            notes	        keep this	Detailed description of the chronology including how created and purpose
            contact_id	    keep this	Creator, publisher or person responsible for the chronology
            age_model	    keep this	Description of how chronology was created
            age_bound_older     drop	can be derived
            age_bound_younger   drop	can be derived
            age_type_id	        drop	No longer assume a single age type for all dates in chronology
            is_default	        drop	Better to use chronology_name to chose one appropriate for purpose
            sample_group_id	    drop	no longer serves a purpose

        */

        -- NOTE! Dependent views are automatically recompiled

        /* Drop dependent objects */
        drop view if exists clearing_house.view_chronologies;
        drop view if exists postgrest_default_api.chronology;
        drop view if exists postgrest_api.chronologies;
        drop function clearing_house_commit.resolve_chronology(integer);

        alter table public.tbl_chronologies
            drop column if exists "age_type_id",
            drop column if exists "is_default",
            drop column if exists "sample_group_id",
            drop column if exists "age_bound_older",
            drop column if exists "age_bound_younger"
            ;

        alter table clearing_house.tbl_chronologies
            drop column if exists "age_type_id",
            drop column if exists "is_default",
            drop column if exists "sample_group_id",
            drop column if exists "age_bound_older",
            drop column if exists "age_bound_younger"
            ;

        /* Delete data */
        delete from clearing_house_commit.tbl_sead_table_keys
            where table_name = 'tbl_chronologies'
              and column_name in ('age_type_id', 'is_default', 'sample_group_id', 'age_bound_older', 'age_bound_younger' );


        /* Recreate: clearing_house.view_chronologies */
        create_script := clearing_house.fn_script_local_union_public_entity_view( 'clearing_house', 'clearing_house', 'public', 'tbl_chronologies' );
        execute create_script;

        /* Recreate: clearing_house_commit.resolve_chronology */
        create_script := clearing_house_commit.generate_resolve_function('public', 'tbl_chronologies');
        execute create_script;

        /* Recreate: postgrest_default_api.chronology */
        perform sead_utility.create_postgrest_default_api_view('tbl_chronologies');



    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
