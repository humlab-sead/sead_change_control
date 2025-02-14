-- Deploy sead_api: 20201221_DDL_ECL_RESTAPI_VIEWS
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2020-12-21
  Description   New views for ECL REST AOI
  Prerequisites
  Issue         https://github.com/humlab-sead/sead_change_control/issues/158
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    begin

		    call sead_utility.drop_view('postgrest_api.loc');

        create or replace view postgrest_api.loc
        as

        select
            'paleoecological' 			    as data_type,
            '' 							    as doi,
            tbl_sites.altitude	 		    as elevation, -- Note: not always present
            tbl_sites.latitude_dd		    as lat,
            tbl_sites.site_id			    as locale_id,
            tbl_sites.site_name			    as locale_name,
            tbl_sites.longitude_dd		    as lon,
            ''							    as max_age,
            ''							    as min_age,
            sum(tbl_abundances.abundance)	as occurrences_count,
            tbl_sites.site_id				as site_id,
            'sead' 						    as source

        from tbl_analysis_entities
        left join tbl_datasets
          on tbl_analysis_entities."dataset_id" = tbl_datasets."dataset_id"
        left join tbl_physical_samples
          on tbl_analysis_entities."physical_sample_id" = tbl_physical_samples."physical_sample_id"
        left join tbl_sample_groups
          on tbl_physical_samples."sample_group_id" = tbl_sample_groups."sample_group_id"
        left join tbl_sites
          on tbl_sample_groups."site_id" = tbl_sites."site_id"
        left join tbl_abundances
          on tbl_abundances.analysis_entity_id =  tbl_analysis_entities."analysis_entity_id"

        where tbl_abundances.abundance > 0
        group by locale_name, locale_id, elevation
        order by locale_name;

        alter table postgrest_api.loc owner to postgrest;

        grant all on table postgrest_api.loc to postgrest;
        grant select on table postgrest_api.loc to postgrest_anon;


        if sead_utility.view_exists('postgrest_api', 'occ') then
            drop view postgrest_api.occ;
        end if;

        create or replace view postgrest_api.occ
        as
        select

            'paleoecological' 			as data_type,
            tbl_sites.altitude	 		as elevation, -- Note: not always present
            tbl_sites.latitude_dd		as lat,
            tbl_sites.site_id			as locale_id,
            tbl_sites.site_name			as locale_name,
            tbl_sites.longitude_dd		as lon,
            ''							as max_age,
            ''							as min_age,
            tbl_abundances.abundance_id	as occ_id,
            'sead' 						as source,
            --    tbl_taxa_tree_orders.order_name		as order_name,
            --  tbl_taxa_tree_families.family_name	as family_name,
            --  tbl_taxa_tree_genera.genus_name		as genus_name,
            --  tbl_taxa_tree_master.species		as species,
            concat_ws(' ', family_name, genus_name, species)	as taxon,
            tbl_taxa_tree_master.taxon_id		as taxon_id

        from tbl_analysis_entities
        left join tbl_datasets
          on tbl_analysis_entities."dataset_id" = tbl_datasets."dataset_id"
        --left join tbl_methods
        --  on tbl_datasets."method_id" = tbl_methods."method_id"
        left join tbl_physical_samples
          on tbl_analysis_entities."physical_sample_id" = tbl_physical_samples."physical_sample_id"
        left join tbl_sample_groups
          on tbl_physical_samples."sample_group_id" = tbl_sample_groups."sample_group_id"
        left join tbl_sites
          on tbl_sample_groups."site_id" = tbl_sites."site_id"
        left join tbl_abundances
          on tbl_abundances.analysis_entity_id =  tbl_analysis_entities."analysis_entity_id"
        left join tbl_taxa_tree_master
          on tbl_taxa_tree_master.taxon_id =  tbl_abundances."taxon_id"
        left join tbl_taxa_tree_genera
          on tbl_taxa_tree_genera.genus_id =  tbl_taxa_tree_master."genus_id"
        left join tbl_taxa_tree_families
          on tbl_taxa_tree_families.family_id =  tbl_taxa_tree_genera."family_id"
        left join tbl_taxa_tree_orders
          on tbl_taxa_tree_orders.order_id =  tbl_taxa_tree_families."order_id"

        where abundance > 0
        order by taxon;

        alter table postgrest_api.occ
        owner to postgrest;

        grant all on table postgrest_api.occ to postgrest;
        grant select on table postgrest_api.occ to postgrest_anon;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
