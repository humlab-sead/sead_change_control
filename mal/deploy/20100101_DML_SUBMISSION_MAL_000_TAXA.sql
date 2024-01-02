-- Deploy mal: 20100101_DML_SUBMISSION_MAL_000_TAXA

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2010-01-01
  Description   Initial MAL taxonomic data (equivalent to sead_master_9)
  Issue         https://github.com/humlab-sead/sead_change_control/issues/223
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

set client_min_messages to warning;

\set autocommit off;

begin;

-- set constraints all deferred;
\cd /repo/mal/deploy

/* Taxonomic data */
\copy public.tbl_taxa_tree_orders from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_TAXA/tbl_taxa_tree_orders.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_taxa_tree_families from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_TAXA/tbl_taxa_tree_families.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_taxa_tree_genera from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_TAXA/tbl_taxa_tree_genera.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_taxa_tree_authors from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_TAXA/tbl_taxa_tree_authors.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_taxa_tree_master from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_TAXA/tbl_taxa_tree_master.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_species_associations from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_TAXA/tbl_species_associations.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_taxa_common_names from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_TAXA/tbl_taxa_common_names.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_taxonomic_order_systems from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_TAXA/tbl_taxonomic_order_systems.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_taxonomic_order from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_TAXA/tbl_taxonomic_order.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

commit;

do $$ begin
  perform sead_utility.sync_sequences('public');
end $$;