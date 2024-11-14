-- Deploy bugs: 20220916_DDL_RESULTS_CHRONOLOGY

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2022-09-16
  Description   Add chronology dating data to Bugs physical samples.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/17
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

-- This change as been backdated to SEAD_DATABASE_MODEL/tables.sql
alter table tbl_analysis_entity_ages
    add column if not exists dating_specifier text;


\copy bugs_import.results_chronology_import ( "identifier","Chosen_C14","Chosen_OtherRadio","Chosen_Calendar","Chosen_Period","AgeFrom","AgeTo" ) from 'deploy/20220916_DDL_RESULTS_CHRONOLOGY/archeological_sites_csvcut.csv' with ( format csv,  header, quote '"', delimiter ',',  encoding 'utf-8' );

update bugs_import.results_chronology_import
    set "change_request" = '20220916_DDL_RESULTS_CHRONOLOGY',
        "source" = 'archeological_sites',
        "is_ok" = true
    where "source" is null;

\copy bugs_import.results_chronology_import ( "identifier","Chosen_C14","Chosen_OtherRadio","Chosen_Calendar","Chosen_Period","AgeFrom","AgeTo" ) from 'deploy/20220916_DDL_RESULTS_CHRONOLOGY/stratigraphic_sequences_csvcut.csv' with ( format csv,  header, quote '"', delimiter ',',  encoding 'utf-8' );

update bugs_import.results_chronology_import
    set "change_request" = '20220916_DDL_RESULTS_CHRONOLOGY',
        "source" = 'stratigraphic_sequences',
        "is_ok" = true
    where "source" is null;

with corrected_sample_names(faulty_sample_name, correct_sample_name) as (values
        ('apr-06', '2906/4'),     /* Strange Excel conversion */
        ('jun-21', '2721/6'),     /* Strange Excel conversion */
        ('Column_A_F4', 'F4'),
        ('Column_A_F5', 'F5'),
        ('Column_A_F6', 'F6'),
        ('Column_A_F7', 'F7'),
        ('Column_A_F8', 'F8'),
        ('Column_A_F9', 'F9'),
        ('Column_B_F10', 'F10'),
        ('Column_B_F11', 'F11'),
        ('Column_B_F12', 'F12'),
        ('Column_B_F13', 'F13'),
        ('Column_B_F14', 'F14'),
        ('Platform_S1', 'S1'),
        ('Platform_S2', 'S2'),
        ('_432', '#432'),
        ('_535', '#535'),
        ('_609', '#609'),
        ('_610', '#610'),
        ('Mummies', 'BugsPresence'),   /* NOTE! Mummies does not exist in SEAD sample group (only BugsPresence) */
        ('13-sep', '9/13'),
        ('14-sep', '9/14'),
        ('07-jun', '06-07'),
        ('1', '01'),
        ('2', '02'),
        ('3', '03'),
        ('4', '04'),
        ('5', '05'),
        ('6', '06'),
        ('8', '08'),
        ('sep-02', '5002/9'),         /* Strange Excel conversion */
        ('147_5-150cm', '147#5-150cm'),
        ('92_5-95cm', '92#5-95cm'),
        ('3b2', '3d2'),              /* Strange, typo? */
        ('3d3', '3b3')
    ) update bugs_import.results_chronology_import as t
        set sample_name = x.correct_sample_name
    from corrected_sample_names x
    where x.faulty_sample_name = t.sample_name;


with corrected_ages as (
    select *
    from (values
        ('9,00E+05', '900000'), ('1,00E+05', '100000'), ('3,00E+05', '300000'), ('4,00E+05', '400000')
    ) as Y(faulty_age, correct_age)
    ) update bugs_import.results_chronology_import as t
        set "AgeFrom" = x.correct_age
    from corrected_ages x
    where x.faulty_age = t."AgeFrom";

with corrected_ages as (
        select *
        from (values
            ('9,00E+05', '900000'), ('1,00E+05', '100000'), ('3,00E+05', '300000'), ('4,00E+05', '400000')
        ) as Y(faulty_age, correct_age)
    ) update bugs_import.results_chronology_import as t
        set "AgeTo" = x.correct_age
    from corrected_ages x
    where x.faulty_age = t."AgeTo";


do $$
begin
    perform sead_utility.import_pending_results_chronologies('20220916_DDL_RESULTS_CHRONOLOGY');
end $$;

commit;

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
