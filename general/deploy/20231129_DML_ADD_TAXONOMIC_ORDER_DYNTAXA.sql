-- Deploy sead_change_control:20231129_DML_ADD_TAXONOMIC_ORDER_DYNTAXA to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2023-11-29
  Description   
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

\echo 'Importing DynTaxa data...';


begin;


drop table if exists dyntaxa_taxonomyc_order_system_temp;

create table dyntaxa_taxonomyc_order_system_temp (
    "SEAD_taxonomic_code" varchar,
    "SEAD_taxon_id" varchar,
    "SEAD_taxon" varchar,
    "SEAD_author_name" varchar,
    "Dyntaxa_taxonID" varchar
);

\copy dyntaxa_taxonomyc_order_system_temp ("SEAD_taxonomic_code", "SEAD_taxon_id", "SEAD_taxon", "SEAD_author_name", "Dyntaxa_taxonID") from 'general/deploy/20231129_DML_ADD_TAXONOMIC_ORDER_DYNTAXA/Results_taxonomy_SEAD_Dyntaxa_ALLTAXA.tsv' with ( format csv,  header, delimiter E'\t',  encoding 'utf-8' );

do $$
begin
    declare v_taxonomic_order_system_id int;

    begin

        v_taxonomic_order_system_id = 2

        if not exists (select 1 from tbl_taxonomic_order_systems where taxonomic_order_system_id = 2) then

            insert into tbl_taxonomic_order_systems (taxonomic_order_system_id, date_updated, system_description, system_name)
                values (
                    v_taxonomic_order_system_id,
                    '2023-11-29',
                    'Taxonomic order system that maps the taxonomy in SEAD with the taxonomy in Dyntaxa.',
                    'Dyntaxa taxonomic order'
                )

        end if;

        insert into public.tbl_taxonomic_order(taxon_id, taxonomic_code, taxonomic_order_system_id, date_updated)
          select "SEAD_taxon_id"::int as taxon_id, trim("Dyntaxa_taxonID") as taxonomic_code, v_taxonomic_order_system_id, '2023-11-29'
          from dyntaxa_taxonomyc_order_system_temp tmp
          left join tbl_taxa_tree_master taxa
            on taxa.taxon_id = tmp."SEAD_taxon_id"::int;
            
    end;
    
end $$;

commit;
