
CREATE INDEX "tbl_ecocode_groups_idx_ecocodesystemid" ON "public"."tbl_ecocode_groups" USING btree (
  "ecocode_system_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_ecocode_groups_idx_label" ON "public"."tbl_ecocode_groups" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_ecocode_systems_biblioid" ON "public"."tbl_ecocode_systems" USING btree (
  "biblio_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_ecocode_systems_ecocodegroupid" ON "public"."tbl_ecocode_systems" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_languages_language_id" ON "public"."tbl_languages" USING btree (
  "language_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_biblio_id" ON "public"."tbl_sample_group_references" USING btree (
  "biblio_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_sample_group_id" ON "public"."tbl_sample_group_references" USING btree (
  "sample_group_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxa_tree_authors_name" ON "public"."tbl_taxa_tree_authors" USING btree (
  "author_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxa_tree_families_name" ON "public"."tbl_taxa_tree_families" USING btree (
  "family_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxa_tree_families_order_id" ON "public"."tbl_taxa_tree_families" USING btree (
  "order_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxa_tree_genera_family_id" ON "public"."tbl_taxa_tree_genera" USING btree (
  "family_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxa_tree_genera_name" ON "public"."tbl_taxa_tree_genera" USING btree (
  "genus_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxa_tree_orders_order_id" ON "public"."tbl_taxa_tree_orders" USING btree (
  "order_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxonomic_order_taxon_id" ON "public"."tbl_taxonomic_order" USING btree (
  "taxon_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxonomic_order_taxonomic_code" ON "public"."tbl_taxonomic_order" USING btree (
  "taxonomic_code" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxonomic_order_taxonomic_order_id" ON "public"."tbl_taxonomic_order" USING btree (
  "taxonomic_order_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxonomic_order_taxonomic_system_id" ON "public"."tbl_taxonomic_order" USING btree (
  "taxonomic_order_system_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxonomic_order_biblio_biblio_id" ON "public"."tbl_taxonomic_order_biblio" USING btree (
  "biblio_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxonomic_order_biblio_taxonomic_order_biblio_id" ON "public"."tbl_taxonomic_order_biblio" USING btree (
  "taxonomic_order_biblio_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxonomic_order_biblio_taxonomic_order_system_id" ON "public"."tbl_taxonomic_order_biblio" USING btree (
  "taxonomic_order_system_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxonomic_order_systems_taxonomic_system_id" ON "public"."tbl_taxonomic_order_systems" USING btree (
  "taxonomic_order_system_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);