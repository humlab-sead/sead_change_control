-- Deploy bugs: 20220916_DDL_RESULTS_CHRONOLOGY_LOOKUPS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2022-09-16
  Description   Lookups for result chronology
  Issue         https://github.com/humlab-sead/sead_change_control/issues/17
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
declare
    v_project_stage_id integer;
    v_project_type_id integer;
begin

    insert into tbl_project_stages("stage_name", "description")
        values ('Unclassified', 'Project stage irrelevant for this type of project')
            on conflict (stage_name) do update
                set "description" = excluded."description" 
                    returning "project_stage_id" into v_project_stage_id;

	insert into tbl_project_types("project_type_name", "description")
        values ('Infrastructure', 'A project for the development of research infrastructure (e.g. database or data development)')
            on conflict (project_type_name) do update
                set "description" = excluded."description"
                    returning "project_type_id" into v_project_type_id;

    insert into tbl_methods("method_group_id", "method_name", "method_abbrev_or_alt_name", "description", "record_type_id", "unit_id", "biblio_id")
        values (21, 'Composite chronology', 'Composite chronology', 'Chronology derived from a combination of dates using various methods.', 19, 8, null)
            on conflict ("method_abbrev_or_alt_name") do update
                set "method_group_id" = excluded."method_group_id",
                    "method_name" = excluded."method_name",
                    "description" = excluded."description",
                    "record_type_id" = excluded."record_type_id",
                    "unit_id" = excluded."unit_id",
                    "biblio_id" = excluded."biblio_id";

    insert into tbl_projects("project_type_id", "project_stage_id", "project_name", "project_abbrev_name", "description")
        values (
            (select "project_type_id" from tbl_project_types where project_type_name = 'Infrastructure'),
            (select "project_stage_id" from tbl_project_stages where "stage_name" = 'Unclassified'),
            'Swedish Biodiversity Data Infrastructure',
            'SBDI',
            'National infrastructure for biodiversity data in Sweden (biodiversitydata.se)'
        )  on conflict (project_abbrev_name) do update
            set "project_type_id" = excluded."project_type_id",
                "project_stage_id" = excluded."project_stage_id",
                "project_name" = excluded."project_name",
                "description" = excluded."description";

end $$;
commit;
