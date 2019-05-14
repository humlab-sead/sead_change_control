-- Deploy sead_db_change_control:CS_TAXA_20190410_CREATE_VIEW_ALPHABETICALLY to pg

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
    
        if sead_utility.tab_exists('public'::text, 'table_name'::text, 'column_name'::text) = TRUE then
            raise exception SQLSTATE 'GUARD';
        end if;
        
        -- insert your DDL code here
        
        CREATE VIEW "public"."view_taxa_alphabetically" AS  SELECT o.order_id,
            o.order_name AS "order",
            f.family_id,
            f.family_name AS family,
            g.genus_id,
            g.genus_name AS genus,
            s.taxon_id,
            s.species,
            a.author_id,
            a.author_name AS author
           FROM ((((tbl_taxa_tree_master s
             JOIN tbl_taxa_tree_genera g ON ((s.genus_id = g.genus_id)))
             JOIN tbl_taxa_tree_families f ON ((g.family_id = f.family_id)))
             JOIN tbl_taxa_tree_orders o ON ((f.order_id = o.order_id)))
             LEFT JOIN tbl_taxa_tree_authors a ON ((s.author_id = a.author_id)))
          ORDER BY o.order_name, f.family_name, g.genus_name, s.species;
  
        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
