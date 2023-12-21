-- Deploy general: 20120921_DML_DATATYPE_UPDATE_DESCRIPTION

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2012-09-21
  Description   Add three types
  Issue         https://github.com/humlab-sead/sead_change_control/issues/183
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Revertable    No
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    if not exists (select 1 from public.tbl_data_types where data_type_id = 6) then
        raise exception 'Data type 6 does not exist';
    end if;
    
    update "public"."tbl_data_types"
        set "definition" = 'The element/fossil is present in the sample, but not quantified (numerical classification where 1 = presence)'
    where "data_type_id" = 6;
    
end $$;
commit;
