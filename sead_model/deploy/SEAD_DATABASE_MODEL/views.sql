
DROP VIEW IF EXISTS "public"."view_taxa_tree";


CREATE VIEW "public"."view_taxa_tree" AS
SELECT tbl_taxa_tree_authors.author_name,
       tbl_taxa_tree_master.species,
       tbl_taxa_tree_genera.genus_name,
       tbl_taxa_tree_families.family_name,
       tbl_taxa_tree_orders.order_name,
       tbl_taxa_tree_orders.sort_order
FROM tbl_taxa_tree_orders,
     tbl_taxa_tree_master,
     tbl_taxa_tree_genera,
     tbl_taxa_tree_families,
     tbl_taxa_tree_authors
WHERE tbl_taxa_tree_master.genus_id = tbl_taxa_tree_genera.genus_id
    AND tbl_taxa_tree_genera.family_id = tbl_taxa_tree_families.family_id
    AND tbl_taxa_tree_families.order_id = tbl_taxa_tree_orders.order_id
    AND tbl_taxa_tree_authors.author_id = tbl_taxa_tree_master.author_id;

COMMENT ON VIEW "public"."view_taxa_tree" IS 'Used to view the entire taxanomic tree in one go.';


DROP VIEW IF EXISTS "public"."view_taxa_tree_select";


CREATE VIEW "public"."view_taxa_tree_select" AS
SELECT a.author_name AS author,
       s.species,
       s.taxon_id,
       g.genus_name AS genus,
       g.genus_id,
       f.family_name AS family,
       f.family_id,
       o.order_name,
       o.order_id
FROM tbl_taxa_tree_master s
JOIN tbl_taxa_tree_genera g ON s.genus_id = g.genus_id
JOIN tbl_taxa_tree_families f ON g.family_id = f.family_id
JOIN tbl_taxa_tree_orders o ON f.order_id = o.order_id
LEFT JOIN tbl_taxa_tree_authors a ON s.author_id = a.author_id;

COMMENT ON VIEW "public"."view_taxa_tree_select" IS 'view with all taxa with one row per taxon. Includes the primary ids for each of the included items for easy selections.';

