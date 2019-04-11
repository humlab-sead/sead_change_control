-- Deploy sead_db_change_control:CS_TAXA_20180601_DROP_VIEWS to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description   
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
    
        drop view if exists "public"."view_taxa_tree";
        drop view if exists "public"."view_taxa_tree_select";
        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
