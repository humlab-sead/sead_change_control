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
    
        if exists (select 1 from pg_catalog.pg_views where schemaname='public' and viewname = 'view_taxa_tree') then
            drop view "public"."view_taxa_tree";
        end if;

        if exists (select 1 from pg_catalog.pg_views where schemaname='public' and viewname = 'view_taxa_tree_select') then
            drop view "public"."view_taxa_tree_select";
        end if;
        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
