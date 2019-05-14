-- Deploy sead_change_control:CS_DATINGLAB_20190503_ADD_UNKNOWN_LAB to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-05-03
  Description   New dating lab "Unknown" to accomodate Bugs import
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin
    begin
        
        with new_dating_labs (international_lab_id, lab_name) as (
            values ('Unknown', 'Unknown or unspecified')
        )
        insert into tbl_dating_labs (international_lab_id, lab_name)
            select international_lab_id, n.lab_name
            from new_dating_labs n
            left join tbl_dating_labs x using (international_lab_id)
            where x.lab_name is null;
            
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
