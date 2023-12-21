-- Deploy general: 20180601_DDL_TAXA_DROP_VIEWS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2018-06-01
  Description   Drop old views.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/171
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
