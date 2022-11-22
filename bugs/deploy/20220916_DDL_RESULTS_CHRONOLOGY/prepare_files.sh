#!/bin/bash
# Notice: csvcut is part of csvkit (https://csvkit.readthedocs.io/en/1.0.7/index.html)

 csvcut --delimiter ";" --columns identifier,Chosen_C14,Chosen_OtherRadio,Chosen_Calendar,Chosen_Period,AgeFrom,AgeTo bugs/deploy/20220916_DDL_RESULTS_CHRONOLOGY/archeological_sites.csv > bugs/deploy/20220916_DDL_RESULTS_CHRONOLOGY/archeological_sites_csvcut.csv
 csvcut --delimiter ";" --columns identifier,Chosen_C14,Chosen_OtherRadio,Chosen_Calendar,Chosen_Period,AgeFrom,AgeTo bugs/deploy/20220916_DDL_RESULTS_CHRONOLOGY/stratigraphic_sequences.csv > bugs/deploy/20220916_DDL_RESULTS_CHRONOLOGY/stratigraphic_sequences_csvcut.csv
