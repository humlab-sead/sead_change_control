-- Deploy bugs: 20240602_DML_RRB_KOCH_UPDATE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-06-02
  Description   No value in descriptive text field.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/116
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    update tbl_ecocode_definitions
        set name = 'larval dipterophagous'
    where name is null
      and abbreviation = 'FNoDi';

    update tbl_ecocode_definitions
        set name = 'Acarophagous'
    where name is null
      and abbreviation = 'FNoMi';
    
end $$;
commit;
