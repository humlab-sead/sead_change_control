-- Deploy mal: 20100101_DML_SUBMISSION_MAL_000_LOOKUPS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2010-01-01
  Description   Initial MAL lookup data (equivalent to sead_master_9)
  Issue         https://github.com/humlab-sead/sead_change_control/issues/222
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

\copy public.tbl_contacts from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_contacts.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_dataset_masters from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_dataset_masters.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_dating_labs from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_dating_labs.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_group_sampling_contexts from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_sample_group_sampling_contexts.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

\copy public.tbl_collections_or_journals from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_collections_or_journals.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_publishers from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_publishers.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_biblio from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_biblio.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

\copy public.tbl_method_groups from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_method_groups.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_methods from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_methods.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

\copy public.tbl_dating_uncertainty from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_dating_uncertainty.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_features from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_features.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_horizons from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_horizons.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_abundance_elements from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_abundance_elements.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_identification_levels from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_identification_levels.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

\copy public.tbl_dimensions from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_dimensions.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_coordinate_method_dimensions from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_coordinate_method_dimensions.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

\copy public.tbl_sites ("site_id", "altitude", "latitude_dd", "longitude_dd", "national_site_identifier", "site_description", "site_name", "site_preservation_status_id", "date_updated") from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_sites.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_site_locations from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_site_locations.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_site_references from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_site_references.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

commit;

do $$ begin
  perform sead_utility.sync_sequences('public');
end $$;
