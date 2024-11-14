#!/bin/bash
# Notice: csvcut is part of csvkit (https://csvkit.readthedocs.io/en/1.0.7/index.html)

SHELL=/bin/bash

set -e

script_dir="bugs/deploy/20241111_DDL_RESULTS_CHRONOLOGY"

. $script_dir/.env


# alter table results_chronology_temp rename to results_chronology_temp_xyz;

# script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cmd=$(cat <<EOF

drop view if exists postgrest_default_api.results_chronology_temp;

drop table if exists bugs_import.results_chronology_import;

create table bugs_import.results_chronology_import (
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


\copy bugs_import.results_chronology_import ("identifier","Chosen_C14","Chosen_OtherRadio","Chosen_Calendar","Chosen_Period","AgeFrom","AgeTo") from '${script_dir}/archeological_sites_csvcut.csv'  with ( format csv,  header, quote '"', delimiter ',',  encoding 'utf-8' );

update bugs_import.results_chronology_import set "change_request" = '20241111_DDL_RESULTS_CHRONOLOGY', "source" = 'archeological_sites' where "source" is null;

\copy bugs_import.results_chronology_import ("identifier","Chosen_C14","Chosen_OtherRadio","Chosen_Calendar","Chosen_Period","AgeFrom","AgeTo") from '${script_dir}/stratigraphic_sequences_csvcut.csv'  with ( format csv,  header, quote '"', delimiter ',',  encoding 'utf-8' );

update bugs_import.results_chronology_import set "change_request" = '20241111_DDL_RESULTS_CHRONOLOGY', "source" = 'stratigraphic_sequences' where "source" is null;

EOF
)

in2csv --skip-lines 1 ${script_dir}/Chronology_20240205.xlsx --sheet "StratigraphicSeq" | csvformat -D ";" > ${script_dir}/stratigraphic_sequences.csv
in2csv --skip-lines 1 ${script_dir}/Chronology_20240205.xlsx --sheet "ArchaeologicalSites" | csvformat -D ";" > ${script_dir}/archeological_sites.csv

csvcut --delimiter ";" --columns identifier,Chosen_C14,Chosen_OtherRadio,Chosen_Calendar,Chosen_Period,AgeFrom,AgeTo ${script_dir}/archeological_sites.csv > ${script_dir}/archeological_sites_csvcut.csv
csvcut --delimiter ";" --columns identifier,Chosen_C14,Chosen_OtherRadio,Chosen_Calendar,Chosen_Period,AgeFrom,AgeTo ${script_dir}/stratigraphic_sequences.csv > ${script_dir}/stratigraphic_sequences_csvcut.csv

echo "$cmd" > ${script_dir}/temp_script.sql

psql -h $dbhost -U $dbuser -d $dbname -p $dbport -f ${script_dir}/temp_script.sql

