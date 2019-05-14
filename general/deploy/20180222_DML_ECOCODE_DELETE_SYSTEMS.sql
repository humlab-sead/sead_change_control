-- Deploy sead_change_control:CS_ECOCODE_20180222_DELETE_SYSTEMS to pg

/****************************************************************************************************************
  Author        
  Date          2018-02-22
  Description   Remove deprecated ecocode systems
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

    begin
    
        if (select count(*) from "public"."tbl_ecocode_systems" where ecocode_system_id in (2,3)) = 0 then
            raise exception SQLSTATE 'GUARD';
        end if;
        
        delete from tbl_ecocodes
        where ecocode_id in (
            select c.ecocode_id
            from tbl_ecocode_systems s
            join tbl_ecocode_groups g using (ecocode_system_id)
            join tbl_ecocode_definitions using (ecocode_group_id)
            join tbl_ecocodes c using (ecocode_definition_id)
            where s.ecocode_system_id in (2, 3)
        );

        delete from tbl_ecocode_definitions
        where ecocode_definition_id in (
            select d.ecocode_definition_id
            from tbl_ecocode_groups g
            join tbl_ecocode_definitions d using (ecocode_group_id)
            where g.ecocode_system_id in (2, 3)
        );

        delete from 
        from tbl_ecocode_groups
        where ecocode_system_id in (2, 3);

        delete from
        from tbl_ecocode_systems
        where ecocode_system_id in (2, 3);

        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
