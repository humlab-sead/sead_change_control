-- Deploy general: 20180601_DDL_TAXA_DROP_VIEWS

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
