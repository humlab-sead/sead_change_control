-- Deploy sead_model: SEAD_DATABASE_LOOKUPS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2023-12-21
  Issue         https://github.com/humlab-sead/sead_change_control/issues/220
  Description   Initial set of lookup values in the SEAD database
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes         20241113: Changed to plain text file to simplify adding backdated changes
                e.g.
                \copy public.tbl_activity_types from program 'zcat -qac SEAD_DATABASE_LOOKUPS/tbl_activity_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
                changed to
                \copy public.tbl_activity_types from 'SEAD_DATABASE_LOOKUPS/tbl_activity_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');

*****************************************************************************************************************/
set client_min_messages to warning;

\set autocommit off;

begin;

set constraints all deferred;
\cd /repo/sead_model/deploy


\copy public.tbl_activity_types from 'SEAD_DATABASE_LOOKUPS/tbl_activity_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_aggregate_order_types from 'SEAD_DATABASE_LOOKUPS/tbl_aggregate_order_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_alt_ref_types from 'SEAD_DATABASE_LOOKUPS/tbl_alt_ref_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_contact_types from 'SEAD_DATABASE_LOOKUPS/tbl_contact_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_data_type_groups from 'SEAD_DATABASE_LOOKUPS/tbl_data_type_groups.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_data_types from 'SEAD_DATABASE_LOOKUPS/tbl_data_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_dataset_submission_types from 'SEAD_DATABASE_LOOKUPS/tbl_dataset_submission_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_feature_types from 'SEAD_DATABASE_LOOKUPS/tbl_feature_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_image_types from 'SEAD_DATABASE_LOOKUPS/tbl_image_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_languages from 'SEAD_DATABASE_LOOKUPS/tbl_languages.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_location_types from 'SEAD_DATABASE_LOOKUPS/tbl_location_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_locations from 'SEAD_DATABASE_LOOKUPS/tbl_locations.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_modification_types from 'SEAD_DATABASE_LOOKUPS/tbl_modification_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_project_stages from 'SEAD_DATABASE_LOOKUPS/tbl_project_stages.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_project_types from 'SEAD_DATABASE_LOOKUPS/tbl_project_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_publication_types from 'SEAD_DATABASE_LOOKUPS/tbl_publication_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_record_types from 'SEAD_DATABASE_LOOKUPS/tbl_record_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_relative_age_types from 'SEAD_DATABASE_LOOKUPS/tbl_relative_age_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_description_types from 'SEAD_DATABASE_LOOKUPS/tbl_sample_description_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_group_description_types from 'SEAD_DATABASE_LOOKUPS/tbl_sample_group_description_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_types from 'SEAD_DATABASE_LOOKUPS/tbl_sample_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_season_types from 'SEAD_DATABASE_LOOKUPS/tbl_season_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_seasons from 'SEAD_DATABASE_LOOKUPS/tbl_seasons.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_species_association_types from 'SEAD_DATABASE_LOOKUPS/tbl_species_association_types.sql' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_units from 'SEAD_DATABASE_LOOKUPS/tbl_units.sql' with (format text, delimiter E'\t', encoding 'utf-8');

commit;

do $$
begin
  perform sead_utility.sync_sequences('public');
end $$;
