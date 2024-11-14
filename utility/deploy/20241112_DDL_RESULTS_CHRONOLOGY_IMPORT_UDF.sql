-- Deploy utility: 20241112_DDL_RESULTS_CHRONOLOGY_IMPORT_UDF

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-11-12
  Description   Helper UDF for importing and keeping track of chronology data import
  Issue         https://github.com/humlab-sead/sead_change_control/issues/315
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes         Related to https://github.com/humlab-sead/sead_change_control/issues/17
                and  https://github.com/humlab-sead/sead_change_control/issues/2
*****************************************************************************************************************/

begin;
do $$
begin

    drop table if exists bugs_import.results_chronology_import;

    create table if not exists bugs_import.results_chronology_import (
        "id" serial primary key,
        "change_request" text,
        "source" text,

        "timestamp" timestamp with time zone DEFAULT now(),

        /* source data */
        "identifier" text,
        "Chosen_C14" text,
        "Chosen_OtherRadio" text,
        "Chosen_Calendar" text,
        "Chosen_Period" text,
        "AgeFrom" text,
        "AgeTo" text,

        /* identifier fields */
        "site_name" text,
        "count_sheet_code" text,
        "sample_name" text,
        
        /* linked entities */
        "sample_group_id" int,
        "physical_sample_id" int,

        /* added entities */
        "analysis_entity_id" int,
        "dataset_id" int,

        "is_ok" boolean,
        "error" text
    );
    

    create or replace function sead_utility.import_pending_results_chronologies(p_change_request text)
        returns void
        language plpgsql
    as $xyz$
    declare
        v_project_id int;
        v_method_id int;
        v_note text;
        v_count_sheet_code text;
        v_dataset_id int;
        v_dataset_name text;
        v_now timestamp with time zone;
        v_id int;
        v_sample_group_id int;
        v_physical_sample_id int;
        v_age_from int;
        v_age_to int;
        v_analysis_entity_id int;
        v_dating_specifier text;
    begin
        begin

            v_now = now();

            /* Explode compound keys */
            update bugs_import.results_chronology_import 
                set "site_name" = split_part("identifier", '|', 1),
                    "count_sheet_code" = split_part("identifier", '|', 2),
                    "sample_name" = split_part("identifier", '|', 3),
                    "is_ok" = true
            where "change_request" = p_change_request;

            /* Add SEAD sample group identity */
            with bugs_translation as (
                select distinct "bugs_identifier" as count_sheet_code, "sead_reference_id" as sample_group_id
                from bugs_import."bugs_trace"
                where "bugs_table" = 'TCountsheet'
                and "sead_table" = 'tbl_sample_groups'
                and "manipulation_type" = 'INSERT'
            )
                update bugs_import.results_chronology_import d
                    set "sample_group_id" = t."sample_group_id"
                from bugs_translation t
                where t."count_sheet_code" = d."count_sheet_code"
                and d."change_request" = p_change_request;

            /* Assign SEAD identity to physical samples */
            update bugs_import.results_chronology_import d
                set physical_sample_id = t."physical_sample_id"
            from tbl_physical_samples t
            where d."change_request" = p_change_request
              and t."sample_group_id" = d."sample_group_id"
              and t."sample_name" = d."sample_name";

            update bugs_import.results_chronology_import
                set "is_ok" = false, "error" = 'No dating data'
            where "change_request" = p_change_request
              and "is_ok"
              and Coalesce("Chosen_C14", "Chosen_OtherRadio", "Chosen_Calendar", "Chosen_Period") is null;

            update bugs_import.results_chronology_import
                set "is_ok" = false, "error" = 'Unknown count sheet'
            where "change_request" = p_change_request
                and "is_ok"
                and "sample_group_id" is null;

            update bugs_import.results_chronology_import
                set "is_ok" = false, "error" = 'Unknown sample group'
            where "change_request" = p_change_request
            and "is_ok"
            and "physical_sample_id" is null;

            perform sead_utility.sync_sequences('public');

            v_project_id = (select project_id from tbl_projects where project_name = 'Swedish Biodiversity Data Infrastructure');
            v_method_id = (select method_id from tbl_methods where method_name = 'Composite chronology');

            for v_count_sheet_code in (
                select distinct count_sheet_code
                from bugs_import.results_chronology_import
                order by count_sheet_code
            )
            loop
                -- raise notice 'Count sheet: %', v_count_sheet_code;

                v_dataset_name = format('simpledate_%s', v_count_sheet_code);
                v_dataset_id = (select dataset_id from tbl_datasets where dataset_name = v_dataset_name);
                if v_dataset_id is null then

                    insert into tbl_datasets(master_set_id, data_type_id, method_id, project_id, dataset_name)
                        values (1 /* Bugs */, 44 /* Composite type */, v_method_id, v_project_id, v_dataset_name)
                            returning dataset_id into v_dataset_id;

                    v_note = 'Single data per sample for BugsCEP data as compiled from existing dating evidence by Francesca Pilotto and Philip Buckland for SBDI';
                    insert into tbl_dataset_submissions(dataset_id, submission_type_id, contact_id, date_submitted, notes, date_updated)
                        values (v_dataset_id, 8, 1, v_now, v_note, v_now );
                    
                    v_note = 'Compilation and R code selection of optimal dates from BugsCEP into Excel.';
                    insert into tbl_dataset_submissions(dataset_id, submission_type_id, contact_id, date_submitted, notes)
                        values (v_dataset_id, 3, 1, '2021-10-28', v_note);

                    insert into tbl_dataset_contacts(contact_id, contact_type_id, dataset_id)
                        values (1, 6, v_dataset_id);

                end if;

                for v_id, v_sample_group_id, v_physical_sample_id, v_age_from, v_age_to, v_dating_specifier in (
                    select "id",  "sample_group_id", "physical_sample_id", "AgeFrom"::int, "AgeTo"::int,
                        array_to_string(Array[
                            case when "Chosen_C14"::int = 1 then 'Chosen_C14' else null end,
                            case when "Chosen_OtherRadio"::int = 1 then 'Chosen_OtherRadio' else null end,
                            case when "Chosen_Calendar"::int = 1 then 'Chosen_Calendar' else null end,
                            case when "Chosen_Period"::int = 1 then 'Chosen_Period' else null end
                        ], ';', null)
                    from bugs_import.results_chronology_import
                    where "count_sheet_code" = v_count_sheet_code
                      and "is_ok"
                      and "analysis_entity_id" is null
                      and "dataset_id" is null
                    order by "count_sheet_code"
                )
                loop

                    if (select count(*)
                        from tbl_analysis_entities
                        where physical_sample_id = v_physical_sample_id
                         and dataset_id = v_dataset_id
                    ) > 0 then
                        raise notice 'Physical sample % already exists in dataset %', v_physical_sample_id, v_dataset_id;
                        update bugs_import.results_chronology_import
                            set "is_ok" = false, "error" = 'Physical sample already exists in dataset'
                            where "id" = v_id;
                        continue;
                    end if;

                    insert into tbl_analysis_entities("physical_sample_id", "dataset_id")
                        values (v_physical_sample_id, v_dataset_id)
                            returning "analysis_entity_id" into v_analysis_entity_id;

                    insert into tbl_analysis_entity_ages("analysis_entity_id", "age", "age_older", "age_younger", "chronology_id", "dating_specifier")
                        values (v_analysis_entity_id, null, v_age_from, v_age_to, null, v_dating_specifier);

                    update bugs_import.results_chronology_import
                        set "analysis_entity_id" = v_analysis_entity_id,
                            "dataset_id" = v_dataset_id
                    where "id" = v_id;
                    
                end loop;

            end loop;

            perform sead_utility.sync_sequences('public');

        end;
    end $xyz$;
   
end $$;
commit;
