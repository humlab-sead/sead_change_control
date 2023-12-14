-- Deploy bugs: 20220916_DDL_RESULTS_CHRONOLOGY

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2022-09-18
  Description
  Prerequisites	csvkit
  Reviewer
  Approver
  Idempotent    Yes
  Notes

	NOTE! Uses the csvkit Python package

	Install `pyenv` (if not already installed):
		% curl https://pyenv.run | bash
		% pyenv install PYTHON-VERSION
		% exec $SHELL
		% pyenv global PYTHON-VERSION
		% python -m pip install --upgrade pip

	Install `pipx` (if not already installed):
		% python -m pip install --user pipx
		% python -m pipx ensurepath

	Install `csvkit` (if not already installed):
		% pipx install csvkit

  Results Chronology


Proverna finns i Bugs, men vi måste ladda in senaste versionen
Båda flikarna ska laddas in.

Identifier: Identifierar physical sample i Bugs (och SEAD - måste mappas)
FINAL SELECTION: Ladda koder som börjar med "Chosen_" som en bitsekvens (enklare än att skapa typkoder då det kan finnas flera per post).
Bara Chosen_C14, Chosen_OtherRadio, Chosen_Calendar, Chosen_Period


Berörda tabeller:
tbl_chronologies: kopplas på Sample group ID

*****************************************************************************************************************/
\echo 'Importing data...';

begin;

drop view if exists postgrest_default_api.results_chronology_temp;
drop table if exists results_chronology_temp;

create table results_chronology_temp (
    "source" varchar,
    "identifier" varchar,
    "site_name" varchar,
    "count_sheet_code" varchar,
    "sample_name" varchar,
    "sample_group_id" int,
    "physical_sample_id" int,
    "Chosen_C14" varchar,
    "Chosen_OtherRadio" varchar,
    "Chosen_Calendar" varchar,
    "Chosen_Period" varchar,
    "AgeFrom" varchar,
    "AgeTo" varchar
);

\copy results_chronology_temp ("identifier","Chosen_C14","Chosen_OtherRadio","Chosen_Calendar","Chosen_Period","AgeFrom","AgeTo") from 'deploy/20220916_DDL_RESULTS_CHRONOLOGY/archeological_sites_csvcut.csv'  with ( format csv,  header, quote '"', delimiter ',',  encoding 'utf-8' );
update results_chronology_temp set "source" = 'archeological_sites' where "source" is null;

\copy results_chronology_temp ("identifier","Chosen_C14","Chosen_OtherRadio","Chosen_Calendar","Chosen_Period","AgeFrom","AgeTo") from 'deploy/20220916_DDL_RESULTS_CHRONOLOGY/stratigraphic_sequences_csvcut.csv'  with ( format csv,  header, quote '"', delimiter ',',  encoding 'utf-8' );
update results_chronology_temp set "source" = 'stratigraphic_sequences' where "source" is null;

/* Explode componded keys */
update results_chronology_temp
  set site_name = split_part(identifier, '|', 1),
   count_sheet_code = split_part(identifier, '|', 2),
   sample_name = split_part(identifier, '|', 3);


/* Add SEAD sample group identity */
with bugs_translation as (
	select distinct
		bugs_identifier as count_sheet_code,
		sead_reference_id as sample_group_id
	    -- split_part(translated_compressed_data, ',', 3) as bugs_site_id
	from bugs_import.bugs_trace
	where bugs_table = 'TCountsheet'
	  and sead_table = 'tbl_sample_groups'
) update results_chronology_temp d
	set sample_group_id = t.sample_group_id
  from bugs_translation t
  where t.count_sheet_code = d.count_sheet_code;

/* Fix faulty sample names

    -- candidate correct sample names for groups with faulty sample names:
    with faulty_sample_names as (
        select sample_group_id, sample_name --, sample_name as corrected_sample_name
        from results_chronology_temp
        where sample_group_id is not NULL
        and physical_sample_id is null
        and not Coalesce("Chosen_C14", "Chosen_OtherRadio", "Chosen_Calendar", "Chosen_Period") is null
    )
        select sample_group_id, string_agg(ps.sample_name, ', ')
        from tbl_physical_samples ps
        join tbl_sample_groups pg using (sample_group_id)
        where sample_group_id in (
            select sample_group_id
            from faulty_sample_names
        )
        group by sample_group_id

*/
with corrected_sample_names as (
	select *
	from (values
		  	(7913, 'apr-06', '2906/4'),     /* Strange Excel conversion */
			(7914, 'jun-21', '2721/6'),     /* Strange Excel conversion */
			(7026, 'Column_A_F4', 'F4'),
			(7026, 'Column_A_F5', 'F5'),
			(7026, 'Column_A_F6', 'F6'),
			(7026, 'Column_A_F7', 'F7'),
			(7026, 'Column_A_F8', 'F8'),
			(7026, 'Column_A_F9', 'F9'),
			(7026, 'Column_B_F10', 'F10'),
			(7026, 'Column_B_F11', 'F11'),
			(7026, 'Column_B_F12', 'F12'),
			(7026, 'Column_B_F13', 'F13'),
			(7026, 'Column_B_F14', 'F14'),
			(7026, 'Platform_S1', 'S1'),
			(7026, 'Platform_S2', 'S2'),
			(11873, '_432', '#432'),
			(11873, '_535', '#535'),
			(11873, '_609', '#609'),
			(11873, '_610', '#610'),
			(8091, 'Mummies', 'BugsPresence'),   /* NOTE! Mummies does not exist in SEAD sample group (only BugsPresence) */
			(8301, '13-sep', '9/13'),
			(8301, '14-sep', '9/14'),
			(7526, '07-jun', '06-07'),
			(7526, '1', '01'),
			(7526, '2', '02'),
			(7526, '3', '03'),
			(7526, '4', '04'),
			(7526, '5', '05'),
			(7526, '6', '06'),
			(7526, '8', '08'),
			(8302, 'sep-02', '5002/9'),         /* Strange Excel conversion */
			(7292, '147_5-150cm', '147#5-150cm'),
			(7292, '92_5-95cm', '92#5-95cm'),
			(11858, '3b2', '3d2'),              /* Strange, typo? */
			(11858, '3d3', '3b3')              /* Strange, typo? */
	) as Y(sample_group_id, sample_name, corrected_sample_name)
) update results_chronology_temp as t
    set sample_name = x.corrected_sample_name
  from corrected_sample_names x
  where x.sample_group_id = t.sample_group_id
    and x.sample_name = t.sample_name;


with corrected_ages as (
	select *
	from (values
        ('9,00E+05', '900000'), ('1,00E+05', '100000'), ('3,00E+05', '300000'), ('4,00E+05', '400000')
	) as Y(faulty_age, corrected_age)
) update results_chronology_temp as t
    set "AgeFrom" = x.corrected_age
  from corrected_ages x
  where x.faulty_age = t."AgeFrom";

with corrected_ages as (
	select *
	from (values
        ('9,00E+05', '900000'), ('1,00E+05', '100000'), ('3,00E+05', '300000'), ('4,00E+05', '400000')
	) as Y(faulty_age, corrected_age)
) update results_chronology_temp as t
    set "AgeTo" = x.corrected_age
  from corrected_ages x
  where x.faulty_age = t."AgeTo";


do $$
    begin
    declare missing_count_sheets int;
    begin

        perform sead_utility.sync_sequences();

        /* Unknown count sheets */
        missing_count_sheets = (
            select count(*) --site_name, count_sheet_code, string_agg(sample_name, ', ')
            from results_chronology_temp
            where sample_group_id is null
        );

        if missing_count_sheets > 0 then
            raise notice 'error: unknown count sheet codes detected. Import prohibited!';
            raise notice 'warning: error encountered but ROLLBACK IS DISABLED!';
            /* NOTE! Check is disabled during development */
            -- raise exception SQLSTATE 'GUARD';
            -- select site_name, count_sheet_code, string_agg(sample_name, ', ')
            -- from results_chronology_temp
            -- where sample_group_id is null
            -- group by site_name, count_sheet_code;

        end if;

    end;

end $$;

/* Assign SEAD identity to physical samples */
with physical_sample as (
	select sample_group_id, sample_name, physical_sample_id
	from tbl_physical_samples
) update results_chronology_temp d
	set physical_sample_id = t.physical_sample_id
  from physical_sample t
  where t.sample_group_id = d.sample_group_id
    and (
        t.sample_name = d.sample_name
        -- or
        -- t.sample_name ~ '^0[0-9]+$' and d.sample_name ~ '^0[0-9]+$' and t.sample_name::int = d.sample_name::int
    );


do $$
    begin
    declare unknown_sample_names int;
    begin

        unknown_sample_names = (
            with faulty_sample_names as (
                select sample_group_id, sample_name
                from results_chronology_temp
                where sample_group_id is not NULL
                and physical_sample_id is null
                and not Coalesce("Chosen_C14", "Chosen_OtherRadio", "Chosen_Calendar", "Chosen_Period") is null
            )
                /* Correct codes per sample group */
                select count(*) -- sample_group_id, string_agg(ps.sample_name, ', ')
                from tbl_physical_samples ps
                join tbl_sample_groups pg using (sample_group_id)
                where sample_group_id in (
                    select sample_group_id
                    from faulty_sample_names
                )
                --group by sample_group_id
        );

        if unknown_sample_names > 0 then
            raise notice 'error: unknown sample names detected. Import prohibited!';
            raise notice 'WARNING: ROLLBACK IS DISABLED!';
            /* NOTE! Check is disabled during development */
            -- raise exception SQLSTATE 'GUARD';

            /* List faulty names:
                select sample_group_id, sample_name
                from results_chronology_temp
                where sample_group_id is not NULL
                and physical_sample_id is null
                and not Coalesce("Chosen_C14", "Chosen_OtherRadio", "Chosen_Calendar", "Chosen_Period") is null;

             */

        end if;

    end;

end $$;


do $$
begin

    declare v_project_stage_id int;
    declare v_project_type_id int;
    declare v_project_id int;
    declare v_method_id int;
    declare v_note varchar;
    declare v_count_sheet_code varchar;
    declare v_dataset_id int;
    declare v_dataset_name varchar;
    declare v_now timestamp with time zone;
    declare v_sample_group_id int;
    declare v_physical_sample_id int;
    declare v_age_from int;
    declare v_age_to int;
    declare v_chosen_c14 int;
    declare v_chosen_otherradio int;
    declare v_chosen_calendar int;
    declare v_chosen_period int;
    declare v_analysis_entity_id int;
    declare v_dating_specifier text;
    begin
        v_now = now();

        /* add text column that specifies how age was selected (semicolon seperated string) */
        alter table tbl_analysis_entity_ages
            add column if not exists dating_specifier text;

        /* Add a new project */

        insert into tbl_project_stages("stage_name", "description")
            values ('Unclassified', 'Project stage irrelevant for this type of project')
                returning project_stage_id into v_project_stage_id;

        insert into tbl_project_types("project_type_name", "description")
            values ('Infrastructure', 'A project for the development of research infrastructure (e.g. database or data development)')
                returning project_type_id into v_project_type_id;

        insert into tbl_projects("project_type_id", "project_stage_id", "project_name", "project_abbrev_name", "description")
            values (v_project_type_id, v_project_stage_id, 'Swedish Biodiversity Data Infrastructure', 'SBDI', 'National infrastructure for biodiversity data in Sweden (biodiversitydata.se)')
                returning project_id into v_project_id;

        /* Add a new method */
        -- TODO: Check if unit_id should be 8 (calendar year), add "Year before present" instead?"
        insert into tbl_methods(method_group_id, method_name, method_abbrev_or_alt_name, description, record_type_id, unit_id, biblio_id)
            values (21, 'Composite chronology', 'Composite chronology', 'Chronology derived from a combination of dates using various methods.', 19, 8, null)
                returning method_id into v_method_id;

        for v_count_sheet_code in (
            select distinct count_sheet_code
            from results_chronology_temp
            order by count_sheet_code
        )
        loop

            /* Create a dataset for each count sheet */

            -- raise notice 'Count sheet: %', v_count_sheet_code;
            v_dataset_name = format('simpledate_%s', v_count_sheet_code);
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

            for v_sample_group_id, v_physical_sample_id, v_age_from, v_age_to, v_dating_specifier in (
                select  sample_group_id,
                        physical_sample_id,
                        "AgeFrom"::int,
                        "AgeTo"::int,
                        array_to_string(Array[
                                case when "Chosen_C14"::int = 1 then 'Chosen_C14' else null end,
                                case when "Chosen_OtherRadio"::int = 1 then 'Chosen_OtherRadio' else null end,
                                case when "Chosen_Calendar"::int = 1 then 'Chosen_Calendar' else null end,
                                case when "Chosen_Period"::int = 1 then 'Chosen_Period' else null end
                            ], ';', null)
                from results_chronology_temp
                where count_sheet_code = v_count_sheet_code
                order by count_sheet_code
            )
            loop

                insert into tbl_analysis_entities(physical_sample_id, dataset_id)
                    values (v_physical_sample_id, v_dataset_id)
                        returning analysis_entity_id into v_analysis_entity_id;

                insert into tbl_analysis_entity_ages(analysis_entity_id, age, age_older, age_younger, chronology_id, dating_specifier)
                    values (v_analysis_entity_id, null, v_age_from, v_age_to, null, v_dating_specifier);

            end loop;

        end loop;

        perform sead_utility.sync_sequences();

    end;
end $$;

commit;

