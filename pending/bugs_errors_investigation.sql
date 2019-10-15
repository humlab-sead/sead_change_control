with bugs_values as (
    select *, string_to_array(translate(bugs_data, '{}', ''), ',') as decoded_bugs_data
    from bugs_import.bugs_errors
    where TRUE
) select decoded_bugs_data[4], count(*)
  from bugs_values
  where TRUE
    -- and array_length(data, 1) = 7
    and message = 'Association type not found'
 group by decoded_bugs_data[4]

select * from tbl_species_association_types

On creation of each bugs datasets, tbl_dataset_submissions entries need to be created automatically.
Submission type as follows:
"submission_type_id";"submission_type";"description"
5;"Compilation into SEAD from another database";"Single dataset from another database submission into SEAD"

select *
from tbl_dataset_submissions
UPDATE tbl_species_association_types SET association_type = 'inquiline with ' WHERE association_type = 'inquiline';

select *
from bugs_import.bugs_type_translations
where bugs_column = 'SheetType'

insert into bugs_import.bugs_type_translations (bugs_table, bugs_column, triggering_column_value, target_column, replacement_value)
values ('TCountsheet', 'SheetType', null, 'SheetType', 'Undefined other');

with error_values as (
    select *, string_to_array(translate(bugs_data, '{}', ''), ',') as data_array
    from bugs_import.bugs_errors
    where TRUE
      and message = 'Unsupported countsheet data type'
) select data_array[3], count(*) as count
  from error_values
  group by data_array[3]
  order by 2 desc
  
select *
from tbl_dataset_submission_types

BugsData:   submission_type: 5  contact_id: Phil submitted_data: (date_updated from dataset)
MAL_Data:   submission_type: 7 (om Eriks client) contact_id: Phil submitted_data: (date_updated from dataset)

Iso_Data:   submission_type: 12 contact_id: Phil submitted_data: (date_updated from dataset)                       
Dendro:     submission_type: 13 / Compilation into SEAD from another database
Ceramic:    submission_type: 13 / Compilation into SEAD from another database
Pollen:     submission_type: 14 / Compilation into SEAD from another database

-- Ny submission_type: 12, Compilation into SEAD via (articles + Excel) => Excel => XML => CH => SEAD
-- Ny submission_type: 13, Compilation into SEAD via external DB (excel) => Excel => XML => CH => SEAD
-- Ny submission_type: 14, Compilation into SEAD via external TILIA => XML => (Excel) => XML => CH => SEAD
