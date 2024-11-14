-- Deploy bugs: 20241111_DDL_RESULTS_CHRONOLOGY

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-11-11
  Description   New/updated analysis entity ages data
  Issue         https://github.com/humlab-sead/sead_change_control/issues/315
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes         Additional data for analysis entity ages
                See issue https://github.com/humlab-sead/sead_change_control/issues/17

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

\copy bugs_import.results_chronology_import ("identifier","Chosen_C14","Chosen_OtherRadio","Chosen_Calendar","Chosen_Period","AgeFrom","AgeTo") from 'deploy/20241111_DDL_RESULTS_CHRONOLOGY/archeological_sites_csvcut.csv'  with ( format csv,  header, quote '"', delimiter ',',  encoding 'utf-8' );

update bugs_import.results_chronology_import set "change_request" = '20241111_DDL_RESULTS_CHRONOLOGY', "source" = 'archeological_sites' where "source" is null;

\copy bugs_import.results_chronology_import ("identifier","Chosen_C14","Chosen_OtherRadio","Chosen_Calendar","Chosen_Period","AgeFrom","AgeTo") from 'deploy/20241111_DDL_RESULTS_CHRONOLOGY/stratigraphic_sequences_csvcut.csv'  with ( format csv,  header, quote '"', delimiter ',',  encoding 'utf-8' );

update bugs_import.results_chronology_import set "change_request" = '20241111_DDL_RESULTS_CHRONOLOGY', "source" = 'stratigraphic_sequences' where "source" is null;

do $$
begin
    perform sead_utility.import_pending_results_chronologies('20241111_DDL_RESULTS_CHRONOLOGY');
end $$;

end;

commit;

