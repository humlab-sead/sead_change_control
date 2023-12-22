create index "tbl_ecocode_groups_idx_ecocodesystemid" on "public"."tbl_ecocode_groups" using btree("ecocode_system_id" "pg_catalog"."int4_ops" asc NULLS last);

create index "tbl_ecocode_groups_idx_label" on "public"."tbl_ecocode_groups" using btree("name" collate "pg_catalog"."default" "pg_catalog"."text_ops" asc NULLS last);

create index "tbl_ecocode_systems_biblioid" on "public"."tbl_ecocode_systems" using btree("biblio_id" "pg_catalog"."int4_ops" asc NULLS last);

create index "tbl_ecocode_systems_ecocodegroupid" on "public"."tbl_ecocode_systems" using btree("name" collate "pg_catalog"."default" "pg_catalog"."text_ops" asc NULLS last);

create index "tbl_languages_language_id" on "public"."tbl_languages" using btree("language_id" "pg_catalog"."int4_ops" asc NULLS last);

create index "idx_biblio_id" on "public"."tbl_sample_group_references" using btree("biblio_id" "pg_catalog"."int4_ops" asc NULLS last);

create index "idx_sample_group_id" on "public"."tbl_sample_group_references" using btree("sample_group_id" "pg_catalog"."int4_ops" asc NULLS last);

create index "tbl_taxa_tree_authors_name" on "public"."tbl_taxa_tree_authors" using btree("author_name" collate "pg_catalog"."default" "pg_catalog"."text_ops" asc NULLS last);

create index "tbl_taxa_tree_families_name" on "public"."tbl_taxa_tree_families" using btree("family_name" collate "pg_catalog"."default" "pg_catalog"."text_ops" asc NULLS last);

create index "tbl_taxa_tree_families_order_id" on "public"."tbl_taxa_tree_families" using btree("order_id" "pg_catalog"."int4_ops" asc NULLS last);

create index "tbl_taxa_tree_genera_family_id" on "public"."tbl_taxa_tree_genera" using btree("family_id" "pg_catalog"."int4_ops" asc NULLS last);

create index "tbl_taxa_tree_genera_name" on "public"."tbl_taxa_tree_genera" using btree("genus_name" collate "pg_catalog"."default" "pg_catalog"."text_ops" asc NULLS last);

create index "tbl_taxa_tree_orders_order_id" on "public"."tbl_taxa_tree_orders" using btree("order_id" "pg_catalog"."int4_ops" asc NULLS last);

create index "tbl_taxonomic_order_taxon_id" on "public"."tbl_taxonomic_order" using btree("taxon_id" "pg_catalog"."int4_ops" asc NULLS last);

create index "tbl_taxonomic_order_taxonomic_code" on "public"."tbl_taxonomic_order" using btree("taxonomic_code" "pg_catalog"."numeric_ops" asc NULLS last);

create index "tbl_taxonomic_order_taxonomic_order_id" on "public"."tbl_taxonomic_order" using btree("taxonomic_order_id" "pg_catalog"."int4_ops" asc NULLS last);

create index "tbl_taxonomic_order_taxonomic_system_id" on "public"."tbl_taxonomic_order" using btree("taxonomic_order_system_id" "pg_catalog"."int4_ops" asc NULLS last);

create index "tbl_taxonomic_order_biblio_biblio_id" on "public"."tbl_taxonomic_order_biblio" using btree("biblio_id" "pg_catalog"."int4_ops" asc NULLS last);

create index "tbl_taxonomic_order_biblio_taxonomic_order_biblio_id" on "public"."tbl_taxonomic_order_biblio" using btree("taxonomic_order_biblio_id" "pg_catalog"."int4_ops" asc NULLS last);

create index "tbl_taxonomic_order_biblio_taxonomic_order_system_id" on "public"."tbl_taxonomic_order_biblio" using btree("taxonomic_order_system_id" "pg_catalog"."int4_ops" asc NULLS last);

create index "tbl_taxonomic_order_systems_taxonomic_system_id" on "public"."tbl_taxonomic_order_systems" using btree("taxonomic_order_system_id" "pg_catalog"."int4_ops" asc NULLS last);

