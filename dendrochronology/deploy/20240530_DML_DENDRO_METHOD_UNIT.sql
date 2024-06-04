-- Deploy dendrochronology: 20240530_DML_DENDRO_METHOD_UNIT

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-05-30
  Description   Fix incorrect unit in Dendrochronlogy method
  Issue         https://github.com/humlab-sead/sead_change_control/issues/281
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    update tbl_methods
        set unit_id = 8
    where method_id = 10
    and method_name = 'Dendrochronology'
    and unit_id = 7;
    
end $$;
commit;
