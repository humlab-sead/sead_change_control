-- Deploy sead_change_control:CS_META_20190411_VIEW_UPDATES to pg

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
        -- NOTE: Not sure if these diffs are relevant
        /*
        drop view if exists "metainformation"."view_abundance" cascade;
        drop view if exists "metainformation"."view_abundances_by_taxon_analysis_entity" cascade;
        drop view if exists "metainformation"."view_sample_group_references" cascade;
        drop view if exists "metainformation"."view_site_references" cascade;
        drop view if exists "metainformation"."view_taxa_biblio" cascade;
        */
        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
