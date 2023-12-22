drop view if exists "public"."view_taxa_tree";

create view "public"."view_taxa_tree" as
select
    tbl_taxa_tree_authors.author_name,
    tbl_taxa_tree_master.species,
    tbl_taxa_tree_genera.genus_name,
    tbl_taxa_tree_families.family_name,
    tbl_taxa_tree_orders.order_name,
    tbl_taxa_tree_orders.sort_order
from
    tbl_taxa_tree_orders,
    tbl_taxa_tree_master,
    tbl_taxa_tree_genera,
    tbl_taxa_tree_families,
    tbl_taxa_tree_authors
where
    tbl_taxa_tree_master.genus_id = tbl_taxa_tree_genera.genus_id
    and tbl_taxa_tree_genera.family_id = tbl_taxa_tree_families.family_id
    and tbl_taxa_tree_families.order_id = tbl_taxa_tree_orders.order_id
    and tbl_taxa_tree_authors.author_id = tbl_taxa_tree_master.author_id;

comment on view "public"."view_taxa_tree" is 'Used to view the entire taxanomic tree in one go.';

drop view if exists "public"."view_taxa_tree_select";

create view "public"."view_taxa_tree_select" as
select
    a.author_name as author,
    s.species,
    s.taxon_id,
    g.genus_name as genus,
    g.genus_id,
    f.family_name as family,
    f.family_id,
    o.order_name,
    o.order_id
from
    tbl_taxa_tree_master s
    join tbl_taxa_tree_genera g on s.genus_id = g.genus_id
    join tbl_taxa_tree_families f on g.family_id = f.family_id
    join tbl_taxa_tree_orders o on f.order_id = o.order_id
    left join tbl_taxa_tree_authors a on s.author_id = a.author_id;

comment on view "public"."view_taxa_tree_select" is 'view with all taxa with one row per taxon. Includes the primary ids for each of the included items for easy selections.';

