#!/bin/bash
# Notice: csvcut is part of csvkit (https://csvkit.readthedocs.io/en/1.0.7/index.html)

SHELL=/bin/bash

set -e

script_dir="bugs/deploy/20241111_DDL_RESULTS_CHRONOLOGY"

. $script_dir/.env


# script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


in2csv --skip-lines 1 ${script_dir}/Chronology_20240205.xlsx --sheet "StratigraphicSeq" | csvformat -D ";" > ${script_dir}/stratigraphic_sequences.csv
in2csv --skip-lines 1 ${script_dir}/Chronology_20240205.xlsx --sheet "ArchaeologicalSites" | csvformat -D ";" > ${script_dir}/archeological_sites.csv

csvcut --delimiter ";" --columns identifier,Chosen_C14,Chosen_OtherRadio,Chosen_Calendar,Chosen_Period,AgeFrom,AgeTo ${script_dir}/archeological_sites.csv > ${script_dir}/archeological_sites_csvcut.csv
csvcut --delimiter ";" --columns identifier,Chosen_C14,Chosen_OtherRadio,Chosen_Calendar,Chosen_Period,AgeFrom,AgeTo ${script_dir}/stratigraphic_sequences.csv > ${script_dir}/stratigraphic_sequences_csvcut.csv
