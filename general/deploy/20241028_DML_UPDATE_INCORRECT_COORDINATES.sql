-- Deploy general: 20241028_DML_UPDATE_INCORRECT_COORDINATES

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-10-28
  Description   Update of some incorrect corrdinates
  Issue         https://github.com/humlab-sead/sead_change_control/issues/320
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    update tbl_sites set longitude_dd = 12.5772220000 where site_name = 'Copenhagen' and longitude_dd = -12.5772220000;
    update tbl_sites set longitude_dd = 12.850000 where site_name = 'Halmstad' and longitude_dd = 12.0833330000;
    
end $$;
commit;
