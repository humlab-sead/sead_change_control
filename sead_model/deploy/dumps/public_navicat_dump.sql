/*
 Navicat PostgreSQL Data Transfer

 Source Server         : SEAD
 Source Server Type    : PostgreSQL
 Source Server Version : 110002 (110002)
 Source Host           : humlabseadserv.srv.its.umu.se:5432
 Source Catalog        : sead_staging_mal
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 110002 (110002)
 File Encoding         : 65001

 Date: 20/12/2023 08:08:45
*/


-- ----------------------------
-- Type structure for breakpoint
-- ----------------------------
DROP TYPE IF EXISTS "public"."breakpoint";
CREATE TYPE "public"."breakpoint" AS (
  "func" oid,
  "linenumber" int4,
  "targetname" text COLLATE "pg_catalog"."default"
);
ALTER TYPE "public"."breakpoint" OWNER TO "sead_master";

-- ----------------------------
-- Type structure for dblink_pkey_results
-- ----------------------------
DROP TYPE IF EXISTS "public"."dblink_pkey_results";
CREATE TYPE "public"."dblink_pkey_results" AS (
  "position" int4,
  "colname" text COLLATE "pg_catalog"."default"
);
ALTER TYPE "public"."dblink_pkey_results" OWNER TO "sead_master";

-- ----------------------------
-- Type structure for frame
-- ----------------------------
DROP TYPE IF EXISTS "public"."frame";
CREATE TYPE "public"."frame" AS (
  "level" int4,
  "targetname" text COLLATE "pg_catalog"."default",
  "func" oid,
  "linenumber" int4,
  "args" text COLLATE "pg_catalog"."default"
);
ALTER TYPE "public"."frame" OWNER TO "sead_master";

-- ----------------------------
-- Type structure for proxyinfo
-- ----------------------------
DROP TYPE IF EXISTS "public"."proxyinfo";
CREATE TYPE "public"."proxyinfo" AS (
  "serverversionstr" text COLLATE "pg_catalog"."default",
  "serverversionnum" int4,
  "proxyapiver" int4,
  "serverprocessid" int4
);
ALTER TYPE "public"."proxyinfo" OWNER TO "sead_master";

-- ----------------------------
-- Type structure for targetinfo
-- ----------------------------
DROP TYPE IF EXISTS "public"."targetinfo";
CREATE TYPE "public"."targetinfo" AS (
  "target" oid,
  "schema" oid,
  "nargs" int4,
  "argtypes" "pg_catalog"."oidvector",
  "targetname" "pg_catalog"."name",
  "argmodes" char(1)[] COLLATE "pg_catalog"."default",
  "argnames" text[] COLLATE "pg_catalog"."default",
  "targetlang" oid,
  "fqname" text COLLATE "pg_catalog"."default",
  "returnsset" bool,
  "returntype" oid
);
ALTER TYPE "public"."targetinfo" OWNER TO "sead_master";

-- ----------------------------
-- Type structure for tbiblio
-- ----------------------------
DROP TYPE IF EXISTS "public"."tbiblio";
CREATE TYPE "public"."tbiblio" AS (
  "reference" varchar(60) COLLATE "pg_catalog"."default",
  "author" varchar(255) COLLATE "pg_catalog"."default",
  "title" text COLLATE "pg_catalog"."default",
  "notes" text COLLATE "pg_catalog"."default"
);
ALTER TYPE "public"."tbiblio" OWNER TO "sead_master";

-- ----------------------------
-- Type structure for tcountsheet
-- ----------------------------
DROP TYPE IF EXISTS "public"."tcountsheet";
CREATE TYPE "public"."tcountsheet" AS (
  "countsheetcode" varchar(10) COLLATE "pg_catalog"."default",
  "countsheetname" varchar(100) COLLATE "pg_catalog"."default",
  "sitecode" varchar(10) COLLATE "pg_catalog"."default",
  "sheetcontext" varchar(25) COLLATE "pg_catalog"."default",
  "sheettype" varchar(25) COLLATE "pg_catalog"."default"
);
ALTER TYPE "public"."tcountsheet" OWNER TO "sead_master";

-- ----------------------------
-- Type structure for tfossil
-- ----------------------------
DROP TYPE IF EXISTS "public"."tfossil";
CREATE TYPE "public"."tfossil" AS (
  "fossilbugscode" varchar(10) COLLATE "pg_catalog"."default",
  "code" numeric(18,10),
  "samplecode" varchar(10) COLLATE "pg_catalog"."default",
  "abundance" int4
);
ALTER TYPE "public"."tfossil" OWNER TO "sead_master";

-- ----------------------------
-- Type structure for tsample
-- ----------------------------
DROP TYPE IF EXISTS "public"."tsample";
CREATE TYPE "public"."tsample" AS (
  "samplecode" varchar(10) COLLATE "pg_catalog"."default",
  "sitecode" varchar(10) COLLATE "pg_catalog"."default",
  "x" varchar(50) COLLATE "pg_catalog"."default",
  "y" varchar(50) COLLATE "pg_catalog"."default",
  "zordepthtop" numeric(18,10),
  "zordepthbot" numeric(18,10),
  "refnrcontext" varchar(50) COLLATE "pg_catalog"."default",
  "countsheetcode" varchar(10) COLLATE "pg_catalog"."default"
);
ALTER TYPE "public"."tsample" OWNER TO "sead_master";

-- ----------------------------
-- Type structure for var
-- ----------------------------
DROP TYPE IF EXISTS "public"."var";
CREATE TYPE "public"."var" AS (
  "name" text COLLATE "pg_catalog"."default",
  "varclass" char(1) COLLATE "pg_catalog"."default",
  "linenumber" int4,
  "isunique" bool,
  "isconst" bool,
  "isnotnull" bool,
  "dtype" oid,
  "value" text COLLATE "pg_catalog"."default"
);
ALTER TYPE "public"."var" OWNER TO "sead_master";

-- ----------------------------
-- Sequence structure for tbl_abundance_elements_abundance_element_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_abundance_elements_abundance_element_id_seq";
CREATE SEQUENCE "public"."tbl_abundance_elements_abundance_element_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_abundance_ident_levels_abundance_ident_level_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_abundance_ident_levels_abundance_ident_level_id_seq";
CREATE SEQUENCE "public"."tbl_abundance_ident_levels_abundance_ident_level_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_abundance_modifications_abundance_modification_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_abundance_modifications_abundance_modification_id_seq";
CREATE SEQUENCE "public"."tbl_abundance_modifications_abundance_modification_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_abundances_abundance_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_abundances_abundance_id_seq";
CREATE SEQUENCE "public"."tbl_abundances_abundance_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_activity_types_activity_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_activity_types_activity_type_id_seq";
CREATE SEQUENCE "public"."tbl_activity_types_activity_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_aggregate_datasets_aggregate_dataset_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_aggregate_datasets_aggregate_dataset_id_seq";
CREATE SEQUENCE "public"."tbl_aggregate_datasets_aggregate_dataset_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_aggregate_order_types_aggregate_order_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_aggregate_order_types_aggregate_order_type_id_seq";
CREATE SEQUENCE "public"."tbl_aggregate_order_types_aggregate_order_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_aggregate_sample_ages_aggregate_sample_age_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_aggregate_sample_ages_aggregate_sample_age_id_seq";
CREATE SEQUENCE "public"."tbl_aggregate_sample_ages_aggregate_sample_age_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_aggregate_samples_aggregate_sample_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_aggregate_samples_aggregate_sample_id_seq";
CREATE SEQUENCE "public"."tbl_aggregate_samples_aggregate_sample_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_alt_ref_types_alt_ref_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_alt_ref_types_alt_ref_type_id_seq";
CREATE SEQUENCE "public"."tbl_alt_ref_types_alt_ref_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_analysis_entities_analysis_entity_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_analysis_entities_analysis_entity_id_seq";
CREATE SEQUENCE "public"."tbl_analysis_entities_analysis_entity_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_analysis_entity_ages_analysis_entity_age_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_analysis_entity_ages_analysis_entity_age_id_seq";
CREATE SEQUENCE "public"."tbl_analysis_entity_ages_analysis_entity_age_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq";
CREATE SEQUENCE "public"."tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq";
CREATE SEQUENCE "public"."tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_association_types_association_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_association_types_association_type_id_seq";
CREATE SEQUENCE "public"."tbl_association_types_association_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_biblio_biblio_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_biblio_biblio_id_seq";
CREATE SEQUENCE "public"."tbl_biblio_biblio_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_biblio_keywords_biblio_keyword_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_biblio_keywords_biblio_keyword_id_seq";
CREATE SEQUENCE "public"."tbl_biblio_keywords_biblio_keyword_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_ceramics_ceramics_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_ceramics_ceramics_id_seq";
CREATE SEQUENCE "public"."tbl_ceramics_ceramics_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_ceramics_measurement_look_ceramics_measurement_lookup_i_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_ceramics_measurement_look_ceramics_measurement_lookup_i_seq";
CREATE SEQUENCE "public"."tbl_ceramics_measurement_look_ceramics_measurement_lookup_i_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_ceramics_measurements_ceramics_measurement_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_ceramics_measurements_ceramics_measurement_id_seq";
CREATE SEQUENCE "public"."tbl_ceramics_measurements_ceramics_measurement_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_chron_control_types_chron_control_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_chron_control_types_chron_control_type_id_seq";
CREATE SEQUENCE "public"."tbl_chron_control_types_chron_control_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_chron_controls_chron_control_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_chron_controls_chron_control_id_seq";
CREATE SEQUENCE "public"."tbl_chron_controls_chron_control_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_chronologies_chronology_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_chronologies_chronology_id_seq";
CREATE SEQUENCE "public"."tbl_chronologies_chronology_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_collections_or_journals_collection_or_journal_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_collections_or_journals_collection_or_journal_id_seq";
CREATE SEQUENCE "public"."tbl_collections_or_journals_collection_or_journal_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_colours_colour_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_colours_colour_id_seq";
CREATE SEQUENCE "public"."tbl_colours_colour_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_contact_types_contact_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_contact_types_contact_type_id_seq";
CREATE SEQUENCE "public"."tbl_contact_types_contact_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_contacts_contact_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_contacts_contact_id_seq";
CREATE SEQUENCE "public"."tbl_contacts_contact_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq";
CREATE SEQUENCE "public"."tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_data_type_groups_data_type_group_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_data_type_groups_data_type_group_id_seq";
CREATE SEQUENCE "public"."tbl_data_type_groups_data_type_group_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_data_types_data_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_data_types_data_type_id_seq";
CREATE SEQUENCE "public"."tbl_data_types_data_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_dataset_contacts_dataset_contact_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_dataset_contacts_dataset_contact_id_seq";
CREATE SEQUENCE "public"."tbl_dataset_contacts_dataset_contact_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_dataset_masters_master_set_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_dataset_masters_master_set_id_seq";
CREATE SEQUENCE "public"."tbl_dataset_masters_master_set_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_dataset_submission_types_submission_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_dataset_submission_types_submission_type_id_seq";
CREATE SEQUENCE "public"."tbl_dataset_submission_types_submission_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_dataset_submissions_dataset_submission_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_dataset_submissions_dataset_submission_id_seq";
CREATE SEQUENCE "public"."tbl_dataset_submissions_dataset_submission_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_datasets_dataset_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_datasets_dataset_id_seq";
CREATE SEQUENCE "public"."tbl_datasets_dataset_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_dating_labs_dating_lab_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_dating_labs_dating_lab_id_seq";
CREATE SEQUENCE "public"."tbl_dating_labs_dating_lab_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_dating_material_dating_material_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_dating_material_dating_material_id_seq";
CREATE SEQUENCE "public"."tbl_dating_material_dating_material_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_dating_uncertainty_dating_uncertainty_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_dating_uncertainty_dating_uncertainty_id_seq";
CREATE SEQUENCE "public"."tbl_dating_uncertainty_dating_uncertainty_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_dendro_date_notes_dendro_date_note_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_dendro_date_notes_dendro_date_note_id_seq";
CREATE SEQUENCE "public"."tbl_dendro_date_notes_dendro_date_note_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_dendro_dates_dendro_date_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_dendro_dates_dendro_date_id_seq";
CREATE SEQUENCE "public"."tbl_dendro_dates_dendro_date_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_dendro_dendro_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_dendro_dendro_id_seq";
CREATE SEQUENCE "public"."tbl_dendro_dendro_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_dendro_measurement_lookup_dendro_measurement_lookup_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_dendro_measurement_lookup_dendro_measurement_lookup_id_seq";
CREATE SEQUENCE "public"."tbl_dendro_measurement_lookup_dendro_measurement_lookup_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_dendro_measurements_dendro_measurement_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_dendro_measurements_dendro_measurement_id_seq";
CREATE SEQUENCE "public"."tbl_dendro_measurements_dendro_measurement_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_dimensions_dimension_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_dimensions_dimension_id_seq";
CREATE SEQUENCE "public"."tbl_dimensions_dimension_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_ecocode_definitions_ecocode_definition_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_ecocode_definitions_ecocode_definition_id_seq";
CREATE SEQUENCE "public"."tbl_ecocode_definitions_ecocode_definition_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_ecocode_groups_ecocode_group_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_ecocode_groups_ecocode_group_id_seq";
CREATE SEQUENCE "public"."tbl_ecocode_groups_ecocode_group_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_ecocode_systems_ecocode_system_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_ecocode_systems_ecocode_system_id_seq";
CREATE SEQUENCE "public"."tbl_ecocode_systems_ecocode_system_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_ecocodes_ecocode_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_ecocodes_ecocode_id_seq";
CREATE SEQUENCE "public"."tbl_ecocodes_ecocode_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_feature_types_feature_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_feature_types_feature_type_id_seq";
CREATE SEQUENCE "public"."tbl_feature_types_feature_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_features_feature_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_features_feature_id_seq";
CREATE SEQUENCE "public"."tbl_features_feature_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_geochron_refs_geochron_ref_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_geochron_refs_geochron_ref_id_seq";
CREATE SEQUENCE "public"."tbl_geochron_refs_geochron_ref_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_geochronology_geochron_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_geochronology_geochron_id_seq";
CREATE SEQUENCE "public"."tbl_geochronology_geochron_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_horizons_horizon_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_horizons_horizon_id_seq";
CREATE SEQUENCE "public"."tbl_horizons_horizon_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_identification_levels_identification_level_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_identification_levels_identification_level_id_seq";
CREATE SEQUENCE "public"."tbl_identification_levels_identification_level_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_image_types_image_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_image_types_image_type_id_seq";
CREATE SEQUENCE "public"."tbl_image_types_image_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq";
CREATE SEQUENCE "public"."tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_keywords_keyword_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_keywords_keyword_id_seq";
CREATE SEQUENCE "public"."tbl_keywords_keyword_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_languages_language_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_languages_language_id_seq";
CREATE SEQUENCE "public"."tbl_languages_language_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_lithology_lithology_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_lithology_lithology_id_seq";
CREATE SEQUENCE "public"."tbl_lithology_lithology_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_location_types_location_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_location_types_location_type_id_seq";
CREATE SEQUENCE "public"."tbl_location_types_location_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_locations_location_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_locations_location_id_seq";
CREATE SEQUENCE "public"."tbl_locations_location_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_mcr_names_taxon_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_mcr_names_taxon_id_seq";
CREATE SEQUENCE "public"."tbl_mcr_names_taxon_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_mcr_summary_data_mcr_summary_data_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_mcr_summary_data_mcr_summary_data_id_seq";
CREATE SEQUENCE "public"."tbl_mcr_summary_data_mcr_summary_data_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq";
CREATE SEQUENCE "public"."tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_measured_value_dimensions_measured_value_dimension_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_measured_value_dimensions_measured_value_dimension_id_seq";
CREATE SEQUENCE "public"."tbl_measured_value_dimensions_measured_value_dimension_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_measured_values_measured_value_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_measured_values_measured_value_id_seq";
CREATE SEQUENCE "public"."tbl_measured_values_measured_value_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_method_groups_method_group_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_method_groups_method_group_id_seq";
CREATE SEQUENCE "public"."tbl_method_groups_method_group_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_methods_method_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_methods_method_id_seq";
CREATE SEQUENCE "public"."tbl_methods_method_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_modification_types_modification_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_modification_types_modification_type_id_seq";
CREATE SEQUENCE "public"."tbl_modification_types_modification_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_physical_sample_features_physical_sample_feature_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_physical_sample_features_physical_sample_feature_id_seq";
CREATE SEQUENCE "public"."tbl_physical_sample_features_physical_sample_feature_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_physical_samples_physical_sample_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_physical_samples_physical_sample_id_seq";
CREATE SEQUENCE "public"."tbl_physical_samples_physical_sample_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_project_stage_project_stage_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_project_stage_project_stage_id_seq";
CREATE SEQUENCE "public"."tbl_project_stage_project_stage_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_project_types_project_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_project_types_project_type_id_seq";
CREATE SEQUENCE "public"."tbl_project_types_project_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_projects_project_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_projects_project_id_seq";
CREATE SEQUENCE "public"."tbl_projects_project_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_publication_types_publication_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_publication_types_publication_type_id_seq";
CREATE SEQUENCE "public"."tbl_publication_types_publication_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_publishers_publisher_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_publishers_publisher_id_seq";
CREATE SEQUENCE "public"."tbl_publishers_publisher_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_radiocarbon_calibration_radiocarbon_calibration_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_radiocarbon_calibration_radiocarbon_calibration_id_seq";
CREATE SEQUENCE "public"."tbl_radiocarbon_calibration_radiocarbon_calibration_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_rdb_codes_rdb_code_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_rdb_codes_rdb_code_id_seq";
CREATE SEQUENCE "public"."tbl_rdb_codes_rdb_code_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_rdb_rdb_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_rdb_rdb_id_seq";
CREATE SEQUENCE "public"."tbl_rdb_rdb_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_rdb_systems_rdb_system_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_rdb_systems_rdb_system_id_seq";
CREATE SEQUENCE "public"."tbl_rdb_systems_rdb_system_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_record_types_record_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_record_types_record_type_id_seq";
CREATE SEQUENCE "public"."tbl_record_types_record_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_relative_age_refs_relative_age_ref_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_relative_age_refs_relative_age_ref_id_seq";
CREATE SEQUENCE "public"."tbl_relative_age_refs_relative_age_ref_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_relative_age_types_relative_age_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_relative_age_types_relative_age_type_id_seq";
CREATE SEQUENCE "public"."tbl_relative_age_types_relative_age_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_relative_ages_relative_age_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_relative_ages_relative_age_id_seq";
CREATE SEQUENCE "public"."tbl_relative_ages_relative_age_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_relative_dates_relative_date_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_relative_dates_relative_date_id_seq";
CREATE SEQUENCE "public"."tbl_relative_dates_relative_date_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_alt_refs_sample_alt_ref_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_alt_refs_sample_alt_ref_id_seq";
CREATE SEQUENCE "public"."tbl_sample_alt_refs_sample_alt_ref_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_colours_sample_colour_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_colours_sample_colour_id_seq";
CREATE SEQUENCE "public"."tbl_sample_colours_sample_colour_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_coordinates_sample_coordinates_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_coordinates_sample_coordinates_id_seq";
CREATE SEQUENCE "public"."tbl_sample_coordinates_sample_coordinates_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_description_sample_sample_description_sample_gro_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_description_sample_sample_description_sample_gro_seq";
CREATE SEQUENCE "public"."tbl_sample_description_sample_sample_description_sample_gro_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_description_types_sample_description_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_description_types_sample_description_type_id_seq";
CREATE SEQUENCE "public"."tbl_sample_description_types_sample_description_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_descriptions_sample_description_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_descriptions_sample_description_id_seq";
CREATE SEQUENCE "public"."tbl_sample_descriptions_sample_description_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_dimensions_sample_dimension_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_dimensions_sample_dimension_id_seq";
CREATE SEQUENCE "public"."tbl_sample_dimensions_sample_dimension_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_geometry_sample_geometry_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_geometry_sample_geometry_id_seq";
CREATE SEQUENCE "public"."tbl_sample_geometry_sample_geometry_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_group_coordinates_sample_group_position_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_group_coordinates_sample_group_position_id_seq";
CREATE SEQUENCE "public"."tbl_sample_group_coordinates_sample_group_position_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_group_description__sample_group_desciption_sampl_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_group_description__sample_group_desciption_sampl_seq";
CREATE SEQUENCE "public"."tbl_sample_group_description__sample_group_desciption_sampl_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_group_description__sample_group_description_type_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_group_description__sample_group_description_type_seq";
CREATE SEQUENCE "public"."tbl_sample_group_description__sample_group_description_type_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_group_descriptions_sample_group_description_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_group_descriptions_sample_group_description_id_seq";
CREATE SEQUENCE "public"."tbl_sample_group_descriptions_sample_group_description_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_group_dimensions_sample_group_dimension_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_group_dimensions_sample_group_dimension_id_seq";
CREATE SEQUENCE "public"."tbl_sample_group_dimensions_sample_group_dimension_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_group_images_sample_group_image_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_group_images_sample_group_image_id_seq";
CREATE SEQUENCE "public"."tbl_sample_group_images_sample_group_image_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_group_notes_sample_group_note_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_group_notes_sample_group_note_id_seq";
CREATE SEQUENCE "public"."tbl_sample_group_notes_sample_group_note_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_group_references_sample_group_reference_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_group_references_sample_group_reference_id_seq";
CREATE SEQUENCE "public"."tbl_sample_group_references_sample_group_reference_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_group_sampling_contexts_sampling_context_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_group_sampling_contexts_sampling_context_id_seq";
CREATE SEQUENCE "public"."tbl_sample_group_sampling_contexts_sampling_context_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_groups_sample_group_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_groups_sample_group_id_seq";
CREATE SEQUENCE "public"."tbl_sample_groups_sample_group_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_horizons_sample_horizon_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_horizons_sample_horizon_id_seq";
CREATE SEQUENCE "public"."tbl_sample_horizons_sample_horizon_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_images_sample_image_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_images_sample_image_id_seq";
CREATE SEQUENCE "public"."tbl_sample_images_sample_image_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_location_sampling__sample_location_type_sampling_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_location_sampling__sample_location_type_sampling_seq";
CREATE SEQUENCE "public"."tbl_sample_location_sampling__sample_location_type_sampling_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_location_sampling_contex_sample_location_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_location_sampling_contex_sample_location_type_id_seq";
CREATE SEQUENCE "public"."tbl_sample_location_sampling_contex_sample_location_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_location_types_sample_location_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_location_types_sample_location_type_id_seq";
CREATE SEQUENCE "public"."tbl_sample_location_types_sample_location_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_locations_sample_location_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_locations_sample_location_id_seq";
CREATE SEQUENCE "public"."tbl_sample_locations_sample_location_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_notes_sample_note_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_notes_sample_note_id_seq";
CREATE SEQUENCE "public"."tbl_sample_notes_sample_note_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sample_types_sample_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sample_types_sample_type_id_seq";
CREATE SEQUENCE "public"."tbl_sample_types_sample_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_season_types_season_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_season_types_season_type_id_seq";
CREATE SEQUENCE "public"."tbl_season_types_season_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_seasons_season_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_seasons_season_id_seq";
CREATE SEQUENCE "public"."tbl_seasons_season_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_site_images_site_image_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_site_images_site_image_id_seq";
CREATE SEQUENCE "public"."tbl_site_images_site_image_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_site_locations_site_location_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_site_locations_site_location_id_seq";
CREATE SEQUENCE "public"."tbl_site_locations_site_location_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_site_natgridrefs_site_natgridref_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_site_natgridrefs_site_natgridref_id_seq";
CREATE SEQUENCE "public"."tbl_site_natgridrefs_site_natgridref_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_site_other_records_site_other_records_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_site_other_records_site_other_records_id_seq";
CREATE SEQUENCE "public"."tbl_site_other_records_site_other_records_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_site_preservation_status_site_preservation_status_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_site_preservation_status_site_preservation_status_id_seq";
CREATE SEQUENCE "public"."tbl_site_preservation_status_site_preservation_status_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_site_references_site_reference_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_site_references_site_reference_id_seq";
CREATE SEQUENCE "public"."tbl_site_references_site_reference_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_sites_site_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_sites_site_id_seq";
CREATE SEQUENCE "public"."tbl_sites_site_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_species_associations_species_association_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_species_associations_species_association_id_seq";
CREATE SEQUENCE "public"."tbl_species_associations_species_association_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_taxa_common_names_taxon_common_name_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_taxa_common_names_taxon_common_name_id_seq";
CREATE SEQUENCE "public"."tbl_taxa_common_names_taxon_common_name_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_taxa_images_taxa_images_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_taxa_images_taxa_images_id_seq";
CREATE SEQUENCE "public"."tbl_taxa_images_taxa_images_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_taxa_measured_attributes_measured_attribute_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_taxa_measured_attributes_measured_attribute_id_seq";
CREATE SEQUENCE "public"."tbl_taxa_measured_attributes_measured_attribute_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq";
CREATE SEQUENCE "public"."tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_taxa_seasonality_seasonality_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_taxa_seasonality_seasonality_id_seq";
CREATE SEQUENCE "public"."tbl_taxa_seasonality_seasonality_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_taxa_synonyms_synonym_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_taxa_synonyms_synonym_id_seq";
CREATE SEQUENCE "public"."tbl_taxa_synonyms_synonym_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_taxa_tree_authors_author_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_taxa_tree_authors_author_id_seq";
CREATE SEQUENCE "public"."tbl_taxa_tree_authors_author_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_taxa_tree_families_family_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_taxa_tree_families_family_id_seq";
CREATE SEQUENCE "public"."tbl_taxa_tree_families_family_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_taxa_tree_genera_genus_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_taxa_tree_genera_genus_id_seq";
CREATE SEQUENCE "public"."tbl_taxa_tree_genera_genus_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_taxa_tree_master_taxon_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_taxa_tree_master_taxon_id_seq";
CREATE SEQUENCE "public"."tbl_taxa_tree_master_taxon_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_taxa_tree_orders_order_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_taxa_tree_orders_order_id_seq";
CREATE SEQUENCE "public"."tbl_taxa_tree_orders_order_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq";
CREATE SEQUENCE "public"."tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_taxonomic_order_systems_taxonomic_order_system_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_taxonomic_order_systems_taxonomic_order_system_id_seq";
CREATE SEQUENCE "public"."tbl_taxonomic_order_systems_taxonomic_order_system_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_taxonomic_order_taxonomic_order_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_taxonomic_order_taxonomic_order_id_seq";
CREATE SEQUENCE "public"."tbl_taxonomic_order_taxonomic_order_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_taxonomy_notes_taxonomy_notes_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_taxonomy_notes_taxonomy_notes_id_seq";
CREATE SEQUENCE "public"."tbl_taxonomy_notes_taxonomy_notes_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_tephra_dates_tephra_date_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_tephra_dates_tephra_date_id_seq";
CREATE SEQUENCE "public"."tbl_tephra_dates_tephra_date_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_tephra_refs_tephra_ref_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_tephra_refs_tephra_ref_id_seq";
CREATE SEQUENCE "public"."tbl_tephra_refs_tephra_ref_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_tephras_tephra_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_tephras_tephra_id_seq";
CREATE SEQUENCE "public"."tbl_tephras_tephra_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_text_biology_biology_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_text_biology_biology_id_seq";
CREATE SEQUENCE "public"."tbl_text_biology_biology_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_text_distribution_distribution_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_text_distribution_distribution_id_seq";
CREATE SEQUENCE "public"."tbl_text_distribution_distribution_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_text_identification_keys_key_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_text_identification_keys_key_id_seq";
CREATE SEQUENCE "public"."tbl_text_identification_keys_key_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_units_unit_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_units_unit_id_seq";
CREATE SEQUENCE "public"."tbl_units_unit_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_years_types_years_type_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."tbl_years_types_years_type_id_seq";
CREATE SEQUENCE "public"."tbl_years_types_years_type_id_seq"
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Table structure for tbl_abundance_elements
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_abundance_elements";
CREATE TABLE "public"."tbl_abundance_elements" (
  "abundance_element_id" int4 NOT NULL DEFAULT nextval('tbl_abundance_elements_abundance_element_id_seq'::regclass),
  "record_type_id" int4,
  "element_name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "element_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_abundance_elements"."record_type_id" IS 'used to restrict list of available elements according to record type. enables specific use of single term for multiple proxies whilst avoiding confusion, e.g. mni insects, mni seeds';
COMMENT ON COLUMN "public"."tbl_abundance_elements"."element_name" IS 'short name for element, e.g. mni, seed, leaf';
COMMENT ON COLUMN "public"."tbl_abundance_elements"."element_description" IS 'explanation of short name, e.g. minimum number of individuals, base of seed grain, covering of leaf or flower bud';

-- ----------------------------
-- Table structure for tbl_abundance_ident_levels
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_abundance_ident_levels";
CREATE TABLE "public"."tbl_abundance_ident_levels" (
  "abundance_ident_level_id" int4 NOT NULL DEFAULT nextval('tbl_abundance_ident_levels_abundance_ident_level_id_seq'::regclass),
  "abundance_id" int4 NOT NULL,
  "identification_level_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_abundance_modifications
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_abundance_modifications";
CREATE TABLE "public"."tbl_abundance_modifications" (
  "abundance_modification_id" int4 NOT NULL DEFAULT nextval('tbl_abundance_modifications_abundance_modification_id_seq'::regclass),
  "abundance_id" int4 NOT NULL,
  "modification_type_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_abundances
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_abundances";
CREATE TABLE "public"."tbl_abundances" (
  "abundance_id" int4 NOT NULL DEFAULT nextval('tbl_abundances_abundance_id_seq'::regclass),
  "taxon_id" int4 NOT NULL,
  "analysis_entity_id" int4 NOT NULL,
  "abundance_element_id" int4,
  "abundance" int4 NOT NULL DEFAULT 0,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_abundances"."abundance_element_id" IS 'allows recording of different parts for single taxon, e.g. leaf, seed, mni etc.';
COMMENT ON COLUMN "public"."tbl_abundances"."abundance" IS 'usually count value (abundance) but can be presence (1) or catagorical or relative scale, as defined by tbl_data_types through tbl_datasets';
COMMENT ON TABLE "public"."tbl_abundances" IS '20120503pib deleted column "abundance_modification_id" as appeared superfluous with "abundance_id" in tbl_adbundance_modifications';

-- ----------------------------
-- Table structure for tbl_activity_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_activity_types";
CREATE TABLE "public"."tbl_activity_types" (
  "activity_type_id" int4 NOT NULL DEFAULT nextval('tbl_activity_types_activity_type_id_seq'::regclass),
  "activity_type" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_aggregate_datasets
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_aggregate_datasets";
CREATE TABLE "public"."tbl_aggregate_datasets" (
  "aggregate_dataset_id" int4 NOT NULL DEFAULT nextval('tbl_aggregate_datasets_aggregate_dataset_id_seq'::regclass),
  "aggregate_order_type_id" int4 NOT NULL,
  "biblio_id" int4,
  "aggregate_dataset_name" varchar(255) COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."tbl_aggregate_datasets"."aggregate_dataset_name" IS 'name of aggregated dataset';
COMMENT ON COLUMN "public"."tbl_aggregate_datasets"."description" IS 'Notes explaining the purpose of the aggregated set of analysis entities';

-- ----------------------------
-- Table structure for tbl_aggregate_order_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_aggregate_order_types";
CREATE TABLE "public"."tbl_aggregate_order_types" (
  "aggregate_order_type_id" int4 NOT NULL DEFAULT nextval('tbl_aggregate_order_types_aggregate_order_type_id_seq'::regclass),
  "aggregate_order_type" varchar(60) COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."tbl_aggregate_order_types"."aggregate_order_type" IS 'aggregate order name, e.g. site name, age, sample depth, altitude';
COMMENT ON COLUMN "public"."tbl_aggregate_order_types"."description" IS 'explanation of ordering system';
COMMENT ON TABLE "public"."tbl_aggregate_order_types" IS '20120504pib: drop this? or replace with alternative?';

-- ----------------------------
-- Table structure for tbl_aggregate_sample_ages
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_aggregate_sample_ages";
CREATE TABLE "public"."tbl_aggregate_sample_ages" (
  "aggregate_sample_age_id" int4 NOT NULL DEFAULT nextval('tbl_aggregate_sample_ages_aggregate_sample_age_id_seq'::regclass),
  "aggregate_dataset_id" int4 NOT NULL,
  "analysis_entity_age_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_aggregate_samples
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_aggregate_samples";
CREATE TABLE "public"."tbl_aggregate_samples" (
  "aggregate_sample_id" int4 NOT NULL DEFAULT nextval('tbl_aggregate_samples_aggregate_sample_id_seq'::regclass),
  "aggregate_dataset_id" int4 NOT NULL,
  "analysis_entity_id" int4 NOT NULL,
  "aggregate_sample_name" varchar(50) COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_aggregate_samples"."aggregate_sample_name" IS 'optional name for aggregated entity.';
COMMENT ON TABLE "public"."tbl_aggregate_samples" IS '20120504pib: can we drop aggregate sample name? seems excessive and unnecessary sample names can be traced.';

-- ----------------------------
-- Table structure for tbl_alt_ref_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_alt_ref_types";
CREATE TABLE "public"."tbl_alt_ref_types" (
  "alt_ref_type_id" int4 NOT NULL DEFAULT nextval('tbl_alt_ref_types_alt_ref_type_id_seq'::regclass),
  "alt_ref_type" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_analysis_entities
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_analysis_entities";
CREATE TABLE "public"."tbl_analysis_entities" (
  "analysis_entity_id" int4 NOT NULL DEFAULT nextval('tbl_analysis_entities_analysis_entity_id_seq'::regclass),
  "physical_sample_id" int4,
  "dataset_id" int4,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON TABLE "public"."tbl_analysis_entities" IS '20120503pib deleted column preparation_method_id, but may need to cater for this in datasets...
20120506pib: deleted method_id and added table for multiple methods per entity';

-- ----------------------------
-- Table structure for tbl_analysis_entity_ages
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_analysis_entity_ages";
CREATE TABLE "public"."tbl_analysis_entity_ages" (
  "analysis_entity_age_id" int4 NOT NULL DEFAULT nextval('tbl_analysis_entity_ages_analysis_entity_age_id_seq'::regclass),
  "age" numeric(20,10) NOT NULL,
  "age_older" numeric(15,5),
  "age_younger" numeric(15,5),
  "analysis_entity_id" int4,
  "chronology_id" int4,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON TABLE "public"."tbl_analysis_entity_ages" IS '20120504pib: should this be connected to physical sample instead of analysis entities? allowing multiple ages (from multiple dates) for a sample. at the moment it requires a lot of backtracing to find a sample''s age... but then again, it allows... what, exactly?';

-- ----------------------------
-- Table structure for tbl_analysis_entity_dimensions
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_analysis_entity_dimensions";
CREATE TABLE "public"."tbl_analysis_entity_dimensions" (
  "analysis_entity_dimension_id" int4 NOT NULL DEFAULT nextval('tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq'::regclass),
  "analysis_entity_id" int4 NOT NULL,
  "dimension_id" int4 NOT NULL,
  "dimension_value" numeric NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_analysis_entity_prep_methods
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_analysis_entity_prep_methods";
CREATE TABLE "public"."tbl_analysis_entity_prep_methods" (
  "analysis_entity_prep_method_id" int4 NOT NULL DEFAULT nextval('tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq'::regclass),
  "analysis_entity_id" int4 NOT NULL,
  "method_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_analysis_entity_prep_methods"."method_id" IS 'preparation methods only';
COMMENT ON TABLE "public"."tbl_analysis_entity_prep_methods" IS '20120506pib: created to cater for multiple preparation methods for analysis but maintaining simple dataset concept.';

-- ----------------------------
-- Table structure for tbl_biblio
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_biblio";
CREATE TABLE "public"."tbl_biblio" (
  "biblio_id" int4 NOT NULL DEFAULT nextval('tbl_biblio_biblio_id_seq'::regclass),
  "author" varchar COLLATE "pg_catalog"."default",
  "biblio_keyword_id" int4,
  "bugs_author" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "bugs_biblio_id" int4,
  "bugs_reference" varchar(60) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "bugs_title" varchar COLLATE "pg_catalog"."default",
  "collection_or_journal_id" int4,
  "date_updated" timestamptz(6) DEFAULT now(),
  "doi" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "edition" varchar(128) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "isbn" varchar(128) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "keywords" varchar COLLATE "pg_catalog"."default",
  "notes" text COLLATE "pg_catalog"."default",
  "number" varchar(128) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "pages" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "pdf_link" varchar COLLATE "pg_catalog"."default",
  "publication_type_id" int4,
  "publisher_id" int4,
  "title" varchar COLLATE "pg_catalog"."default",
  "volume" varchar(128) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "year" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
)
;

-- ----------------------------
-- Table structure for tbl_biblio_keywords
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_biblio_keywords";
CREATE TABLE "public"."tbl_biblio_keywords" (
  "biblio_keyword_id" int4 NOT NULL DEFAULT nextval('tbl_biblio_keywords_biblio_keyword_id_seq'::regclass),
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "keyword_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_ceramics
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_ceramics";
CREATE TABLE "public"."tbl_ceramics" (
  "ceramics_id" int4 NOT NULL DEFAULT nextval('tbl_ceramics_ceramics_id_seq'::regclass),
  "analysis_entity_id" int4 NOT NULL,
  "ceramics_measurement_id" int4 NOT NULL,
  "measurement_value" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_ceramics_measurement_lookup
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_ceramics_measurement_lookup";
CREATE TABLE "public"."tbl_ceramics_measurement_lookup" (
  "ceramics_measurement_lookup_id" int4 NOT NULL DEFAULT nextval('tbl_ceramics_measurement_look_ceramics_measurement_lookup_i_seq'::regclass),
  "ceramics_measurement_id" int4 NOT NULL,
  "value" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_ceramics_measurements
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_ceramics_measurements";
CREATE TABLE "public"."tbl_ceramics_measurements" (
  "ceramics_measurement_id" int4 NOT NULL DEFAULT nextval('tbl_ceramics_measurements_ceramics_measurement_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "method_id" int4
)
;
COMMENT ON TABLE "public"."tbl_ceramics_measurements" IS 'Type=lookup';

-- ----------------------------
-- Table structure for tbl_chron_control_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_chron_control_types";
CREATE TABLE "public"."tbl_chron_control_types" (
  "chron_control_type_id" int4 NOT NULL DEFAULT nextval('tbl_chron_control_types_chron_control_type_id_seq'::regclass),
  "chron_control_type" varchar(50) COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_chron_controls
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_chron_controls";
CREATE TABLE "public"."tbl_chron_controls" (
  "chron_control_id" int4 NOT NULL DEFAULT nextval('tbl_chron_controls_chron_control_id_seq'::regclass),
  "age" numeric(20,5),
  "age_limit_older" numeric(20,5),
  "age_limit_younger" numeric(20,5),
  "chron_control_type_id" int4,
  "chronology_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "depth_bottom" numeric(20,5),
  "depth_top" numeric(20,5),
  "notes" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_chronologies
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_chronologies";
CREATE TABLE "public"."tbl_chronologies" (
  "chronology_id" int4 NOT NULL DEFAULT nextval('tbl_chronologies_chronology_id_seq'::regclass),
  "age_bound_older" int4,
  "age_bound_younger" int4,
  "age_model" varchar(80) COLLATE "pg_catalog"."default",
  "age_type_id" int4 NOT NULL,
  "chronology_name" varchar(80) COLLATE "pg_catalog"."default",
  "contact_id" int4,
  "date_prepared" timestamp(0),
  "date_updated" timestamptz(6) DEFAULT now(),
  "is_default" bool NOT NULL DEFAULT false,
  "notes" text COLLATE "pg_catalog"."default",
  "sample_group_id" int4 NOT NULL
)
;
COMMENT ON TABLE "public"."tbl_chronologies" IS '20120504pib: note that the dropped age type recorded the type of dates (c14 etc) used in constructing the chronology... but is only one per chonology enough? can a chronology not be made up of mulitple types of age?';

-- ----------------------------
-- Table structure for tbl_collections_or_journals
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_collections_or_journals";
CREATE TABLE "public"."tbl_collections_or_journals" (
  "collection_or_journal_id" int4 NOT NULL DEFAULT nextval('tbl_collections_or_journals_collection_or_journal_id_seq'::regclass),
  "collection_or_journal_abbrev" varchar(128) COLLATE "pg_catalog"."default",
  "collection_title_or_journal_name" varchar COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now(),
  "issn" varchar(128) COLLATE "pg_catalog"."default",
  "number_of_volumes" varchar(50) COLLATE "pg_catalog"."default",
  "publisher_id" int4,
  "series_editor" varchar COLLATE "pg_catalog"."default",
  "series_title" varchar COLLATE "pg_catalog"."default",
  "volume_editor" varchar COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_colours
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_colours";
CREATE TABLE "public"."tbl_colours" (
  "colour_id" int4 NOT NULL DEFAULT nextval('tbl_colours_colour_id_seq'::regclass),
  "colour_name" varchar(30) COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "method_id" int4 NOT NULL,
  "rgb" int4
)
;

-- ----------------------------
-- Table structure for tbl_contact_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_contact_types";
CREATE TABLE "public"."tbl_contact_types" (
  "contact_type_id" int4 NOT NULL DEFAULT nextval('tbl_contact_types_contact_type_id_seq'::regclass),
  "contact_type_name" varchar(150) COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_contacts
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_contacts";
CREATE TABLE "public"."tbl_contacts" (
  "contact_id" int4 NOT NULL DEFAULT nextval('tbl_contacts_contact_id_seq'::regclass),
  "address_1" varchar(255) COLLATE "pg_catalog"."default",
  "address_2" varchar(255) COLLATE "pg_catalog"."default",
  "location_id" int4,
  "email" varchar COLLATE "pg_catalog"."default",
  "first_name" varchar(50) COLLATE "pg_catalog"."default",
  "last_name" varchar(100) COLLATE "pg_catalog"."default",
  "phone_number" varchar(50) COLLATE "pg_catalog"."default",
  "url" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_coordinate_method_dimensions
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_coordinate_method_dimensions";
CREATE TABLE "public"."tbl_coordinate_method_dimensions" (
  "coordinate_method_dimension_id" int4 NOT NULL DEFAULT nextval('tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq'::regclass),
  "dimension_id" int4 NOT NULL,
  "method_id" int4 NOT NULL,
  "limit_upper" numeric(18,10),
  "limit_lower" numeric(18,10),
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_data_type_groups
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_data_type_groups";
CREATE TABLE "public"."tbl_data_type_groups" (
  "data_type_group_id" int4 NOT NULL DEFAULT nextval('tbl_data_type_groups_data_type_group_id_seq'::regclass),
  "data_type_group_name" varchar(25) COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_data_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_data_types";
CREATE TABLE "public"."tbl_data_types" (
  "data_type_id" int4 NOT NULL DEFAULT nextval('tbl_data_types_data_type_id_seq'::regclass),
  "data_type_group_id" int4 NOT NULL,
  "data_type_name" varchar(25) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "date_updated" timestamptz(6) DEFAULT now(),
  "definition" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_dataset_contacts
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_dataset_contacts";
CREATE TABLE "public"."tbl_dataset_contacts" (
  "dataset_contact_id" int4 NOT NULL DEFAULT nextval('tbl_dataset_contacts_dataset_contact_id_seq'::regclass),
  "contact_id" int4 NOT NULL,
  "contact_type_id" int4 NOT NULL,
  "dataset_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_dataset_masters
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_dataset_masters";
CREATE TABLE "public"."tbl_dataset_masters" (
  "master_set_id" int4 NOT NULL DEFAULT nextval('tbl_dataset_masters_master_set_id_seq'::regclass),
  "contact_id" int4,
  "biblio_id" int4,
  "master_name" varchar(100) COLLATE "pg_catalog"."default",
  "master_notes" text COLLATE "pg_catalog"."default",
  "url" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_dataset_masters"."biblio_id" IS 'primary reference for master dataset if available, e.g. buckland & buckland 2006 for bugscep';
COMMENT ON COLUMN "public"."tbl_dataset_masters"."master_name" IS 'identification of master dataset, e.g. mal, bugscep, dendrolab';
COMMENT ON COLUMN "public"."tbl_dataset_masters"."master_notes" IS 'description of master dataset, its form (e.g. database, lab) and any other relevant information for tracing it.';
COMMENT ON COLUMN "public"."tbl_dataset_masters"."url" IS 'website or other url for master dataset, be it a project, lab or... other';

-- ----------------------------
-- Table structure for tbl_dataset_submission_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_dataset_submission_types";
CREATE TABLE "public"."tbl_dataset_submission_types" (
  "submission_type_id" int4 NOT NULL DEFAULT nextval('tbl_dataset_submission_types_submission_type_id_seq'::regclass),
  "submission_type" varchar(60) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_dataset_submission_types"."submission_type" IS 'descriptive name for type of submission, e.g. original submission, ingestion from another database';
COMMENT ON COLUMN "public"."tbl_dataset_submission_types"."description" IS 'explanation of submission type, explaining clearly data ingestion mechanism';

-- ----------------------------
-- Table structure for tbl_dataset_submissions
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_dataset_submissions";
CREATE TABLE "public"."tbl_dataset_submissions" (
  "dataset_submission_id" int4 NOT NULL DEFAULT nextval('tbl_dataset_submissions_dataset_submission_id_seq'::regclass),
  "dataset_id" int4 NOT NULL,
  "submission_type_id" int4 NOT NULL,
  "contact_id" int4 NOT NULL,
  "date_submitted" date NOT NULL,
  "notes" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_dataset_submissions"."notes" IS 'any details of submission not covered by submission_type information, such as name of source from which submission originates if not covered elsewhere in database, e.g. from bugscep';

-- ----------------------------
-- Table structure for tbl_datasets
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_datasets";
CREATE TABLE "public"."tbl_datasets" (
  "dataset_id" int4 NOT NULL DEFAULT nextval('tbl_datasets_dataset_id_seq'::regclass),
  "master_set_id" int4,
  "data_type_id" int4 NOT NULL,
  "method_id" int4,
  "biblio_id" int4,
  "updated_dataset_id" int4,
  "project_id" int4,
  "dataset_name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_datasets"."dataset_name" IS 'something uniquely identifying the dataset for this site. may be same as sample group name, or created adhoc if necessary, but preferably with some meaning.';

-- ----------------------------
-- Table structure for tbl_dating_labs
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_dating_labs";
CREATE TABLE "public"."tbl_dating_labs" (
  "dating_lab_id" int4 NOT NULL DEFAULT nextval('tbl_dating_labs_dating_lab_id_seq'::regclass),
  "contact_id" int4,
  "international_lab_id" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  "lab_name" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "country_id" int4,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_dating_labs"."contact_id" IS 'address details are stored in tbl_contacts';
COMMENT ON COLUMN "public"."tbl_dating_labs"."international_lab_id" IS 'international standard radiocarbon lab identifier.
from http://www.radiocarbon.org/info/labcodes.html';
COMMENT ON COLUMN "public"."tbl_dating_labs"."lab_name" IS 'international standard name of radiocarbon lab, from http://www.radiocarbon.org/info/labcodes.html';
COMMENT ON TABLE "public"."tbl_dating_labs" IS '20120504pib: reduced this table and linked to tbl_contacts for address related data';

-- ----------------------------
-- Table structure for tbl_dating_material
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_dating_material";
CREATE TABLE "public"."tbl_dating_material" (
  "dating_material_id" int4 NOT NULL DEFAULT nextval('tbl_dating_material_dating_material_id_seq'::regclass),
  "geochron_id" int4 NOT NULL,
  "taxon_id" int4,
  "material_dated" varchar COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "abundance_element_id" int4,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON TABLE "public"."tbl_dating_material" IS '20130722PIB: Added field date_updated';

-- ----------------------------
-- Table structure for tbl_dating_uncertainty
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_dating_uncertainty";
CREATE TABLE "public"."tbl_dating_uncertainty" (
  "dating_uncertainty_id" int4 NOT NULL DEFAULT nextval('tbl_dating_uncertainty_dating_uncertainty_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "uncertainty" varchar COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_dendro
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_dendro";
CREATE TABLE "public"."tbl_dendro" (
  "dendro_id" int4 NOT NULL DEFAULT nextval('tbl_dendro_dendro_id_seq'::regclass),
  "analysis_entity_id" int4 NOT NULL,
  "dendro_measurement_id" int4 NOT NULL,
  "measurement_value" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_dendro_date_notes
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_dendro_date_notes";
CREATE TABLE "public"."tbl_dendro_date_notes" (
  "dendro_date_note_id" int4 NOT NULL DEFAULT nextval('tbl_dendro_date_notes_dendro_date_note_id_seq'::regclass),
  "dendro_date_id" int4 NOT NULL,
  "note" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_dendro_dates
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_dendro_dates";
CREATE TABLE "public"."tbl_dendro_dates" (
  "dendro_date_id" int4 NOT NULL DEFAULT nextval('tbl_dendro_dates_dendro_date_id_seq'::regclass),
  "analysis_entity_id" int4 NOT NULL,
  "cal_age_younger" int4,
  "dating_uncertainty_id" int4,
  "years_type_id" int4,
  "error" int4,
  "season_or_qualifier_id" int4,
  "date_updated" timestamptz(6) DEFAULT now(),
  "cal_age_older" int4
)
;
COMMENT ON TABLE "public"."tbl_dendro_dates" IS '20130722PIB: Added field dating_uncertainty_id to cater for >< etc.
20130722PIB: prefixed fieldnames age_younger and age_older with "cal_" to conform with equivalent names in other tables';

-- ----------------------------
-- Table structure for tbl_dendro_measurement_lookup
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_dendro_measurement_lookup";
CREATE TABLE "public"."tbl_dendro_measurement_lookup" (
  "dendro_measurement_lookup_id" int4 NOT NULL DEFAULT nextval('tbl_dendro_measurement_lookup_dendro_measurement_lookup_id_seq'::regclass),
  "dendro_measurement_id" int4 NOT NULL,
  "value" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_dendro_measurements
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_dendro_measurements";
CREATE TABLE "public"."tbl_dendro_measurements" (
  "dendro_measurement_id" int4 NOT NULL DEFAULT nextval('tbl_dendro_measurements_dendro_measurement_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "method_id" int4
)
;
COMMENT ON TABLE "public"."tbl_dendro_measurements" IS 'Type=lookup';

-- ----------------------------
-- Table structure for tbl_dimensions
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_dimensions";
CREATE TABLE "public"."tbl_dimensions" (
  "dimension_id" int4 NOT NULL DEFAULT nextval('tbl_dimensions_dimension_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "dimension_abbrev" varchar(10) COLLATE "pg_catalog"."default",
  "dimension_description" text COLLATE "pg_catalog"."default",
  "dimension_name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "unit_id" int4,
  "method_group_id" int4
)
;
COMMENT ON COLUMN "public"."tbl_dimensions"."method_group_id" IS 'Limits choice of dimension by method group (e.g. size measurements, coordinate systems)';

-- ----------------------------
-- Table structure for tbl_ecocode_definitions
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_ecocode_definitions";
CREATE TABLE "public"."tbl_ecocode_definitions" (
  "ecocode_definition_id" int4 NOT NULL DEFAULT nextval('tbl_ecocode_definitions_ecocode_definition_id_seq'::regclass),
  "abbreviation" varchar(10) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "date_updated" timestamptz(6) DEFAULT now(),
  "definition" text COLLATE "pg_catalog"."default",
  "ecocode_group_id" int4 DEFAULT 0,
  "name" varchar(150) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "notes" text COLLATE "pg_catalog"."default",
  "sort_order" int2 DEFAULT 0
)
;

-- ----------------------------
-- Table structure for tbl_ecocode_groups
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_ecocode_groups";
CREATE TABLE "public"."tbl_ecocode_groups" (
  "ecocode_group_id" int4 NOT NULL DEFAULT nextval('tbl_ecocode_groups_ecocode_group_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "definition" text COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "ecocode_system_id" int4 DEFAULT 0,
  "name" varchar(150) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "abbreviation" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_ecocode_systems
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_ecocode_systems";
CREATE TABLE "public"."tbl_ecocode_systems" (
  "ecocode_system_id" int4 NOT NULL DEFAULT nextval('tbl_ecocode_systems_ecocode_system_id_seq'::regclass),
  "biblio_id" int4,
  "date_updated" timestamptz(6) DEFAULT now(),
  "definition" text COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "name" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "notes" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_ecocodes
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_ecocodes";
CREATE TABLE "public"."tbl_ecocodes" (
  "ecocode_id" int4 NOT NULL DEFAULT nextval('tbl_ecocodes_ecocode_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "ecocode_definition_id" int4 DEFAULT 0,
  "taxon_id" int4 DEFAULT 0
)
;

-- ----------------------------
-- Table structure for tbl_feature_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_feature_types";
CREATE TABLE "public"."tbl_feature_types" (
  "feature_type_id" int4 NOT NULL DEFAULT nextval('tbl_feature_types_feature_type_id_seq'::regclass),
  "feature_type_name" varchar(128) COLLATE "pg_catalog"."default",
  "feature_type_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_features
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_features";
CREATE TABLE "public"."tbl_features" (
  "feature_id" int4 NOT NULL DEFAULT nextval('tbl_features_feature_id_seq'::regclass),
  "feature_type_id" int4 NOT NULL,
  "feature_name" varchar COLLATE "pg_catalog"."default",
  "feature_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_features"."feature_name" IS 'estabilished reference name/number for the feature (note: not the sample). e.g. well 47, anl.3, c107.
remember that a sample can come from multiple features (e.g. c107 in well 47) but each feature should have a separate record.';
COMMENT ON COLUMN "public"."tbl_features"."feature_description" IS 'description of the feature. may include any field notes, lab notes or interpretation information useful for interpreting the sample data.';

-- ----------------------------
-- Table structure for tbl_geochron_refs
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_geochron_refs";
CREATE TABLE "public"."tbl_geochron_refs" (
  "geochron_ref_id" int4 NOT NULL DEFAULT nextval('tbl_geochron_refs_geochron_ref_id_seq'::regclass),
  "geochron_id" int4 NOT NULL,
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_geochron_refs"."biblio_id" IS 'reference for specific date';

-- ----------------------------
-- Table structure for tbl_geochronology
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_geochronology";
CREATE TABLE "public"."tbl_geochronology" (
  "geochron_id" int4 NOT NULL DEFAULT nextval('tbl_geochronology_geochron_id_seq'::regclass),
  "analysis_entity_id" int4 NOT NULL,
  "dating_lab_id" int4,
  "lab_number" varchar(40) COLLATE "pg_catalog"."default",
  "age" numeric(20,5),
  "error_older" numeric(20,5),
  "error_younger" numeric(20,5),
  "delta_13c" numeric(10,5),
  "notes" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now(),
  "dating_uncertainty_id" int4
)
;
COMMENT ON COLUMN "public"."tbl_geochronology"."age" IS 'radiocarbon (or other radiometric) age.';
COMMENT ON COLUMN "public"."tbl_geochronology"."error_older" IS 'plus (+) side of the measured error (set same as error_younger if standard +/- error)';
COMMENT ON COLUMN "public"."tbl_geochronology"."error_younger" IS 'minus (-) side of the measured error (set same as error_younger if standard +/- error)';
COMMENT ON COLUMN "public"."tbl_geochronology"."delta_13c" IS 'delta 13c where available for calibration correction.';
COMMENT ON COLUMN "public"."tbl_geochronology"."notes" IS 'notes specific to this date';
COMMENT ON TABLE "public"."tbl_geochronology" IS '20130722PIB: Altered field uncertainty (varchar) to dating_uncertainty_id and linked to tbl_dating_uncertainty to enable lookup of uncertainty modifiers for dates';

-- ----------------------------
-- Table structure for tbl_horizons
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_horizons";
CREATE TABLE "public"."tbl_horizons" (
  "horizon_id" int4 NOT NULL DEFAULT nextval('tbl_horizons_horizon_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "horizon_name" varchar(15) COLLATE "pg_catalog"."default" NOT NULL,
  "method_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_identification_levels
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_identification_levels";
CREATE TABLE "public"."tbl_identification_levels" (
  "identification_level_id" int4 NOT NULL DEFAULT nextval('tbl_identification_levels_identification_level_id_seq'::regclass),
  "identification_level_abbrev" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "identification_level_name" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "notes" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_image_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_image_types";
CREATE TABLE "public"."tbl_image_types" (
  "image_type_id" int4 NOT NULL DEFAULT nextval('tbl_image_types_image_type_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "image_type" varchar(40) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_imported_taxa_replacements
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_imported_taxa_replacements";
CREATE TABLE "public"."tbl_imported_taxa_replacements" (
  "imported_taxa_replacement_id" int4 NOT NULL DEFAULT nextval('tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "imported_name_replaced" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "taxon_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_keywords
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_keywords";
CREATE TABLE "public"."tbl_keywords" (
  "keyword_id" int4 NOT NULL DEFAULT nextval('tbl_keywords_keyword_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "definition" text COLLATE "pg_catalog"."default",
  "keyword" varchar COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_languages
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_languages";
CREATE TABLE "public"."tbl_languages" (
  "language_id" int4 NOT NULL DEFAULT nextval('tbl_languages_language_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "language_name_english" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "language_name_native" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
)
;

-- ----------------------------
-- Table structure for tbl_lithology
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_lithology";
CREATE TABLE "public"."tbl_lithology" (
  "lithology_id" int4 NOT NULL DEFAULT nextval('tbl_lithology_lithology_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "depth_bottom" numeric(20,5),
  "depth_top" numeric(20,5) NOT NULL,
  "description" text COLLATE "pg_catalog"."default" NOT NULL,
  "lower_boundary" varchar(255) COLLATE "pg_catalog"."default",
  "sample_group_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_location_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_location_types";
CREATE TABLE "public"."tbl_location_types" (
  "location_type_id" int4 NOT NULL DEFAULT nextval('tbl_location_types_location_type_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "location_type" varchar(40) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_locations
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_locations";
CREATE TABLE "public"."tbl_locations" (
  "location_id" int4 NOT NULL DEFAULT nextval('tbl_locations_location_id_seq'::regclass),
  "location_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "location_type_id" int4 NOT NULL,
  "default_lat_dd" numeric(18,10),
  "default_long_dd" numeric(18,10),
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_locations"."default_lat_dd" IS 'default latitude in decimal degrees for location, e.g. mid point of country. leave empty if not known.';
COMMENT ON COLUMN "public"."tbl_locations"."default_long_dd" IS 'default longitude in decimal degrees for location, e.g. mid point of country';

-- ----------------------------
-- Table structure for tbl_mcr_names
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_mcr_names";
CREATE TABLE "public"."tbl_mcr_names" (
  "taxon_id" int4 NOT NULL DEFAULT nextval('tbl_mcr_names_taxon_id_seq'::regclass),
  "comparison_notes" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "date_updated" timestamptz(6) DEFAULT now(),
  "mcr_name_trim" varchar(80) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "mcr_number" int2 DEFAULT 0,
  "mcr_species_name" varchar(200) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
)
;

-- ----------------------------
-- Table structure for tbl_mcr_summary_data
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_mcr_summary_data";
CREATE TABLE "public"."tbl_mcr_summary_data" (
  "mcr_summary_data_id" int4 NOT NULL DEFAULT nextval('tbl_mcr_summary_data_mcr_summary_data_id_seq'::regclass),
  "cog_mid_tmax" int2 DEFAULT 0,
  "cog_mid_trange" int2 DEFAULT 0,
  "date_updated" timestamptz(6) DEFAULT now(),
  "taxon_id" int4 NOT NULL,
  "tmax_hi" int2 DEFAULT 0,
  "tmax_lo" int2 DEFAULT 0,
  "tmin_hi" int2 DEFAULT 0,
  "tmin_lo" int2 DEFAULT 0,
  "trange_hi" int2 DEFAULT 0,
  "trange_lo" int2 DEFAULT 0
)
;

-- ----------------------------
-- Table structure for tbl_mcrdata_birmbeetledat
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_mcrdata_birmbeetledat";
CREATE TABLE "public"."tbl_mcrdata_birmbeetledat" (
  "mcrdata_birmbeetledat_id" int4 NOT NULL DEFAULT nextval('tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "mcr_data" text COLLATE "pg_catalog"."default",
  "mcr_row" int2 NOT NULL,
  "taxon_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_measured_value_dimensions
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_measured_value_dimensions";
CREATE TABLE "public"."tbl_measured_value_dimensions" (
  "measured_value_dimension_id" int4 NOT NULL DEFAULT nextval('tbl_measured_value_dimensions_measured_value_dimension_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "dimension_id" int4 NOT NULL,
  "dimension_value" numeric(18,10) NOT NULL,
  "measured_value_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_measured_values
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_measured_values";
CREATE TABLE "public"."tbl_measured_values" (
  "measured_value_id" int4 NOT NULL DEFAULT nextval('tbl_measured_values_measured_value_id_seq'::regclass),
  "analysis_entity_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "measured_value" numeric(20,10) NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_method_groups
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_method_groups";
CREATE TABLE "public"."tbl_method_groups" (
  "method_group_id" int4 NOT NULL DEFAULT nextval('tbl_method_groups_method_group_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default" NOT NULL,
  "group_name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_methods
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_methods";
CREATE TABLE "public"."tbl_methods" (
  "method_id" int4 NOT NULL DEFAULT nextval('tbl_methods_method_id_seq'::regclass),
  "biblio_id" int4,
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default" NOT NULL,
  "method_abbrev_or_alt_name" varchar(50) COLLATE "pg_catalog"."default",
  "method_group_id" int4 NOT NULL,
  "method_name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "record_type_id" int4,
  "unit_id" int4
)
;

-- ----------------------------
-- Table structure for tbl_modification_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_modification_types";
CREATE TABLE "public"."tbl_modification_types" (
  "modification_type_id" int4 NOT NULL DEFAULT nextval('tbl_modification_types_modification_type_id_seq'::regclass),
  "modification_type_name" varchar(128) COLLATE "pg_catalog"."default",
  "modification_type_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_modification_types"."modification_type_name" IS 'short name of modification, e.g. carbonised';
COMMENT ON COLUMN "public"."tbl_modification_types"."modification_type_description" IS 'clear explanation of modification so that name makes sense to non-domain scientists';

-- ----------------------------
-- Table structure for tbl_physical_sample_features
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_physical_sample_features";
CREATE TABLE "public"."tbl_physical_sample_features" (
  "physical_sample_feature_id" int4 NOT NULL DEFAULT nextval('tbl_physical_sample_features_physical_sample_feature_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "feature_id" int4 NOT NULL,
  "physical_sample_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_physical_samples
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_physical_samples";
CREATE TABLE "public"."tbl_physical_samples" (
  "physical_sample_id" int4 NOT NULL DEFAULT nextval('tbl_physical_samples_physical_sample_id_seq'::regclass),
  "sample_group_id" int4 NOT NULL DEFAULT 0,
  "alt_ref_type_id" int4,
  "sample_type_id" int4 NOT NULL,
  "sample_name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "date_sampled" varchar COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."tbl_physical_samples"."alt_ref_type_id" IS 'type of name represented by primary sample name, e.g. lab number, museum number etc.';
COMMENT ON COLUMN "public"."tbl_physical_samples"."sample_type_id" IS 'physical form of sample, e.g. bulk sample, kubienta subsample, core subsample, dendro core, dendro slice...';
COMMENT ON COLUMN "public"."tbl_physical_samples"."sample_name" IS 'reference number or name of sample. multiple references/names can be added as alternative references.';
COMMENT ON COLUMN "public"."tbl_physical_samples"."date_sampled" IS 'Date samples were taken. ';
COMMENT ON TABLE "public"."tbl_physical_samples" IS '20120504PIB: deleted columns XYZ and created external tbl_sample_coodinates
20120506PIB: deleted columns depth_top & depth_bottom and moved to tbl_sample_dimensions
20130416PIB: changed to date_sampled from date to varchar format to increase flexibility';

-- ----------------------------
-- Table structure for tbl_project_stages
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_project_stages";
CREATE TABLE "public"."tbl_project_stages" (
  "project_stage_id" int4 NOT NULL DEFAULT nextval('tbl_project_stage_project_stage_id_seq'::regclass),
  "stage_name" varchar COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_project_stages"."stage_name" IS 'stage of project in investigative cycle, e.g. desktop study, prospection, final excavation';
COMMENT ON COLUMN "public"."tbl_project_stages"."description" IS 'explanation of stage name term, including details of purpose and general contents';

-- ----------------------------
-- Table structure for tbl_project_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_project_types";
CREATE TABLE "public"."tbl_project_types" (
  "project_type_id" int4 NOT NULL DEFAULT nextval('tbl_project_types_project_type_id_seq'::regclass),
  "project_type_name" varchar COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_project_types"."project_type_name" IS 'descriptive name for project type, e.g. consultancy, research, teaching; also combinations consultancy/teaching';
COMMENT ON COLUMN "public"."tbl_project_types"."description" IS 'project type combinations can be used where appropriate, e.g. teaching/research';

-- ----------------------------
-- Table structure for tbl_projects
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_projects";
CREATE TABLE "public"."tbl_projects" (
  "project_id" int4 NOT NULL DEFAULT nextval('tbl_projects_project_id_seq'::regclass),
  "project_type_id" int4,
  "project_stage_id" int4,
  "project_name" varchar(150) COLLATE "pg_catalog"."default",
  "project_abbrev_name" varchar(25) COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_projects"."project_name" IS 'name of project (e.g. phil''s phd thesis, malmö ringroad vägverket)';
COMMENT ON COLUMN "public"."tbl_projects"."project_abbrev_name" IS 'optional. abbreviation of project name or acronym (e.g. vgv, swedab)';
COMMENT ON COLUMN "public"."tbl_projects"."description" IS 'brief description of project and any useful information for finding out more.';

-- ----------------------------
-- Table structure for tbl_publication_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_publication_types";
CREATE TABLE "public"."tbl_publication_types" (
  "publication_type_id" int4 NOT NULL DEFAULT nextval('tbl_publication_types_publication_type_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "publication_type" varchar(30) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_publishers
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_publishers";
CREATE TABLE "public"."tbl_publishers" (
  "publisher_id" int4 NOT NULL DEFAULT nextval('tbl_publishers_publisher_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "place_of_publishing_house" varchar COLLATE "pg_catalog"."default",
  "publisher_name" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_radiocarbon_calibration
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_radiocarbon_calibration";
CREATE TABLE "public"."tbl_radiocarbon_calibration" (
  "radiocarbon_calibration_id" int4 NOT NULL DEFAULT nextval('tbl_radiocarbon_calibration_radiocarbon_calibration_id_seq'::regclass),
  "c14_yr_bp" int4 NOT NULL,
  "cal_yr_bp" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_radiocarbon_calibration"."c14_yr_bp" IS 'mid-point of c14 age.';
COMMENT ON COLUMN "public"."tbl_radiocarbon_calibration"."cal_yr_bp" IS 'mid-point of calibrated age.';

-- ----------------------------
-- Table structure for tbl_rdb
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_rdb";
CREATE TABLE "public"."tbl_rdb" (
  "rdb_id" int4 NOT NULL DEFAULT nextval('tbl_rdb_rdb_id_seq'::regclass),
  "location_id" int4 NOT NULL,
  "rdb_code_id" int4,
  "taxon_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_rdb"."location_id" IS 'geographical source/relevance of the specific code. e.g. the international iucn classification of species in the uk.';

-- ----------------------------
-- Table structure for tbl_rdb_codes
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_rdb_codes";
CREATE TABLE "public"."tbl_rdb_codes" (
  "rdb_code_id" int4 NOT NULL DEFAULT nextval('tbl_rdb_codes_rdb_code_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "rdb_category" varchar(4) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "rdb_definition" varchar(200) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "rdb_system_id" int4 DEFAULT 0
)
;

-- ----------------------------
-- Table structure for tbl_rdb_systems
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_rdb_systems";
CREATE TABLE "public"."tbl_rdb_systems" (
  "rdb_system_id" int4 NOT NULL DEFAULT nextval('tbl_rdb_systems_rdb_system_id_seq'::regclass),
  "biblio_id" int4 NOT NULL,
  "location_id" int4 NOT NULL,
  "rdb_first_published" int2,
  "rdb_system" varchar(10) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "rdb_system_date" int4,
  "rdb_version" varchar(10) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_rdb_systems"."location_id" IS 'geaographical relevance of rdb code system, e.g. uk, international, new forest';

-- ----------------------------
-- Table structure for tbl_record_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_record_types";
CREATE TABLE "public"."tbl_record_types" (
  "record_type_id" int4 NOT NULL DEFAULT nextval('tbl_record_types_record_type_id_seq'::regclass),
  "record_type_name" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "record_type_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_record_types"."record_type_name" IS 'short name of proxy/proxies in group';
COMMENT ON COLUMN "public"."tbl_record_types"."record_type_description" IS 'detailed description of group and explanation for grouping';
COMMENT ON TABLE "public"."tbl_record_types" IS 'may also use this to group methods - e.g. phosphate analyses (whereas tbl_method_groups would store the larger group "palaeo chemical/physical" methods)';

-- ----------------------------
-- Table structure for tbl_relative_age_refs
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_relative_age_refs";
CREATE TABLE "public"."tbl_relative_age_refs" (
  "relative_age_ref_id" int4 NOT NULL DEFAULT nextval('tbl_relative_age_refs_relative_age_ref_id_seq'::regclass),
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "relative_age_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_relative_age_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_relative_age_types";
CREATE TABLE "public"."tbl_relative_age_types" (
  "relative_age_type_id" int4 NOT NULL DEFAULT nextval('tbl_relative_age_types_relative_age_type_id_seq'::regclass),
  "age_type" varchar COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_relative_age_types"."age_type" IS 'name of chronological age type, e.g. archaeological period, single calendar date, calendar age range, blytt-sernander';
COMMENT ON COLUMN "public"."tbl_relative_age_types"."description" IS 'description of chronological age type, e.g. period defined by archaeological and or geological dates representing cultural activity period, climate period defined by palaeo-vegetation records';
COMMENT ON TABLE "public"."tbl_relative_age_types" IS '20130723PIB: replaced date_updated column with new one with same name but correct data type
20140226EE: replaced date_updated column with correct time data type';

-- ----------------------------
-- Table structure for tbl_relative_ages
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_relative_ages";
CREATE TABLE "public"."tbl_relative_ages" (
  "relative_age_id" int4 NOT NULL DEFAULT nextval('tbl_relative_ages_relative_age_id_seq'::regclass),
  "relative_age_type_id" int4,
  "relative_age_name" varchar(50) COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "c14_age_older" numeric(20,5),
  "c14_age_younger" numeric(20,5),
  "cal_age_older" numeric(20,5),
  "cal_age_younger" numeric(20,5),
  "notes" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now(),
  "location_id" int4,
  "abbreviation" varchar COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."tbl_relative_ages"."relative_age_name" IS 'name of the dating period, e.g. bronze age. calendar ages should be given appropriate names such as ad 1492, 74 bc';
COMMENT ON COLUMN "public"."tbl_relative_ages"."description" IS 'a description of the (usually) period.';
COMMENT ON COLUMN "public"."tbl_relative_ages"."c14_age_older" IS 'c14 age of younger boundary of period (where relevant).';
COMMENT ON COLUMN "public"."tbl_relative_ages"."c14_age_younger" IS 'c14 age of later boundary of period (where relevant). leave blank for calendar ages.';
COMMENT ON COLUMN "public"."tbl_relative_ages"."cal_age_older" IS '(approximate) age before present (1950) of earliest boundary of period. or if calendar age then the calendar age converted to bp.';
COMMENT ON COLUMN "public"."tbl_relative_ages"."cal_age_younger" IS '(approximate) age before present (1950) of latest boundary of period. or if calendar age then the calendar age converted to bp.';
COMMENT ON COLUMN "public"."tbl_relative_ages"."notes" IS 'any further notes not included in the description, such as reliability of definition or fuzzyness of boundaries.';
COMMENT ON COLUMN "public"."tbl_relative_ages"."abbreviation" IS 'Standard abbreviated form of name if available';
COMMENT ON TABLE "public"."tbl_relative_ages" IS '20120504PIB: removed biblio_id as is replaced by tbl_relative_age_refs
20130722PIB: changed colour in model to AliceBlue to reflect degree of user addition possible (i.e. ages can be added for reference in tbl_relative_dates)';

-- ----------------------------
-- Table structure for tbl_relative_dates
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_relative_dates";
CREATE TABLE "public"."tbl_relative_dates" (
  "relative_date_id" int4 NOT NULL DEFAULT nextval('tbl_relative_dates_relative_date_id_seq'::regclass),
  "relative_age_id" int4,
  "physical_sample_id" int4 NOT NULL,
  "method_id" int4,
  "notes" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now(),
  "dating_uncertainty_id" int4
)
;
COMMENT ON COLUMN "public"."tbl_relative_dates"."method_id" IS 'dating method used to attribute sample to period or calendar date.';
COMMENT ON COLUMN "public"."tbl_relative_dates"."notes" IS 'any notes specific to the dating of this sample to this calendar or period based age';
COMMENT ON TABLE "public"."tbl_relative_dates" IS '20120504PIB: Added method_id to store dating method used to attribute sample to period or calendar date (e.g. strategraphic dating, typological)
20130722PIB: addded field dating_uncertainty_id to cater for "from", "to" and "ca." etc. especially from import of BugsCEP';

-- ----------------------------
-- Table structure for tbl_sample_alt_refs
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_alt_refs";
CREATE TABLE "public"."tbl_sample_alt_refs" (
  "sample_alt_ref_id" int4 NOT NULL DEFAULT nextval('tbl_sample_alt_refs_sample_alt_ref_id_seq'::regclass),
  "alt_ref" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "alt_ref_type_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "physical_sample_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_sample_colours
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_colours";
CREATE TABLE "public"."tbl_sample_colours" (
  "sample_colour_id" int4 NOT NULL DEFAULT nextval('tbl_sample_colours_sample_colour_id_seq'::regclass),
  "colour_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "physical_sample_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_sample_coordinates
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_coordinates";
CREATE TABLE "public"."tbl_sample_coordinates" (
  "sample_coordinate_id" int4 NOT NULL DEFAULT nextval('tbl_sample_coordinates_sample_coordinates_id_seq'::regclass),
  "physical_sample_id" int4 NOT NULL,
  "coordinate_method_dimension_id" int4 NOT NULL,
  "measurement" numeric(20,10) NOT NULL,
  "accuracy" numeric(20,10),
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_sample_coordinates"."accuracy" IS 'GPS type accuracy, e.g. 5m 10m 0.01m';

-- ----------------------------
-- Table structure for tbl_sample_description_sample_group_contexts
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_description_sample_group_contexts";
CREATE TABLE "public"."tbl_sample_description_sample_group_contexts" (
  "sample_description_sample_group_context_id" int4 NOT NULL DEFAULT nextval('tbl_sample_description_sample_sample_description_sample_gro_seq'::regclass),
  "sampling_context_id" int4,
  "sample_description_type_id" int4,
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_sample_description_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_description_types";
CREATE TABLE "public"."tbl_sample_description_types" (
  "sample_description_type_id" int4 NOT NULL DEFAULT nextval('tbl_sample_description_types_sample_description_type_id_seq'::regclass),
  "type_name" varchar(255) COLLATE "pg_catalog"."default",
  "type_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_sample_descriptions
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_descriptions";
CREATE TABLE "public"."tbl_sample_descriptions" (
  "sample_description_id" int4 NOT NULL DEFAULT nextval('tbl_sample_descriptions_sample_description_id_seq'::regclass),
  "sample_description_type_id" int4 NOT NULL,
  "physical_sample_id" int4 NOT NULL,
  "description" varchar COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_sample_dimensions
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_dimensions";
CREATE TABLE "public"."tbl_sample_dimensions" (
  "sample_dimension_id" int4 NOT NULL DEFAULT nextval('tbl_sample_dimensions_sample_dimension_id_seq'::regclass),
  "physical_sample_id" int4 NOT NULL,
  "dimension_id" int4 NOT NULL,
  "method_id" int4 NOT NULL,
  "dimension_value" numeric(20,10) NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_sample_dimensions"."dimension_id" IS 'details of the dimension measured';
COMMENT ON COLUMN "public"."tbl_sample_dimensions"."method_id" IS 'method describing dimension measurement, with link to units used';
COMMENT ON COLUMN "public"."tbl_sample_dimensions"."dimension_value" IS 'numerical value of dimension, in the units indicated in the documentation and interface.';
COMMENT ON TABLE "public"."tbl_sample_dimensions" IS '20120506pib: depth measurements for samples moved here from tbl_physical_samples';

-- ----------------------------
-- Table structure for tbl_sample_group_coordinates
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_group_coordinates";
CREATE TABLE "public"."tbl_sample_group_coordinates" (
  "sample_group_position_id" int4 NOT NULL DEFAULT nextval('tbl_sample_group_coordinates_sample_group_position_id_seq'::regclass),
  "coordinate_method_dimension_id" int4 NOT NULL,
  "sample_group_position" numeric(20,10),
  "position_accuracy" varchar(128) COLLATE "pg_catalog"."default",
  "sample_group_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_sample_group_description_type_sampling_contexts
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_group_description_type_sampling_contexts";
CREATE TABLE "public"."tbl_sample_group_description_type_sampling_contexts" (
  "sample_group_description_type_sampling_context_id" int4 NOT NULL DEFAULT nextval('tbl_sample_group_description__sample_group_desciption_sampl_seq'::regclass),
  "sampling_context_id" int4 NOT NULL,
  "sample_group_description_type_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_sample_group_description_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_group_description_types";
CREATE TABLE "public"."tbl_sample_group_description_types" (
  "sample_group_description_type_id" int4 NOT NULL DEFAULT nextval('tbl_sample_group_description__sample_group_description_type_seq'::regclass),
  "type_name" varchar(255) COLLATE "pg_catalog"."default",
  "type_description" varchar COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_sample_group_descriptions
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_group_descriptions";
CREATE TABLE "public"."tbl_sample_group_descriptions" (
  "sample_group_description_id" int4 NOT NULL DEFAULT nextval('tbl_sample_group_descriptions_sample_group_description_id_seq'::regclass),
  "group_description" varchar COLLATE "pg_catalog"."default",
  "sample_group_description_type_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "sample_group_id" int4
)
;

-- ----------------------------
-- Table structure for tbl_sample_group_dimensions
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_group_dimensions";
CREATE TABLE "public"."tbl_sample_group_dimensions" (
  "sample_group_dimension_id" int4 NOT NULL DEFAULT nextval('tbl_sample_group_dimensions_sample_group_dimension_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "dimension_id" int4 NOT NULL,
  "dimension_value" numeric(20,5) NOT NULL,
  "sample_group_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_sample_group_images
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_group_images";
CREATE TABLE "public"."tbl_sample_group_images" (
  "sample_group_image_id" int4 NOT NULL DEFAULT nextval('tbl_sample_group_images_sample_group_image_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "image_location" text COLLATE "pg_catalog"."default" NOT NULL,
  "image_name" varchar(80) COLLATE "pg_catalog"."default",
  "image_type_id" int4 NOT NULL,
  "sample_group_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_sample_group_notes
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_group_notes";
CREATE TABLE "public"."tbl_sample_group_notes" (
  "sample_group_note_id" int4 NOT NULL DEFAULT nextval('tbl_sample_group_notes_sample_group_note_id_seq'::regclass),
  "sample_group_id" int4 NOT NULL,
  "note" varchar COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_sample_group_references
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_group_references";
CREATE TABLE "public"."tbl_sample_group_references" (
  "sample_group_reference_id" int4 NOT NULL DEFAULT nextval('tbl_sample_group_references_sample_group_reference_id_seq'::regclass),
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "sample_group_id" int4 DEFAULT 0
)
;

-- ----------------------------
-- Table structure for tbl_sample_group_sampling_contexts
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_group_sampling_contexts";
CREATE TABLE "public"."tbl_sample_group_sampling_contexts" (
  "sampling_context_id" int4 NOT NULL DEFAULT nextval('tbl_sample_group_sampling_contexts_sampling_context_id_seq'::regclass),
  "sampling_context" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "sort_order" int2 NOT NULL DEFAULT 0,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_sample_group_sampling_contexts"."sampling_context" IS 'short but meaningful name defining sample group context, e.g. stratigraphic sequence, archaeological excavation';
COMMENT ON COLUMN "public"."tbl_sample_group_sampling_contexts"."description" IS 'full explanation of the grouping term';
COMMENT ON COLUMN "public"."tbl_sample_group_sampling_contexts"."sort_order" IS 'allows lists to group similar or associated group context close to each other, e.g. modern investigations together, palaeo investigations together';
COMMENT ON TABLE "public"."tbl_sample_group_sampling_contexts" IS 'Type=lookup';

-- ----------------------------
-- Table structure for tbl_sample_groups
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_groups";
CREATE TABLE "public"."tbl_sample_groups" (
  "sample_group_id" int4 NOT NULL DEFAULT nextval('tbl_sample_groups_sample_group_id_seq'::regclass),
  "site_id" int4 DEFAULT 0,
  "sampling_context_id" int4,
  "method_id" int4 NOT NULL,
  "sample_group_name" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "sample_group_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_sample_groups"."method_id" IS 'sampling method, e.g. russian auger core, pitfall traps. note different from context in that it is specific to method of sample retrieval and not type of investigation.';
COMMENT ON COLUMN "public"."tbl_sample_groups"."sample_group_name" IS 'Name which identifies the collection of samples. For ceramics, use vessel number.';

-- ----------------------------
-- Table structure for tbl_sample_horizons
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_horizons";
CREATE TABLE "public"."tbl_sample_horizons" (
  "sample_horizon_id" int4 NOT NULL DEFAULT nextval('tbl_sample_horizons_sample_horizon_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "horizon_id" int4 NOT NULL,
  "physical_sample_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_sample_images
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_images";
CREATE TABLE "public"."tbl_sample_images" (
  "sample_image_id" int4 NOT NULL DEFAULT nextval('tbl_sample_images_sample_image_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "image_location" text COLLATE "pg_catalog"."default" NOT NULL,
  "image_name" varchar(80) COLLATE "pg_catalog"."default",
  "image_type_id" int4 NOT NULL,
  "physical_sample_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_sample_location_type_sampling_contexts
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_location_type_sampling_contexts";
CREATE TABLE "public"."tbl_sample_location_type_sampling_contexts" (
  "sample_location_type_sampling_context_id" int4 NOT NULL DEFAULT nextval('tbl_sample_location_sampling__sample_location_type_sampling_seq'::regclass),
  "sampling_context_id" int4 NOT NULL,
  "sample_location_type_id" int4 NOT NULL DEFAULT nextval('tbl_sample_location_sampling_contex_sample_location_type_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_sample_location_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_location_types";
CREATE TABLE "public"."tbl_sample_location_types" (
  "sample_location_type_id" int4 NOT NULL DEFAULT nextval('tbl_sample_location_types_sample_location_type_id_seq'::regclass),
  "location_type" varchar(255) COLLATE "pg_catalog"."default",
  "location_type_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_sample_locations
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_locations";
CREATE TABLE "public"."tbl_sample_locations" (
  "sample_location_id" int4 NOT NULL DEFAULT nextval('tbl_sample_locations_sample_location_id_seq'::regclass),
  "sample_location_type_id" int4 NOT NULL,
  "physical_sample_id" int4 NOT NULL,
  "location" varchar(255) COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_sample_notes
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_notes";
CREATE TABLE "public"."tbl_sample_notes" (
  "sample_note_id" int4 NOT NULL DEFAULT nextval('tbl_sample_notes_sample_note_id_seq'::regclass),
  "physical_sample_id" int4 NOT NULL,
  "note_type" varchar COLLATE "pg_catalog"."default",
  "note" text COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_sample_notes"."note_type" IS 'origin of the note, e.g. field note, lab note';
COMMENT ON COLUMN "public"."tbl_sample_notes"."note" IS 'note contents';

-- ----------------------------
-- Table structure for tbl_sample_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sample_types";
CREATE TABLE "public"."tbl_sample_types" (
  "sample_type_id" int4 NOT NULL DEFAULT nextval('tbl_sample_types_sample_type_id_seq'::regclass),
  "type_name" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_season_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_season_types";
CREATE TABLE "public"."tbl_season_types" (
  "season_type_id" int4 NOT NULL DEFAULT nextval('tbl_season_types_season_type_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "season_type" varchar(30) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_seasons
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_seasons";
CREATE TABLE "public"."tbl_seasons" (
  "season_id" int4 NOT NULL DEFAULT nextval('tbl_seasons_season_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "season_name" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "season_type" varchar(30) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "season_type_id" int4,
  "sort_order" int2 DEFAULT 0
)
;

-- ----------------------------
-- Table structure for tbl_site_images
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_site_images";
CREATE TABLE "public"."tbl_site_images" (
  "site_image_id" int4 NOT NULL DEFAULT nextval('tbl_site_images_site_image_id_seq'::regclass),
  "contact_id" int4,
  "credit" varchar(100) COLLATE "pg_catalog"."default",
  "date_taken" date,
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "image_location" text COLLATE "pg_catalog"."default" NOT NULL,
  "image_name" varchar(80) COLLATE "pg_catalog"."default",
  "image_type_id" int4 NOT NULL,
  "site_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_site_locations
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_site_locations";
CREATE TABLE "public"."tbl_site_locations" (
  "site_location_id" int4 NOT NULL DEFAULT nextval('tbl_site_locations_site_location_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "location_id" int4 NOT NULL,
  "site_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_site_natgridrefs
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_site_natgridrefs";
CREATE TABLE "public"."tbl_site_natgridrefs" (
  "site_natgridref_id" int4 NOT NULL DEFAULT nextval('tbl_site_natgridrefs_site_natgridref_id_seq'::regclass),
  "site_id" int4 NOT NULL,
  "method_id" int4 NOT NULL,
  "natgridref" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_site_natgridrefs"."method_id" IS 'points to coordinate system.';
COMMENT ON TABLE "public"."tbl_site_natgridrefs" IS '20120507pib: removed tbl_national_grids and trasfered storage of coordinate systems to tbl_methods';

-- ----------------------------
-- Table structure for tbl_site_other_records
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_site_other_records";
CREATE TABLE "public"."tbl_site_other_records" (
  "site_other_records_id" int4 NOT NULL DEFAULT nextval('tbl_site_other_records_site_other_records_id_seq'::regclass),
  "site_id" int4,
  "biblio_id" int4,
  "record_type_id" int4,
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_site_other_records"."biblio_id" IS 'reference to publication containing data';
COMMENT ON COLUMN "public"."tbl_site_other_records"."record_type_id" IS 'reference to type of data (proxy)';

-- ----------------------------
-- Table structure for tbl_site_preservation_status
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_site_preservation_status";
CREATE TABLE "public"."tbl_site_preservation_status" (
  "site_preservation_status_id" int4 NOT NULL DEFAULT nextval('tbl_site_preservation_status_site_preservation_status_id_seq'::regclass),
  "site_id" int4,
  "preservation_status_or_threat" varchar COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "assessment_type" varchar COLLATE "pg_catalog"."default",
  "assessment_author_contact_id" int4,
  "date_updated" timestamptz(6) DEFAULT now(),
  "Evaluation_date" date
)
;
COMMENT ON COLUMN "public"."tbl_site_preservation_status"."site_id" IS 'allows multiple preservation/threat records per site';
COMMENT ON COLUMN "public"."tbl_site_preservation_status"."preservation_status_or_threat" IS 'descriptive name for:
preservation status, e.g. (e.g. lost, damaged, threatened) or
main reason for potential or real risk to site (e.g. hydroelectric, oil exploitation, mining, forestry, climate change, erosion)';
COMMENT ON COLUMN "public"."tbl_site_preservation_status"."description" IS 'brief description of site preservation status or threat to site preservation. include data here that does not fit in the other fields (for now - we may expand these features later if demand exists)';
COMMENT ON COLUMN "public"."tbl_site_preservation_status"."assessment_type" IS 'type of assessment giving information on preservation status and threat, e.g. unesco report, archaeological survey';
COMMENT ON COLUMN "public"."tbl_site_preservation_status"."assessment_author_contact_id" IS 'person or authority in tbl_contacts responsible for the assessment of preservation status and threat';
COMMENT ON COLUMN "public"."tbl_site_preservation_status"."Evaluation_date" IS 'Date of assessment, either formal or informal';

-- ----------------------------
-- Table structure for tbl_site_references
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_site_references";
CREATE TABLE "public"."tbl_site_references" (
  "site_reference_id" int4 NOT NULL DEFAULT nextval('tbl_site_references_site_reference_id_seq'::regclass),
  "site_id" int4 DEFAULT 0,
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_sites
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_sites";
CREATE TABLE "public"."tbl_sites" (
  "site_id" int4 NOT NULL DEFAULT nextval('tbl_sites_site_id_seq'::regclass),
  "altitude" numeric(18,10),
  "latitude_dd" numeric(18,10),
  "longitude_dd" numeric(18,10),
  "national_site_identifier" varchar(255) COLLATE "pg_catalog"."default",
  "site_description" text COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "site_name" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "site_preservation_status_id" int4,
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_species_association_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_species_association_types";
CREATE TABLE "public"."tbl_species_association_types" (
  "association_type_id" int4 NOT NULL DEFAULT nextval('tbl_association_types_association_type_id_seq'::regclass),
  "association_type_name" varchar(255) COLLATE "pg_catalog"."default",
  "association_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_species_associations
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_species_associations";
CREATE TABLE "public"."tbl_species_associations" (
  "species_association_id" int4 NOT NULL DEFAULT nextval('tbl_species_associations_species_association_id_seq'::regclass),
  "associated_taxon_id" int4 NOT NULL,
  "biblio_id" int4,
  "date_updated" timestamptz(6) DEFAULT now(),
  "taxon_id" int4 NOT NULL,
  "association_type_id" int4,
  "referencing_type" text COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."tbl_species_associations"."associated_taxon_id" IS 'Taxon with which the primary taxon (taxon_id) is associated. ';
COMMENT ON COLUMN "public"."tbl_species_associations"."biblio_id" IS 'Reference where relationship between taxa is described or mentioned';
COMMENT ON COLUMN "public"."tbl_species_associations"."taxon_id" IS 'Primary taxon in relationship, i.e. this taxon has x relationship with the associated taxon';
COMMENT ON COLUMN "public"."tbl_species_associations"."association_type_id" IS 'Type of association between primary taxon (taxon_id) and associated taxon. Note that the direction of the association is important in most cases (e.g. x predates on y)';

-- ----------------------------
-- Table structure for tbl_taxa_common_names
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_taxa_common_names";
CREATE TABLE "public"."tbl_taxa_common_names" (
  "taxon_common_name_id" int4 NOT NULL DEFAULT nextval('tbl_taxa_common_names_taxon_common_name_id_seq'::regclass),
  "common_name" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "date_updated" timestamptz(6) DEFAULT now(),
  "language_id" int4 DEFAULT 0,
  "taxon_id" int4 DEFAULT 0
)
;

-- ----------------------------
-- Table structure for tbl_taxa_images
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_taxa_images";
CREATE TABLE "public"."tbl_taxa_images" (
  "taxa_images_id" int4 NOT NULL DEFAULT nextval('tbl_taxa_images_taxa_images_id_seq'::regclass),
  "image_name" varchar COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "image_location" text COLLATE "pg_catalog"."default",
  "image_type_id" int4,
  "taxon_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON TABLE "public"."tbl_taxa_images" IS '20140226EE: changed the data type for date_updated';

-- ----------------------------
-- Table structure for tbl_taxa_measured_attributes
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_taxa_measured_attributes";
CREATE TABLE "public"."tbl_taxa_measured_attributes" (
  "measured_attribute_id" int4 NOT NULL DEFAULT nextval('tbl_taxa_measured_attributes_measured_attribute_id_seq'::regclass),
  "attribute_measure" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "attribute_type" varchar(25) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "attribute_units" varchar(10) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "data" numeric(18,10) DEFAULT 0,
  "date_updated" timestamptz(6) DEFAULT now(),
  "taxon_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_taxa_reference_specimens
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_taxa_reference_specimens";
CREATE TABLE "public"."tbl_taxa_reference_specimens" (
  "taxa_reference_specimen_id" int4 NOT NULL DEFAULT nextval('tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq'::regclass),
  "taxon_id" int4 NOT NULL,
  "contact_id" int4 NOT NULL,
  "notes" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON TABLE "public"."tbl_taxa_reference_specimens" IS '20140226EE: changed date_updated to correct data type';

-- ----------------------------
-- Table structure for tbl_taxa_seasonality
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_taxa_seasonality";
CREATE TABLE "public"."tbl_taxa_seasonality" (
  "seasonality_id" int4 NOT NULL DEFAULT nextval('tbl_taxa_seasonality_seasonality_id_seq'::regclass),
  "activity_type_id" int4 NOT NULL,
  "season_id" int4 DEFAULT 0,
  "taxon_id" int4 NOT NULL,
  "location_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."tbl_taxa_seasonality"."location_id" IS 'geographical relevance of seasonality data';

-- ----------------------------
-- Table structure for tbl_taxa_synonyms
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_taxa_synonyms";
CREATE TABLE "public"."tbl_taxa_synonyms" (
  "synonym_id" int4 NOT NULL DEFAULT nextval('tbl_taxa_synonyms_synonym_id_seq'::regclass),
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "family_id" int4,
  "genus_id" int4,
  "notes" text COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "taxon_id" int4,
  "author_id" int4,
  "synonym" varchar(255) COLLATE "pg_catalog"."default",
  "reference_type" varchar COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."tbl_taxa_synonyms"."notes" IS 'Any information useful to the history or usage of the synonym.';
COMMENT ON COLUMN "public"."tbl_taxa_synonyms"."synonym" IS 'Synonym at level defined by id level. I.e. if synonym is at genus level, then only the genus synonym is included here. Another synonym record is used for the species level synonym for the same taxon only if the name is different to that used in the master list.';
COMMENT ON COLUMN "public"."tbl_taxa_synonyms"."reference_type" IS 'Form of information relating to the synonym in the given bibliographic link, e.g. by use, definition, incorrect usage.';

-- ----------------------------
-- Table structure for tbl_taxa_tree_authors
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_taxa_tree_authors";
CREATE TABLE "public"."tbl_taxa_tree_authors" (
  "author_id" int4 NOT NULL DEFAULT nextval('tbl_taxa_tree_authors_author_id_seq'::regclass),
  "author_name" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for tbl_taxa_tree_families
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_taxa_tree_families";
CREATE TABLE "public"."tbl_taxa_tree_families" (
  "family_id" int4 NOT NULL DEFAULT nextval('tbl_taxa_tree_families_family_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "family_name" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "order_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_taxa_tree_genera
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_taxa_tree_genera";
CREATE TABLE "public"."tbl_taxa_tree_genera" (
  "genus_id" int4 NOT NULL DEFAULT nextval('tbl_taxa_tree_genera_genus_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "family_id" int4,
  "genus_name" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
)
;

-- ----------------------------
-- Table structure for tbl_taxa_tree_master
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_taxa_tree_master";
CREATE TABLE "public"."tbl_taxa_tree_master" (
  "taxon_id" int4 NOT NULL DEFAULT nextval('tbl_taxa_tree_master_taxon_id_seq'::regclass),
  "author_id" int4,
  "date_updated" timestamptz(6) DEFAULT now(),
  "genus_id" int4,
  "species" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
)
;
COMMENT ON TABLE "public"."tbl_taxa_tree_master" IS '20130416PIB: removed default=0 for author_id and genus_id as was incorrect';

-- ----------------------------
-- Table structure for tbl_taxa_tree_orders
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_taxa_tree_orders";
CREATE TABLE "public"."tbl_taxa_tree_orders" (
  "order_id" int4 NOT NULL DEFAULT nextval('tbl_taxa_tree_orders_order_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "order_name" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "record_type_id" int4,
  "sort_order" int4
)
;

-- ----------------------------
-- Table structure for tbl_taxonomic_order
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_taxonomic_order";
CREATE TABLE "public"."tbl_taxonomic_order" (
  "taxonomic_order_id" int4 NOT NULL DEFAULT nextval('tbl_taxonomic_order_taxonomic_order_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "taxon_id" int4 DEFAULT 0,
  "taxonomic_code" numeric(18,10) DEFAULT 0,
  "taxonomic_order_system_id" int4 DEFAULT 0
)
;

-- ----------------------------
-- Table structure for tbl_taxonomic_order_biblio
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_taxonomic_order_biblio";
CREATE TABLE "public"."tbl_taxonomic_order_biblio" (
  "taxonomic_order_biblio_id" int4 NOT NULL DEFAULT nextval('tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq'::regclass),
  "biblio_id" int4 DEFAULT 0,
  "date_updated" timestamptz(6) DEFAULT now(),
  "taxonomic_order_system_id" int4 DEFAULT 0
)
;

-- ----------------------------
-- Table structure for tbl_taxonomic_order_systems
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_taxonomic_order_systems";
CREATE TABLE "public"."tbl_taxonomic_order_systems" (
  "taxonomic_order_system_id" int4 NOT NULL DEFAULT nextval('tbl_taxonomic_order_systems_taxonomic_order_system_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "system_description" text COLLATE "pg_catalog"."default",
  "system_name" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
)
;

-- ----------------------------
-- Table structure for tbl_taxonomy_notes
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_taxonomy_notes";
CREATE TABLE "public"."tbl_taxonomy_notes" (
  "taxonomy_notes_id" int4 NOT NULL DEFAULT nextval('tbl_taxonomy_notes_taxonomy_notes_id_seq'::regclass),
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "taxon_id" int4 NOT NULL,
  "taxonomy_notes" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_tephra_dates
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_tephra_dates";
CREATE TABLE "public"."tbl_tephra_dates" (
  "tephra_date_id" int4 NOT NULL DEFAULT nextval('tbl_tephra_dates_tephra_date_id_seq'::regclass),
  "analysis_entity_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "notes" text COLLATE "pg_catalog"."default",
  "tephra_id" int4 NOT NULL,
  "dating_uncertainty_id" int4
)
;
COMMENT ON TABLE "public"."tbl_tephra_dates" IS '20130722PIB: Added field dating_uncertainty_id to cater for >< etc.';

-- ----------------------------
-- Table structure for tbl_tephra_refs
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_tephra_refs";
CREATE TABLE "public"."tbl_tephra_refs" (
  "tephra_ref_id" int4 NOT NULL DEFAULT nextval('tbl_tephra_refs_tephra_ref_id_seq'::regclass),
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "tephra_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_tephras
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_tephras";
CREATE TABLE "public"."tbl_tephras" (
  "tephra_id" int4 NOT NULL DEFAULT nextval('tbl_tephras_tephra_id_seq'::regclass),
  "c14_age" numeric(20,5),
  "c14_age_older" numeric(20,5),
  "c14_age_younger" numeric(20,5),
  "cal_age" numeric(20,5),
  "cal_age_older" numeric(20,5),
  "cal_age_younger" numeric(20,5),
  "date_updated" timestamptz(6) DEFAULT now(),
  "notes" text COLLATE "pg_catalog"."default",
  "tephra_name" varchar(80) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for tbl_text_biology
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_text_biology";
CREATE TABLE "public"."tbl_text_biology" (
  "biology_id" int4 NOT NULL DEFAULT nextval('tbl_text_biology_biology_id_seq'::regclass),
  "biblio_id" int4 NOT NULL,
  "biology_text" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now(),
  "taxon_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_text_distribution
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_text_distribution";
CREATE TABLE "public"."tbl_text_distribution" (
  "distribution_id" int4 NOT NULL DEFAULT nextval('tbl_text_distribution_distribution_id_seq'::regclass),
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "distribution_text" text COLLATE "pg_catalog"."default",
  "taxon_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_text_identification_keys
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_text_identification_keys";
CREATE TABLE "public"."tbl_text_identification_keys" (
  "key_id" int4 NOT NULL DEFAULT nextval('tbl_text_identification_keys_key_id_seq'::regclass),
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamptz(6) DEFAULT now(),
  "key_text" text COLLATE "pg_catalog"."default",
  "taxon_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_units
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_units";
CREATE TABLE "public"."tbl_units" (
  "unit_id" int4 NOT NULL DEFAULT nextval('tbl_units_unit_id_seq'::regclass),
  "date_updated" timestamptz(6) DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "unit_abbrev" varchar(15) COLLATE "pg_catalog"."default",
  "unit_name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_updates_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_updates_log";
CREATE TABLE "public"."tbl_updates_log" (
  "updates_log_id" int4 NOT NULL,
  "table_name" varchar(150) COLLATE "pg_catalog"."default" NOT NULL,
  "last_updated" date NOT NULL
)
;

-- ----------------------------
-- Table structure for tbl_years_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."tbl_years_types";
CREATE TABLE "public"."tbl_years_types" (
  "years_type_id" int4 NOT NULL DEFAULT nextval('tbl_years_types_years_type_id_seq'::regclass),
  "name" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamptz(6) DEFAULT now()
)
;

-- ----------------------------
-- Function structure for create_sample_position_view
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."create_sample_position_view"();
CREATE OR REPLACE FUNCTION "public"."create_sample_position_view"()
  RETURNS "pg_catalog"."void" AS $BODY$
declare
	methods record;
	pos_cols text;
	sub_select_clause text := '';
	select_clause text := '';
	point_clause varchar;
	normalized_method_name varchar := '';
	transform_string varchar;
begin

	for methods in (select *
			from tbl_methods m
			where m.method_group_id = 17) loop

	normalized_method_name := replace(methods.method_name, ' ', '_');
	normalized_method_name := replace(normalized_method_name, '.', '_');
	normalized_method_name := replace(normalized_method_name, '(', '_');
	normalized_method_name := replace(normalized_method_name, ')', '_');

	transform_string := get_transform_string(normalized_method_name);
	if transform_string = '-1' then
		continue;
	end if;

	if select_clause != '' then
		select_clause := select_clause || ',';
	end if;

	select_clause := select_clause || ' '
		|| transform_string
		|| 'as "' || methods.method_name || '"';

	sub_select_clause := sub_select_clause || ' ' ||
	  'left join (select x.measurement as x, y.measurement as y, sc.physical_sample_id as sample
		from
		tbl_sample_coordinates sc
		join tbl_coordinate_method_dimensions cmd
		on cmd.coordinate_method_dimension_id = sc.coordinate_method_dimension_id
		join
		(select
		sc.physical_sample_id as id,
		sc.measurement as measurement,
		cmd.method_id as method_id
		from tbl_sample_coordinates sc
		join tbl_coordinate_method_dimensions cmd
		on sc.coordinate_method_dimension_id = cmd.coordinate_method_dimension_id
		join tbl_dimensions d
		on d.dimension_id = cmd.dimension_id
		where d.dimension_name like ''Y%'') as y
		on y.id = sc.physical_sample_id
		and y.method_id = cmd.method_id

		join
		(select
		sc.physical_sample_id as id,
		sc.measurement as measurement,
		cmd.method_id as method_id
		from tbl_sample_coordinates sc
		join tbl_coordinate_method_dimensions cmd
		on sc.coordinate_method_dimension_id = cmd.coordinate_method_dimension_id
		join tbl_dimensions d
		on d.dimension_id = cmd.dimension_id
		where d.dimension_name like ''X%'') as x
		on x.id = sc.physical_sample_id
		and x.method_id = cmd.method_id

		where cmd.method_id = ' || methods.method_id ||
		') as ' || normalized_method_name ||
		' on ' || normalized_method_name || '.sample = sc.physical_sample_id';

	end loop;
	select_clause :=
		'select sc.physical_sample_id, '
		||select_clause || ' from tbl_sample_coordinates sc '
		|| sub_select_clause;
	raise info '%', select_clause;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for get_transform_string
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."get_transform_string"("method_name" varchar, "target_srid" int4);
CREATE OR REPLACE FUNCTION "public"."get_transform_string"("method_name" varchar, "target_srid" int4=4326)
  RETURNS "pg_catalog"."text" AS $BODY$
declare
   srid		integer := -1;
   n_adj	integer := 0;
   e_adj	integer := 0;
   result_string text := '';
begin
   case
	when method_name = 'WGS84_UTM_zone_32' then
	  srid := 32632;
	when method_name = 'EPSG:4326' then
	  srid := 4326;
	when method_name = 'UTM_U32_euref89' then
	  srid := 4647;
	when method_name = 'Swedish_RT90[2.5_gon_V]' then
	  srid := 3021;
	when method_name = 'RT90_5_gon_V' then
	  srid := 3020;
	when method_name = 'SWEREF_99_TM_(Swedish)' then
	  srid := 3006;
	when method_name = 'Truncated_RT90_5_gon_V_(6M,_1M_adjustment)' then
	  srid := 3020;
	  n_adj := 6000000;
	  e_adj := 1000000;
	when method_name = 'WGS84_UTM_zone_33N' then
	  srid := 32633;
	else
	  raise warning 'no matching coordinate method id found for method %', method_name;
	  return '-1';
   end case;

	result_string :=
		'st_transform(st_setsrid(st_point('
		|| method_name || '.y + ' || n_adj || ','
		|| method_name || '.x + ' || e_adj
		|| '), '
		|| srid
		|| '), '
		|| target_srid
		|| ')';
	return result_string;


end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for requiredtablestructurechanges
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."requiredtablestructurechanges"();
CREATE OR REPLACE FUNCTION "public"."requiredtablestructurechanges"()
  RETURNS "pg_catalog"."void" AS $BODY$
BEGIN
	ALTER TABLE tbl_bugs_tsite ALTER COLUMN "Country" TYPE character varying(255);
	Perform BugsTransferLog('tbl_bugs_tsite', 'U', 'alter table, alter column "Country" type character varying(255)');

	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tspeciesassociations',
		col_name :=  'CODE');
	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tspeciesassociations',
		col_name :=  'AssociatedSpeciesCODE');
	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tecodefbugs',
		col_name :=  'SortOrder',
		numeric_type := 'smallint');
	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tecobugs',
		col_name :=  'CODE');
	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tecokoch',
		col_name :=  'CODE');
	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tseasonactiveadult',
		col_name :=  'CODE');
	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tperiods',
		col_name :=  'Begin');
	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tperiods',
		col_name :=  'End');
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for smallbiblioupdates
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."smallbiblioupdates"();
CREATE OR REPLACE FUNCTION "public"."smallbiblioupdates"()
  RETURNS "pg_catalog"."void" AS $BODY$
DECLARE
	cnt_Lott2010 integer := -1;
BEGIN
	select count(*) from tbl_bugs_tbiblio
		where "REFERENCE" like 'Lott 2010%'
		into cnt_Lott2010;
	if cnt_Lott2010 = 1 then
		-- small fix to handle the current state of
		-- bugs, this should be ineffective after
		-- fixes in original data.
		update tbl_bugs_tbiblio
		set "REFERENCE" = 'Lott 2010'
		where "REFERENCE" = 'Lott 2010a';
	end if;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for syncsequences
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."syncsequences"();
CREATE OR REPLACE FUNCTION "public"."syncsequences"()
  RETURNS "pg_catalog"."void" AS $BODY$
DECLARE
	sql record;
BEGIN
	FOR sql in SELECT 'SELECT SETVAL(' ||
				quote_literal(quote_ident(PGT.schemaname)||
				'.'||quote_ident(S.relname))||
				', MAX(' ||quote_ident(C.attname)||
				') ) FROM ' ||
				quote_ident(PGT.schemaname)|| '.'||quote_ident(T.relname)|| ';' as fix_query
			FROM pg_class AS S, pg_depend AS D, pg_class AS T, pg_attribute AS C, pg_tables AS PGT
			WHERE S.relkind = 'S'
			    AND S.oid = D.objid
			    AND D.refobjid = T.oid
			    AND D.refobjid = C.attrelid
			    AND D.refobjsubid = C.attnum
			    AND T.relname = PGT.tablename
			ORDER BY S.relname LOOP
		EXECUTE sql.fix_query;
	END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- View structure for view_taxa_tree
-- ----------------------------
DROP VIEW IF EXISTS "public"."view_taxa_tree";
CREATE VIEW "public"."view_taxa_tree" AS  SELECT tbl_taxa_tree_authors.author_name,
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
  WHERE tbl_taxa_tree_master.genus_id = tbl_taxa_tree_genera.genus_id AND tbl_taxa_tree_genera.family_id = tbl_taxa_tree_families.family_id AND tbl_taxa_tree_families.order_id = tbl_taxa_tree_orders.order_id AND tbl_taxa_tree_authors.author_id = tbl_taxa_tree_master.author_id;
COMMENT ON VIEW "public"."view_taxa_tree" IS 'Used to view the entire taxanomic tree in one go.';

-- ----------------------------
-- View structure for view_taxa_tree_select
-- ----------------------------
DROP VIEW IF EXISTS "public"."view_taxa_tree_select";
CREATE VIEW "public"."view_taxa_tree_select" AS  SELECT a.author_name AS author,
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

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_abundance_elements_abundance_element_id_seq"
OWNED BY "public"."tbl_abundance_elements"."abundance_element_id";
SELECT setval('"public"."tbl_abundance_elements_abundance_element_id_seq"', 49, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_abundance_ident_levels_abundance_ident_level_id_seq"
OWNED BY "public"."tbl_abundance_ident_levels"."abundance_ident_level_id";
SELECT setval('"public"."tbl_abundance_ident_levels_abundance_ident_level_id_seq"', 495, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_abundance_modifications_abundance_modification_id_seq"
OWNED BY "public"."tbl_abundance_modifications"."abundance_modification_id";
SELECT setval('"public"."tbl_abundance_modifications_abundance_modification_id_seq"', 7916, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_abundances_abundance_id_seq"
OWNED BY "public"."tbl_abundances"."abundance_id";
SELECT setval('"public"."tbl_abundances_abundance_id_seq"', 499086, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_activity_types_activity_type_id_seq"
OWNED BY "public"."tbl_activity_types"."activity_type_id";
SELECT setval('"public"."tbl_activity_types_activity_type_id_seq"', 10, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_aggregate_datasets_aggregate_dataset_id_seq"
OWNED BY "public"."tbl_aggregate_datasets"."aggregate_dataset_id";
SELECT setval('"public"."tbl_aggregate_datasets_aggregate_dataset_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_aggregate_order_types_aggregate_order_type_id_seq"
OWNED BY "public"."tbl_aggregate_order_types"."aggregate_order_type_id";
SELECT setval('"public"."tbl_aggregate_order_types_aggregate_order_type_id_seq"', 8, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_aggregate_sample_ages_aggregate_sample_age_id_seq"
OWNED BY "public"."tbl_aggregate_sample_ages"."aggregate_sample_age_id";
SELECT setval('"public"."tbl_aggregate_sample_ages_aggregate_sample_age_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_aggregate_samples_aggregate_sample_id_seq"
OWNED BY "public"."tbl_aggregate_samples"."aggregate_sample_id";
SELECT setval('"public"."tbl_aggregate_samples_aggregate_sample_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_alt_ref_types_alt_ref_type_id_seq"
OWNED BY "public"."tbl_alt_ref_types"."alt_ref_type_id";
SELECT setval('"public"."tbl_alt_ref_types_alt_ref_type_id_seq"', 8, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_analysis_entities_analysis_entity_id_seq"
OWNED BY "public"."tbl_analysis_entities"."analysis_entity_id";
SELECT setval('"public"."tbl_analysis_entities_analysis_entity_id_seq"', 119879, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_analysis_entity_ages_analysis_entity_age_id_seq"
OWNED BY "public"."tbl_analysis_entity_ages"."analysis_entity_age_id";
SELECT setval('"public"."tbl_analysis_entity_ages_analysis_entity_age_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq"
OWNED BY "public"."tbl_analysis_entity_dimensions"."analysis_entity_dimension_id";
SELECT setval('"public"."tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq"
OWNED BY "public"."tbl_analysis_entity_prep_methods"."analysis_entity_prep_method_id";
SELECT setval('"public"."tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq"', 35322, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_association_types_association_type_id_seq"
OWNED BY "public"."tbl_species_association_types"."association_type_id";
SELECT setval('"public"."tbl_association_types_association_type_id_seq"', 95, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_biblio_biblio_id_seq"
OWNED BY "public"."tbl_biblio"."biblio_id";
SELECT setval('"public"."tbl_biblio_biblio_id_seq"', 5575, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_biblio_keywords_biblio_keyword_id_seq"
OWNED BY "public"."tbl_biblio_keywords"."biblio_keyword_id";
SELECT setval('"public"."tbl_biblio_keywords_biblio_keyword_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_ceramics_ceramics_id_seq"
OWNED BY "public"."tbl_ceramics"."ceramics_id";
SELECT setval('"public"."tbl_ceramics_ceramics_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_ceramics_measurement_look_ceramics_measurement_lookup_i_seq"
OWNED BY "public"."tbl_ceramics_measurement_lookup"."ceramics_measurement_lookup_id";
SELECT setval('"public"."tbl_ceramics_measurement_look_ceramics_measurement_lookup_i_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_ceramics_measurements_ceramics_measurement_id_seq"
OWNED BY "public"."tbl_ceramics_measurements"."ceramics_measurement_id";
SELECT setval('"public"."tbl_ceramics_measurements_ceramics_measurement_id_seq"', 26, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_chron_control_types_chron_control_type_id_seq"
OWNED BY "public"."tbl_chron_control_types"."chron_control_type_id";
SELECT setval('"public"."tbl_chron_control_types_chron_control_type_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_chron_controls_chron_control_id_seq"
OWNED BY "public"."tbl_chron_controls"."chron_control_id";
SELECT setval('"public"."tbl_chron_controls_chron_control_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_chronologies_chronology_id_seq"
OWNED BY "public"."tbl_chronologies"."chronology_id";
SELECT setval('"public"."tbl_chronologies_chronology_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_collections_or_journals_collection_or_journal_id_seq"
OWNED BY "public"."tbl_collections_or_journals"."collection_or_journal_id";
SELECT setval('"public"."tbl_collections_or_journals_collection_or_journal_id_seq"', 2241, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_colours_colour_id_seq"
OWNED BY "public"."tbl_colours"."colour_id";
SELECT setval('"public"."tbl_colours_colour_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_contact_types_contact_type_id_seq"
OWNED BY "public"."tbl_contact_types"."contact_type_id";
SELECT setval('"public"."tbl_contact_types_contact_type_id_seq"', 8, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_contacts_contact_id_seq"
OWNED BY "public"."tbl_contacts"."contact_id";
SELECT setval('"public"."tbl_contacts_contact_id_seq"', 1, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq"
OWNED BY "public"."tbl_coordinate_method_dimensions"."coordinate_method_dimension_id";
SELECT setval('"public"."tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq"', 32, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_data_type_groups_data_type_group_id_seq"
OWNED BY "public"."tbl_data_type_groups"."data_type_group_id";
SELECT setval('"public"."tbl_data_type_groups_data_type_group_id_seq"', 8, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_data_types_data_type_id_seq"
OWNED BY "public"."tbl_data_types"."data_type_id";
SELECT setval('"public"."tbl_data_types_data_type_id_seq"', 20, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_dataset_contacts_dataset_contact_id_seq"
OWNED BY "public"."tbl_dataset_contacts"."dataset_contact_id";
SELECT setval('"public"."tbl_dataset_contacts_dataset_contact_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_dataset_masters_master_set_id_seq"
OWNED BY "public"."tbl_dataset_masters"."master_set_id";
SELECT setval('"public"."tbl_dataset_masters_master_set_id_seq"', 2, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_dataset_submission_types_submission_type_id_seq"
OWNED BY "public"."tbl_dataset_submission_types"."submission_type_id";
SELECT setval('"public"."tbl_dataset_submission_types_submission_type_id_seq"', 11, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_dataset_submissions_dataset_submission_id_seq"
OWNED BY "public"."tbl_dataset_submissions"."dataset_submission_id";
SELECT setval('"public"."tbl_dataset_submissions_dataset_submission_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_datasets_dataset_id_seq"
OWNED BY "public"."tbl_datasets"."dataset_id";
SELECT setval('"public"."tbl_datasets_dataset_id_seq"', 8036, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_dating_labs_dating_lab_id_seq"
OWNED BY "public"."tbl_dating_labs"."dating_lab_id";
SELECT setval('"public"."tbl_dating_labs_dating_lab_id_seq"', 911, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_dating_material_dating_material_id_seq"
OWNED BY "public"."tbl_dating_material"."dating_material_id";
SELECT setval('"public"."tbl_dating_material_dating_material_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_dating_uncertainty_dating_uncertainty_id_seq"
OWNED BY "public"."tbl_dating_uncertainty"."dating_uncertainty_id";
SELECT setval('"public"."tbl_dating_uncertainty_dating_uncertainty_id_seq"', 8, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_dendro_date_notes_dendro_date_note_id_seq"
OWNED BY "public"."tbl_dendro_date_notes"."dendro_date_note_id";
SELECT setval('"public"."tbl_dendro_date_notes_dendro_date_note_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_dendro_dates_dendro_date_id_seq"
OWNED BY "public"."tbl_dendro_dates"."dendro_date_id";
SELECT setval('"public"."tbl_dendro_dates_dendro_date_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_dendro_dendro_id_seq"
OWNED BY "public"."tbl_dendro"."dendro_id";
SELECT setval('"public"."tbl_dendro_dendro_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_dendro_measurement_lookup_dendro_measurement_lookup_id_seq"
OWNED BY "public"."tbl_dendro_measurement_lookup"."dendro_measurement_lookup_id";
SELECT setval('"public"."tbl_dendro_measurement_lookup_dendro_measurement_lookup_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_dendro_measurements_dendro_measurement_id_seq"
OWNED BY "public"."tbl_dendro_measurements"."dendro_measurement_id";
SELECT setval('"public"."tbl_dendro_measurements_dendro_measurement_id_seq"', 12, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_dimensions_dimension_id_seq"
OWNED BY "public"."tbl_dimensions"."dimension_id";
SELECT setval('"public"."tbl_dimensions_dimension_id_seq"', 33, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_ecocode_definitions_ecocode_definition_id_seq"
OWNED BY "public"."tbl_ecocode_definitions"."ecocode_definition_id";
SELECT setval('"public"."tbl_ecocode_definitions_ecocode_definition_id_seq"', 158, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_ecocode_groups_ecocode_group_id_seq"
OWNED BY "public"."tbl_ecocode_groups"."ecocode_group_id";
SELECT setval('"public"."tbl_ecocode_groups_ecocode_group_id_seq"', 3, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_ecocode_systems_ecocode_system_id_seq"
OWNED BY "public"."tbl_ecocode_systems"."ecocode_system_id";
SELECT setval('"public"."tbl_ecocode_systems_ecocode_system_id_seq"', 3, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_ecocodes_ecocode_id_seq"
OWNED BY "public"."tbl_ecocodes"."ecocode_id";
SELECT setval('"public"."tbl_ecocodes_ecocode_id_seq"', 22983, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_feature_types_feature_type_id_seq"
OWNED BY "public"."tbl_feature_types"."feature_type_id";
SELECT setval('"public"."tbl_feature_types_feature_type_id_seq"', 42, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_features_feature_id_seq"
OWNED BY "public"."tbl_features"."feature_id";
SELECT setval('"public"."tbl_features_feature_id_seq"', 1831, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_geochron_refs_geochron_ref_id_seq"
OWNED BY "public"."tbl_geochron_refs"."geochron_ref_id";
SELECT setval('"public"."tbl_geochron_refs_geochron_ref_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_geochronology_geochron_id_seq"
OWNED BY "public"."tbl_geochronology"."geochron_id";
SELECT setval('"public"."tbl_geochronology_geochron_id_seq"', 1149, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_horizons_horizon_id_seq"
OWNED BY "public"."tbl_horizons"."horizon_id";
SELECT setval('"public"."tbl_horizons_horizon_id_seq"', 125, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_identification_levels_identification_level_id_seq"
OWNED BY "public"."tbl_identification_levels"."identification_level_id";
SELECT setval('"public"."tbl_identification_levels_identification_level_id_seq"', 6, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_image_types_image_type_id_seq"
OWNED BY "public"."tbl_image_types"."image_type_id";
SELECT setval('"public"."tbl_image_types_image_type_id_seq"', 8, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq"
OWNED BY "public"."tbl_imported_taxa_replacements"."imported_taxa_replacement_id";
SELECT setval('"public"."tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_keywords_keyword_id_seq"
OWNED BY "public"."tbl_keywords"."keyword_id";
SELECT setval('"public"."tbl_keywords_keyword_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_languages_language_id_seq"
OWNED BY "public"."tbl_languages"."language_id";
SELECT setval('"public"."tbl_languages_language_id_seq"', 2, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_lithology_lithology_id_seq"
OWNED BY "public"."tbl_lithology"."lithology_id";
SELECT setval('"public"."tbl_lithology_lithology_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_location_types_location_type_id_seq"
OWNED BY "public"."tbl_location_types"."location_type_id";
SELECT setval('"public"."tbl_location_types_location_type_id_seq"', 20, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_locations_location_id_seq"
OWNED BY "public"."tbl_locations"."location_id";
SELECT setval('"public"."tbl_locations_location_id_seq"', 1665, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_mcr_names_taxon_id_seq"
OWNED BY "public"."tbl_mcr_names"."taxon_id";
SELECT setval('"public"."tbl_mcr_names_taxon_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_mcr_summary_data_mcr_summary_data_id_seq"
OWNED BY "public"."tbl_mcr_summary_data"."mcr_summary_data_id";
SELECT setval('"public"."tbl_mcr_summary_data_mcr_summary_data_id_seq"', 436, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq"
OWNED BY "public"."tbl_mcrdata_birmbeetledat"."mcrdata_birmbeetledat_id";
SELECT setval('"public"."tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq"', 15696, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_measured_value_dimensions_measured_value_dimension_id_seq"
OWNED BY "public"."tbl_measured_value_dimensions"."measured_value_dimension_id";
SELECT setval('"public"."tbl_measured_value_dimensions_measured_value_dimension_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_measured_values_measured_value_id_seq"
OWNED BY "public"."tbl_measured_values"."measured_value_id";
SELECT setval('"public"."tbl_measured_values_measured_value_id_seq"', 96055, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_method_groups_method_group_id_seq"
OWNED BY "public"."tbl_method_groups"."method_group_id";
SELECT setval('"public"."tbl_method_groups_method_group_id_seq"', 22, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_methods_method_id_seq"
OWNED BY "public"."tbl_methods"."method_id";
SELECT setval('"public"."tbl_methods_method_id_seq"', 155, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_modification_types_modification_type_id_seq"
OWNED BY "public"."tbl_modification_types"."modification_type_id";
SELECT setval('"public"."tbl_modification_types_modification_type_id_seq"', 10, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_physical_sample_features_physical_sample_feature_id_seq"
OWNED BY "public"."tbl_physical_sample_features"."physical_sample_feature_id";
SELECT setval('"public"."tbl_physical_sample_features_physical_sample_feature_id_seq"', 4833, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_physical_samples_physical_sample_id_seq"
OWNED BY "public"."tbl_physical_samples"."physical_sample_id";
SELECT setval('"public"."tbl_physical_samples_physical_sample_id_seq"', 32799, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_project_stage_project_stage_id_seq"
OWNED BY "public"."tbl_project_stages"."project_stage_id";
SELECT setval('"public"."tbl_project_stage_project_stage_id_seq"', 4, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_project_types_project_type_id_seq"
OWNED BY "public"."tbl_project_types"."project_type_id";
SELECT setval('"public"."tbl_project_types_project_type_id_seq"', 6, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_projects_project_id_seq"
OWNED BY "public"."tbl_projects"."project_id";
SELECT setval('"public"."tbl_projects_project_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_publication_types_publication_type_id_seq"
OWNED BY "public"."tbl_publication_types"."publication_type_id";
SELECT setval('"public"."tbl_publication_types_publication_type_id_seq"', 26, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_publishers_publisher_id_seq"
OWNED BY "public"."tbl_publishers"."publisher_id";
SELECT setval('"public"."tbl_publishers_publisher_id_seq"', 2497, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_radiocarbon_calibration_radiocarbon_calibration_id_seq"
OWNED BY "public"."tbl_radiocarbon_calibration"."radiocarbon_calibration_id";
SELECT setval('"public"."tbl_radiocarbon_calibration_radiocarbon_calibration_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_rdb_codes_rdb_code_id_seq"
OWNED BY "public"."tbl_rdb_codes"."rdb_code_id";
SELECT setval('"public"."tbl_rdb_codes_rdb_code_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_rdb_rdb_id_seq"
OWNED BY "public"."tbl_rdb"."rdb_id";
SELECT setval('"public"."tbl_rdb_rdb_id_seq"', 1752, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_rdb_systems_rdb_system_id_seq"
OWNED BY "public"."tbl_rdb_systems"."rdb_system_id";
SELECT setval('"public"."tbl_rdb_systems_rdb_system_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_record_types_record_type_id_seq"
OWNED BY "public"."tbl_record_types"."record_type_id";
SELECT setval('"public"."tbl_record_types_record_type_id_seq"', 19, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_relative_age_refs_relative_age_ref_id_seq"
OWNED BY "public"."tbl_relative_age_refs"."relative_age_ref_id";
SELECT setval('"public"."tbl_relative_age_refs_relative_age_ref_id_seq"', 45, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_relative_age_types_relative_age_type_id_seq"
OWNED BY "public"."tbl_relative_age_types"."relative_age_type_id";
SELECT setval('"public"."tbl_relative_age_types_relative_age_type_id_seq"', 13, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_relative_ages_relative_age_id_seq"
OWNED BY "public"."tbl_relative_ages"."relative_age_id";
SELECT setval('"public"."tbl_relative_ages_relative_age_id_seq"', 388, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_relative_dates_relative_date_id_seq"
OWNED BY "public"."tbl_relative_dates"."relative_date_id";
SELECT setval('"public"."tbl_relative_dates_relative_date_id_seq"', 8206, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_alt_refs_sample_alt_ref_id_seq"
OWNED BY "public"."tbl_sample_alt_refs"."sample_alt_ref_id";
SELECT setval('"public"."tbl_sample_alt_refs_sample_alt_ref_id_seq"', 9787, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_colours_sample_colour_id_seq"
OWNED BY "public"."tbl_sample_colours"."sample_colour_id";
SELECT setval('"public"."tbl_sample_colours_sample_colour_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_coordinates_sample_coordinates_id_seq"
OWNED BY "public"."tbl_sample_coordinates"."sample_coordinate_id";
SELECT setval('"public"."tbl_sample_coordinates_sample_coordinates_id_seq"', 57296, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_description_sample_sample_description_sample_gro_seq"
OWNED BY "public"."tbl_sample_description_sample_group_contexts"."sample_description_sample_group_context_id";
SELECT setval('"public"."tbl_sample_description_sample_sample_description_sample_gro_seq"', 6, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_description_types_sample_description_type_id_seq"
OWNED BY "public"."tbl_sample_description_types"."sample_description_type_id";
SELECT setval('"public"."tbl_sample_description_types_sample_description_type_id_seq"', 5, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_descriptions_sample_description_id_seq"
OWNED BY "public"."tbl_sample_descriptions"."sample_description_id";
SELECT setval('"public"."tbl_sample_descriptions_sample_description_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_dimensions_sample_dimension_id_seq"
OWNED BY "public"."tbl_sample_dimensions"."sample_dimension_id";
SELECT setval('"public"."tbl_sample_dimensions_sample_dimension_id_seq"', 4480, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
SELECT setval('"public"."tbl_sample_geometry_sample_geometry_id_seq"', 12719, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_group_coordinates_sample_group_position_id_seq"
OWNED BY "public"."tbl_sample_group_coordinates"."sample_group_position_id";
SELECT setval('"public"."tbl_sample_group_coordinates_sample_group_position_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_group_description__sample_group_desciption_sampl_seq"
OWNED BY "public"."tbl_sample_group_description_type_sampling_contexts"."sample_group_description_type_sampling_context_id";
SELECT setval('"public"."tbl_sample_group_description__sample_group_desciption_sampl_seq"', 15, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_group_description__sample_group_description_type_seq"
OWNED BY "public"."tbl_sample_group_description_types"."sample_group_description_type_id";
SELECT setval('"public"."tbl_sample_group_description__sample_group_description_type_seq"', 3, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_group_descriptions_sample_group_description_id_seq"
OWNED BY "public"."tbl_sample_group_descriptions"."sample_group_description_id";
SELECT setval('"public"."tbl_sample_group_descriptions_sample_group_description_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_group_dimensions_sample_group_dimension_id_seq"
OWNED BY "public"."tbl_sample_group_dimensions"."sample_group_dimension_id";
SELECT setval('"public"."tbl_sample_group_dimensions_sample_group_dimension_id_seq"', 2, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_group_images_sample_group_image_id_seq"
OWNED BY "public"."tbl_sample_group_images"."sample_group_image_id";
SELECT setval('"public"."tbl_sample_group_images_sample_group_image_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_group_notes_sample_group_note_id_seq"
OWNED BY "public"."tbl_sample_group_notes"."sample_group_note_id";
SELECT setval('"public"."tbl_sample_group_notes_sample_group_note_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_group_references_sample_group_reference_id_seq"
OWNED BY "public"."tbl_sample_group_references"."sample_group_reference_id";
SELECT setval('"public"."tbl_sample_group_references_sample_group_reference_id_seq"', 1006, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_group_sampling_contexts_sampling_context_id_seq"
OWNED BY "public"."tbl_sample_group_sampling_contexts"."sampling_context_id";
SELECT setval('"public"."tbl_sample_group_sampling_contexts_sampling_context_id_seq"', 14, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_groups_sample_group_id_seq"
OWNED BY "public"."tbl_sample_groups"."sample_group_id";
SELECT setval('"public"."tbl_sample_groups_sample_group_id_seq"', 2223, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_horizons_sample_horizon_id_seq"
OWNED BY "public"."tbl_sample_horizons"."sample_horizon_id";
SELECT setval('"public"."tbl_sample_horizons_sample_horizon_id_seq"', 7916, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_images_sample_image_id_seq"
OWNED BY "public"."tbl_sample_images"."sample_image_id";
SELECT setval('"public"."tbl_sample_images_sample_image_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_location_sampling__sample_location_type_sampling_seq"
OWNED BY "public"."tbl_sample_location_type_sampling_contexts"."sample_location_type_sampling_context_id";
SELECT setval('"public"."tbl_sample_location_sampling__sample_location_type_sampling_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_location_sampling_contex_sample_location_type_id_seq"
OWNED BY "public"."tbl_sample_location_type_sampling_contexts"."sample_location_type_id";
SELECT setval('"public"."tbl_sample_location_sampling_contex_sample_location_type_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_location_types_sample_location_type_id_seq"
OWNED BY "public"."tbl_sample_location_types"."sample_location_type_id";
SELECT setval('"public"."tbl_sample_location_types_sample_location_type_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_locations_sample_location_id_seq"
OWNED BY "public"."tbl_sample_locations"."sample_location_id";
SELECT setval('"public"."tbl_sample_locations_sample_location_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_notes_sample_note_id_seq"
OWNED BY "public"."tbl_sample_notes"."sample_note_id";
SELECT setval('"public"."tbl_sample_notes_sample_note_id_seq"', 5380, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sample_types_sample_type_id_seq"
OWNED BY "public"."tbl_sample_types"."sample_type_id";
SELECT setval('"public"."tbl_sample_types_sample_type_id_seq"', 14, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_season_types_season_type_id_seq"
OWNED BY "public"."tbl_season_types"."season_type_id";
SELECT setval('"public"."tbl_season_types_season_type_id_seq"', 10, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_seasons_season_id_seq"
OWNED BY "public"."tbl_seasons"."season_id";
SELECT setval('"public"."tbl_seasons_season_id_seq"', 19, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_site_images_site_image_id_seq"
OWNED BY "public"."tbl_site_images"."site_image_id";
SELECT setval('"public"."tbl_site_images_site_image_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_site_locations_site_location_id_seq"
OWNED BY "public"."tbl_site_locations"."site_location_id";
SELECT setval('"public"."tbl_site_locations_site_location_id_seq"', 4566, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_site_natgridrefs_site_natgridref_id_seq"
OWNED BY "public"."tbl_site_natgridrefs"."site_natgridref_id";
SELECT setval('"public"."tbl_site_natgridrefs_site_natgridref_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_site_other_records_site_other_records_id_seq"
OWNED BY "public"."tbl_site_other_records"."site_other_records_id";
SELECT setval('"public"."tbl_site_other_records_site_other_records_id_seq"', 1989, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_site_preservation_status_site_preservation_status_id_seq"
OWNED BY "public"."tbl_site_preservation_status"."site_preservation_status_id";
SELECT setval('"public"."tbl_site_preservation_status_site_preservation_status_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_site_references_site_reference_id_seq"
OWNED BY "public"."tbl_site_references"."site_reference_id";
SELECT setval('"public"."tbl_site_references_site_reference_id_seq"', 1896, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_sites_site_id_seq"
OWNED BY "public"."tbl_sites"."site_id";
SELECT setval('"public"."tbl_sites_site_id_seq"', 1566, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_species_associations_species_association_id_seq"
OWNED BY "public"."tbl_species_associations"."species_association_id";
SELECT setval('"public"."tbl_species_associations_species_association_id_seq"', 1687, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_taxa_common_names_taxon_common_name_id_seq"
OWNED BY "public"."tbl_taxa_common_names"."taxon_common_name_id";
SELECT setval('"public"."tbl_taxa_common_names_taxon_common_name_id_seq"', 4272, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_taxa_images_taxa_images_id_seq"
OWNED BY "public"."tbl_taxa_images"."taxa_images_id";
SELECT setval('"public"."tbl_taxa_images_taxa_images_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_taxa_measured_attributes_measured_attribute_id_seq"
OWNED BY "public"."tbl_taxa_measured_attributes"."measured_attribute_id";
SELECT setval('"public"."tbl_taxa_measured_attributes_measured_attribute_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq"
OWNED BY "public"."tbl_taxa_reference_specimens"."taxa_reference_specimen_id";
SELECT setval('"public"."tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_taxa_seasonality_seasonality_id_seq"
OWNED BY "public"."tbl_taxa_seasonality"."seasonality_id";
SELECT setval('"public"."tbl_taxa_seasonality_seasonality_id_seq"', 19766, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_taxa_synonyms_synonym_id_seq"
OWNED BY "public"."tbl_taxa_synonyms"."synonym_id";
SELECT setval('"public"."tbl_taxa_synonyms_synonym_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_taxa_tree_authors_author_id_seq"
OWNED BY "public"."tbl_taxa_tree_authors"."author_id";
SELECT setval('"public"."tbl_taxa_tree_authors_author_id_seq"', 4411, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_taxa_tree_families_family_id_seq"
OWNED BY "public"."tbl_taxa_tree_families"."family_id";
SELECT setval('"public"."tbl_taxa_tree_families_family_id_seq"', 1979, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_taxa_tree_genera_genus_id_seq"
OWNED BY "public"."tbl_taxa_tree_genera"."genus_id";
SELECT setval('"public"."tbl_taxa_tree_genera_genus_id_seq"', 15467, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_taxa_tree_master_taxon_id_seq"
OWNED BY "public"."tbl_taxa_tree_master"."taxon_id";
SELECT setval('"public"."tbl_taxa_tree_master_taxon_id_seq"', 39621, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_taxa_tree_orders_order_id_seq"
OWNED BY "public"."tbl_taxa_tree_orders"."order_id";
SELECT setval('"public"."tbl_taxa_tree_orders_order_id_seq"', 138, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq"
OWNED BY "public"."tbl_taxonomic_order_biblio"."taxonomic_order_biblio_id";
SELECT setval('"public"."tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_taxonomic_order_systems_taxonomic_order_system_id_seq"
OWNED BY "public"."tbl_taxonomic_order_systems"."taxonomic_order_system_id";
SELECT setval('"public"."tbl_taxonomic_order_systems_taxonomic_order_system_id_seq"', 1, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_taxonomic_order_taxonomic_order_id_seq"
OWNED BY "public"."tbl_taxonomic_order"."taxonomic_order_id";
SELECT setval('"public"."tbl_taxonomic_order_taxonomic_order_id_seq"', 30786, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_taxonomy_notes_taxonomy_notes_id_seq"
OWNED BY "public"."tbl_taxonomy_notes"."taxonomy_notes_id";
SELECT setval('"public"."tbl_taxonomy_notes_taxonomy_notes_id_seq"', 2468, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_tephra_dates_tephra_date_id_seq"
OWNED BY "public"."tbl_tephra_dates"."tephra_date_id";
SELECT setval('"public"."tbl_tephra_dates_tephra_date_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_tephra_refs_tephra_ref_id_seq"
OWNED BY "public"."tbl_tephra_refs"."tephra_ref_id";
SELECT setval('"public"."tbl_tephra_refs_tephra_ref_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_tephras_tephra_id_seq"
OWNED BY "public"."tbl_tephras"."tephra_id";
SELECT setval('"public"."tbl_tephras_tephra_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_text_biology_biology_id_seq"
OWNED BY "public"."tbl_text_biology"."biology_id";
SELECT setval('"public"."tbl_text_biology_biology_id_seq"', 31023, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_text_distribution_distribution_id_seq"
OWNED BY "public"."tbl_text_distribution"."distribution_id";
SELECT setval('"public"."tbl_text_distribution_distribution_id_seq"', 33891, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_text_identification_keys_key_id_seq"
OWNED BY "public"."tbl_text_identification_keys"."key_id";
SELECT setval('"public"."tbl_text_identification_keys_key_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_units_unit_id_seq"
OWNED BY "public"."tbl_units"."unit_id";
SELECT setval('"public"."tbl_units_unit_id_seq"', 15, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."tbl_years_types_years_type_id_seq"
OWNED BY "public"."tbl_years_types"."years_type_id";
SELECT setval('"public"."tbl_years_types_years_type_id_seq"', 1, false);

-- ----------------------------
-- Primary Key structure for table tbl_abundance_elements
-- ----------------------------
ALTER TABLE "public"."tbl_abundance_elements" ADD CONSTRAINT "pk_abundance_elements" PRIMARY KEY ("abundance_element_id");

-- ----------------------------
-- Primary Key structure for table tbl_abundance_ident_levels
-- ----------------------------
ALTER TABLE "public"."tbl_abundance_ident_levels" ADD CONSTRAINT "pk_abundance_ident_levels" PRIMARY KEY ("abundance_ident_level_id");

-- ----------------------------
-- Primary Key structure for table tbl_abundance_modifications
-- ----------------------------
ALTER TABLE "public"."tbl_abundance_modifications" ADD CONSTRAINT "pk_abundance_modifications" PRIMARY KEY ("abundance_modification_id");

-- ----------------------------
-- Primary Key structure for table tbl_abundances
-- ----------------------------
ALTER TABLE "public"."tbl_abundances" ADD CONSTRAINT "pk_abundances" PRIMARY KEY ("abundance_id");

-- ----------------------------
-- Primary Key structure for table tbl_activity_types
-- ----------------------------
ALTER TABLE "public"."tbl_activity_types" ADD CONSTRAINT "pk_activity_types" PRIMARY KEY ("activity_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_aggregate_datasets
-- ----------------------------
ALTER TABLE "public"."tbl_aggregate_datasets" ADD CONSTRAINT "pk_aggregate_datasets" PRIMARY KEY ("aggregate_dataset_id");

-- ----------------------------
-- Primary Key structure for table tbl_aggregate_order_types
-- ----------------------------
ALTER TABLE "public"."tbl_aggregate_order_types" ADD CONSTRAINT "pk_aggregate_order_types" PRIMARY KEY ("aggregate_order_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_aggregate_sample_ages
-- ----------------------------
ALTER TABLE "public"."tbl_aggregate_sample_ages" ADD CONSTRAINT "pk_aggregate_sample_ages" PRIMARY KEY ("aggregate_sample_age_id");

-- ----------------------------
-- Primary Key structure for table tbl_aggregate_samples
-- ----------------------------
ALTER TABLE "public"."tbl_aggregate_samples" ADD CONSTRAINT "pk_aggregate_samples" PRIMARY KEY ("aggregate_sample_id");

-- ----------------------------
-- Primary Key structure for table tbl_alt_ref_types
-- ----------------------------
ALTER TABLE "public"."tbl_alt_ref_types" ADD CONSTRAINT "pk_alt_ref_types" PRIMARY KEY ("alt_ref_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_analysis_entities
-- ----------------------------
ALTER TABLE "public"."tbl_analysis_entities" ADD CONSTRAINT "pk_analysis_entities" PRIMARY KEY ("analysis_entity_id");

-- ----------------------------
-- Primary Key structure for table tbl_analysis_entity_ages
-- ----------------------------
ALTER TABLE "public"."tbl_analysis_entity_ages" ADD CONSTRAINT "pk_sample_ages" PRIMARY KEY ("analysis_entity_age_id");

-- ----------------------------
-- Primary Key structure for table tbl_analysis_entity_dimensions
-- ----------------------------
ALTER TABLE "public"."tbl_analysis_entity_dimensions" ADD CONSTRAINT "tbl_analysis_entity_dimensions_pkey" PRIMARY KEY ("analysis_entity_dimension_id");

-- ----------------------------
-- Primary Key structure for table tbl_analysis_entity_prep_methods
-- ----------------------------
ALTER TABLE "public"."tbl_analysis_entity_prep_methods" ADD CONSTRAINT "tbl_analysis_entity_prep_methods_pkey" PRIMARY KEY ("analysis_entity_prep_method_id");

-- ----------------------------
-- Primary Key structure for table tbl_biblio
-- ----------------------------
ALTER TABLE "public"."tbl_biblio" ADD CONSTRAINT "pk_biblio" PRIMARY KEY ("biblio_id");

-- ----------------------------
-- Primary Key structure for table tbl_biblio_keywords
-- ----------------------------
ALTER TABLE "public"."tbl_biblio_keywords" ADD CONSTRAINT "tbl_biblio_keywords_pkey" PRIMARY KEY ("biblio_keyword_id");

-- ----------------------------
-- Primary Key structure for table tbl_ceramics
-- ----------------------------
ALTER TABLE "public"."tbl_ceramics" ADD CONSTRAINT "tbl_ceramics_pkey" PRIMARY KEY ("ceramics_id");

-- ----------------------------
-- Primary Key structure for table tbl_ceramics_measurement_lookup
-- ----------------------------
ALTER TABLE "public"."tbl_ceramics_measurement_lookup" ADD CONSTRAINT "tbl_ceramics_measurement_lookup_pkey" PRIMARY KEY ("ceramics_measurement_lookup_id");

-- ----------------------------
-- Primary Key structure for table tbl_ceramics_measurements
-- ----------------------------
ALTER TABLE "public"."tbl_ceramics_measurements" ADD CONSTRAINT "tbl_ceramics_measurements_pkey" PRIMARY KEY ("ceramics_measurement_id");

-- ----------------------------
-- Primary Key structure for table tbl_chron_control_types
-- ----------------------------
ALTER TABLE "public"."tbl_chron_control_types" ADD CONSTRAINT "pk_chron_control_types" PRIMARY KEY ("chron_control_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_chron_controls
-- ----------------------------
ALTER TABLE "public"."tbl_chron_controls" ADD CONSTRAINT "pk_chron_controls" PRIMARY KEY ("chron_control_id");

-- ----------------------------
-- Primary Key structure for table tbl_chronologies
-- ----------------------------
ALTER TABLE "public"."tbl_chronologies" ADD CONSTRAINT "pk_chronologies" PRIMARY KEY ("chronology_id");

-- ----------------------------
-- Primary Key structure for table tbl_collections_or_journals
-- ----------------------------
ALTER TABLE "public"."tbl_collections_or_journals" ADD CONSTRAINT "pk_collections_or_journals" PRIMARY KEY ("collection_or_journal_id");

-- ----------------------------
-- Primary Key structure for table tbl_colours
-- ----------------------------
ALTER TABLE "public"."tbl_colours" ADD CONSTRAINT "pk_colours" PRIMARY KEY ("colour_id");

-- ----------------------------
-- Primary Key structure for table tbl_contact_types
-- ----------------------------
ALTER TABLE "public"."tbl_contact_types" ADD CONSTRAINT "pk_contact_types" PRIMARY KEY ("contact_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_contacts
-- ----------------------------
ALTER TABLE "public"."tbl_contacts" ADD CONSTRAINT "pk_contacts" PRIMARY KEY ("contact_id");

-- ----------------------------
-- Primary Key structure for table tbl_coordinate_method_dimensions
-- ----------------------------
ALTER TABLE "public"."tbl_coordinate_method_dimensions" ADD CONSTRAINT "tbl_coordinate_method_dimensions_pkey" PRIMARY KEY ("coordinate_method_dimension_id");

-- ----------------------------
-- Primary Key structure for table tbl_data_type_groups
-- ----------------------------
ALTER TABLE "public"."tbl_data_type_groups" ADD CONSTRAINT "pk_data_type_groups" PRIMARY KEY ("data_type_group_id");

-- ----------------------------
-- Primary Key structure for table tbl_data_types
-- ----------------------------
ALTER TABLE "public"."tbl_data_types" ADD CONSTRAINT "pk_samplegroup_data_types" PRIMARY KEY ("data_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_dataset_contacts
-- ----------------------------
ALTER TABLE "public"."tbl_dataset_contacts" ADD CONSTRAINT "pk_dataset_contacts" PRIMARY KEY ("dataset_contact_id");

-- ----------------------------
-- Primary Key structure for table tbl_dataset_masters
-- ----------------------------
ALTER TABLE "public"."tbl_dataset_masters" ADD CONSTRAINT "pk_dataset_masters" PRIMARY KEY ("master_set_id");

-- ----------------------------
-- Primary Key structure for table tbl_dataset_submission_types
-- ----------------------------
ALTER TABLE "public"."tbl_dataset_submission_types" ADD CONSTRAINT "pk_dataset_submission_types" PRIMARY KEY ("submission_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_dataset_submissions
-- ----------------------------
ALTER TABLE "public"."tbl_dataset_submissions" ADD CONSTRAINT "pk_dataset_submissions" PRIMARY KEY ("dataset_submission_id");

-- ----------------------------
-- Primary Key structure for table tbl_datasets
-- ----------------------------
ALTER TABLE "public"."tbl_datasets" ADD CONSTRAINT "pk_datasets" PRIMARY KEY ("dataset_id");

-- ----------------------------
-- Primary Key structure for table tbl_dating_labs
-- ----------------------------
ALTER TABLE "public"."tbl_dating_labs" ADD CONSTRAINT "pk_dating_labs" PRIMARY KEY ("dating_lab_id");

-- ----------------------------
-- Primary Key structure for table tbl_dating_material
-- ----------------------------
ALTER TABLE "public"."tbl_dating_material" ADD CONSTRAINT "tbl_dating_material_pkey" PRIMARY KEY ("dating_material_id");

-- ----------------------------
-- Primary Key structure for table tbl_dating_uncertainty
-- ----------------------------
ALTER TABLE "public"."tbl_dating_uncertainty" ADD CONSTRAINT "tbl_dating_uncertainty_pkey" PRIMARY KEY ("dating_uncertainty_id");

-- ----------------------------
-- Primary Key structure for table tbl_dendro
-- ----------------------------
ALTER TABLE "public"."tbl_dendro" ADD CONSTRAINT "tbl_dendro_pkey" PRIMARY KEY ("dendro_id");

-- ----------------------------
-- Primary Key structure for table tbl_dendro_date_notes
-- ----------------------------
ALTER TABLE "public"."tbl_dendro_date_notes" ADD CONSTRAINT "tbl_dendro_date_notes_pkey" PRIMARY KEY ("dendro_date_note_id");

-- ----------------------------
-- Primary Key structure for table tbl_dendro_dates
-- ----------------------------
ALTER TABLE "public"."tbl_dendro_dates" ADD CONSTRAINT "tbl_dendro_dates_pkey" PRIMARY KEY ("dendro_date_id");

-- ----------------------------
-- Primary Key structure for table tbl_dendro_measurement_lookup
-- ----------------------------
ALTER TABLE "public"."tbl_dendro_measurement_lookup" ADD CONSTRAINT "tbl_dendro_measurement_lookup_pkey" PRIMARY KEY ("dendro_measurement_lookup_id");

-- ----------------------------
-- Primary Key structure for table tbl_dendro_measurements
-- ----------------------------
ALTER TABLE "public"."tbl_dendro_measurements" ADD CONSTRAINT "tbl_dendro_measurements_pkey" PRIMARY KEY ("dendro_measurement_id");

-- ----------------------------
-- Primary Key structure for table tbl_dimensions
-- ----------------------------
ALTER TABLE "public"."tbl_dimensions" ADD CONSTRAINT "pk_dimensions" PRIMARY KEY ("dimension_id");

-- ----------------------------
-- Primary Key structure for table tbl_ecocode_definitions
-- ----------------------------
ALTER TABLE "public"."tbl_ecocode_definitions" ADD CONSTRAINT "pk_ecocode_definitions" PRIMARY KEY ("ecocode_definition_id");

-- ----------------------------
-- Indexes structure for table tbl_ecocode_groups
-- ----------------------------
CREATE INDEX "tbl_ecocode_groups_idx_ecocodesystemid" ON "public"."tbl_ecocode_groups" USING btree (
  "ecocode_system_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_ecocode_groups_idx_label" ON "public"."tbl_ecocode_groups" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tbl_ecocode_groups
-- ----------------------------
ALTER TABLE "public"."tbl_ecocode_groups" ADD CONSTRAINT "pk_ecocode_groups" PRIMARY KEY ("ecocode_group_id");

-- ----------------------------
-- Indexes structure for table tbl_ecocode_systems
-- ----------------------------
CREATE INDEX "tbl_ecocode_systems_biblioid" ON "public"."tbl_ecocode_systems" USING btree (
  "biblio_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_ecocode_systems_ecocodegroupid" ON "public"."tbl_ecocode_systems" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tbl_ecocode_systems
-- ----------------------------
ALTER TABLE "public"."tbl_ecocode_systems" ADD CONSTRAINT "pk_ecocode_systems" PRIMARY KEY ("ecocode_system_id");

-- ----------------------------
-- Primary Key structure for table tbl_ecocodes
-- ----------------------------
ALTER TABLE "public"."tbl_ecocodes" ADD CONSTRAINT "pk_ecocodes" PRIMARY KEY ("ecocode_id");

-- ----------------------------
-- Primary Key structure for table tbl_feature_types
-- ----------------------------
ALTER TABLE "public"."tbl_feature_types" ADD CONSTRAINT "pk_feature_type_id" PRIMARY KEY ("feature_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_features
-- ----------------------------
ALTER TABLE "public"."tbl_features" ADD CONSTRAINT "pk_features" PRIMARY KEY ("feature_id");

-- ----------------------------
-- Primary Key structure for table tbl_geochron_refs
-- ----------------------------
ALTER TABLE "public"."tbl_geochron_refs" ADD CONSTRAINT "pk_geochron_refs" PRIMARY KEY ("geochron_ref_id");

-- ----------------------------
-- Primary Key structure for table tbl_geochronology
-- ----------------------------
ALTER TABLE "public"."tbl_geochronology" ADD CONSTRAINT "pk_geochronology" PRIMARY KEY ("geochron_id");

-- ----------------------------
-- Primary Key structure for table tbl_horizons
-- ----------------------------
ALTER TABLE "public"."tbl_horizons" ADD CONSTRAINT "pk_horizons" PRIMARY KEY ("horizon_id");

-- ----------------------------
-- Primary Key structure for table tbl_identification_levels
-- ----------------------------
ALTER TABLE "public"."tbl_identification_levels" ADD CONSTRAINT "pk_identification_levels" PRIMARY KEY ("identification_level_id");

-- ----------------------------
-- Primary Key structure for table tbl_image_types
-- ----------------------------
ALTER TABLE "public"."tbl_image_types" ADD CONSTRAINT "pk_image_types" PRIMARY KEY ("image_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_imported_taxa_replacements
-- ----------------------------
ALTER TABLE "public"."tbl_imported_taxa_replacements" ADD CONSTRAINT "pk_imported_taxa_replacements" PRIMARY KEY ("imported_taxa_replacement_id");

-- ----------------------------
-- Primary Key structure for table tbl_keywords
-- ----------------------------
ALTER TABLE "public"."tbl_keywords" ADD CONSTRAINT "tbl_keywords_pkey" PRIMARY KEY ("keyword_id");

-- ----------------------------
-- Indexes structure for table tbl_languages
-- ----------------------------
CREATE INDEX "tbl_languages_language_id" ON "public"."tbl_languages" USING btree (
  "language_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tbl_languages
-- ----------------------------
ALTER TABLE "public"."tbl_languages" ADD CONSTRAINT "pk_languages" PRIMARY KEY ("language_id");

-- ----------------------------
-- Primary Key structure for table tbl_lithology
-- ----------------------------
ALTER TABLE "public"."tbl_lithology" ADD CONSTRAINT "pk_lithologies" PRIMARY KEY ("lithology_id");

-- ----------------------------
-- Primary Key structure for table tbl_location_types
-- ----------------------------
ALTER TABLE "public"."tbl_location_types" ADD CONSTRAINT "pk_location_types" PRIMARY KEY ("location_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_locations
-- ----------------------------
ALTER TABLE "public"."tbl_locations" ADD CONSTRAINT "pk_locations" PRIMARY KEY ("location_id");

-- ----------------------------
-- Primary Key structure for table tbl_mcr_names
-- ----------------------------
ALTER TABLE "public"."tbl_mcr_names" ADD CONSTRAINT "pk_mcr_names" PRIMARY KEY ("taxon_id");

-- ----------------------------
-- Uniques structure for table tbl_mcr_summary_data
-- ----------------------------
ALTER TABLE "public"."tbl_mcr_summary_data" ADD CONSTRAINT "key_mcr_summary_data_taxon_id" UNIQUE ("taxon_id");

-- ----------------------------
-- Primary Key structure for table tbl_mcr_summary_data
-- ----------------------------
ALTER TABLE "public"."tbl_mcr_summary_data" ADD CONSTRAINT "pk_mcr_summary_data" PRIMARY KEY ("mcr_summary_data_id");

-- ----------------------------
-- Primary Key structure for table tbl_mcrdata_birmbeetledat
-- ----------------------------
ALTER TABLE "public"."tbl_mcrdata_birmbeetledat" ADD CONSTRAINT "pk_mcrdata_birmbeetledat" PRIMARY KEY ("mcrdata_birmbeetledat_id");

-- ----------------------------
-- Primary Key structure for table tbl_measured_value_dimensions
-- ----------------------------
ALTER TABLE "public"."tbl_measured_value_dimensions" ADD CONSTRAINT "pk_measured_weights" PRIMARY KEY ("measured_value_dimension_id");

-- ----------------------------
-- Primary Key structure for table tbl_measured_values
-- ----------------------------
ALTER TABLE "public"."tbl_measured_values" ADD CONSTRAINT "pk_measured_values" PRIMARY KEY ("measured_value_id");

-- ----------------------------
-- Primary Key structure for table tbl_method_groups
-- ----------------------------
ALTER TABLE "public"."tbl_method_groups" ADD CONSTRAINT "pk_method_groups" PRIMARY KEY ("method_group_id");

-- ----------------------------
-- Primary Key structure for table tbl_methods
-- ----------------------------
ALTER TABLE "public"."tbl_methods" ADD CONSTRAINT "pk_methods" PRIMARY KEY ("method_id");

-- ----------------------------
-- Primary Key structure for table tbl_modification_types
-- ----------------------------
ALTER TABLE "public"."tbl_modification_types" ADD CONSTRAINT "pk_modification_types" PRIMARY KEY ("modification_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_physical_sample_features
-- ----------------------------
ALTER TABLE "public"."tbl_physical_sample_features" ADD CONSTRAINT "tbl_physical_sample_features_pkey" PRIMARY KEY ("physical_sample_feature_id");

-- ----------------------------
-- Primary Key structure for table tbl_physical_samples
-- ----------------------------
ALTER TABLE "public"."tbl_physical_samples" ADD CONSTRAINT "pk_physical_samples" PRIMARY KEY ("physical_sample_id");

-- ----------------------------
-- Primary Key structure for table tbl_project_stages
-- ----------------------------
ALTER TABLE "public"."tbl_project_stages" ADD CONSTRAINT "dataset_stage_id" PRIMARY KEY ("project_stage_id");

-- ----------------------------
-- Primary Key structure for table tbl_project_types
-- ----------------------------
ALTER TABLE "public"."tbl_project_types" ADD CONSTRAINT "pk_project_type_id" PRIMARY KEY ("project_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_projects
-- ----------------------------
ALTER TABLE "public"."tbl_projects" ADD CONSTRAINT "pk_projects" PRIMARY KEY ("project_id");

-- ----------------------------
-- Primary Key structure for table tbl_publication_types
-- ----------------------------
ALTER TABLE "public"."tbl_publication_types" ADD CONSTRAINT "pk_publication_types" PRIMARY KEY ("publication_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_publishers
-- ----------------------------
ALTER TABLE "public"."tbl_publishers" ADD CONSTRAINT "pk_publishers" PRIMARY KEY ("publisher_id");

-- ----------------------------
-- Primary Key structure for table tbl_radiocarbon_calibration
-- ----------------------------
ALTER TABLE "public"."tbl_radiocarbon_calibration" ADD CONSTRAINT "pk_radiocarbon_calibration" PRIMARY KEY ("radiocarbon_calibration_id");

-- ----------------------------
-- Primary Key structure for table tbl_rdb
-- ----------------------------
ALTER TABLE "public"."tbl_rdb" ADD CONSTRAINT "pk_rdb" PRIMARY KEY ("rdb_id");

-- ----------------------------
-- Primary Key structure for table tbl_rdb_codes
-- ----------------------------
ALTER TABLE "public"."tbl_rdb_codes" ADD CONSTRAINT "pk_rdb_codes" PRIMARY KEY ("rdb_code_id");

-- ----------------------------
-- Primary Key structure for table tbl_rdb_systems
-- ----------------------------
ALTER TABLE "public"."tbl_rdb_systems" ADD CONSTRAINT "pk_rdb_systems" PRIMARY KEY ("rdb_system_id");

-- ----------------------------
-- Primary Key structure for table tbl_record_types
-- ----------------------------
ALTER TABLE "public"."tbl_record_types" ADD CONSTRAINT "pk_record_types" PRIMARY KEY ("record_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_relative_age_refs
-- ----------------------------
ALTER TABLE "public"."tbl_relative_age_refs" ADD CONSTRAINT "pk_relative_age_refs" PRIMARY KEY ("relative_age_ref_id");

-- ----------------------------
-- Primary Key structure for table tbl_relative_age_types
-- ----------------------------
ALTER TABLE "public"."tbl_relative_age_types" ADD CONSTRAINT "tbl_relative_age_types_pkey" PRIMARY KEY ("relative_age_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_relative_ages
-- ----------------------------
ALTER TABLE "public"."tbl_relative_ages" ADD CONSTRAINT "pk_relative_ages" PRIMARY KEY ("relative_age_id");

-- ----------------------------
-- Primary Key structure for table tbl_relative_dates
-- ----------------------------
ALTER TABLE "public"."tbl_relative_dates" ADD CONSTRAINT "pk_relative_dates" PRIMARY KEY ("relative_date_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_alt_refs
-- ----------------------------
ALTER TABLE "public"."tbl_sample_alt_refs" ADD CONSTRAINT "pk_sample_alt_refs" PRIMARY KEY ("sample_alt_ref_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_colours
-- ----------------------------
ALTER TABLE "public"."tbl_sample_colours" ADD CONSTRAINT "pk_sample_colours" PRIMARY KEY ("sample_colour_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_coordinates
-- ----------------------------
ALTER TABLE "public"."tbl_sample_coordinates" ADD CONSTRAINT "tbl_sample_coordinates_pkey" PRIMARY KEY ("sample_coordinate_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_description_sample_group_contexts
-- ----------------------------
ALTER TABLE "public"."tbl_sample_description_sample_group_contexts" ADD CONSTRAINT "tbl_sample_description_sample_group_contexts_pkey" PRIMARY KEY ("sample_description_sample_group_context_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_description_types
-- ----------------------------
ALTER TABLE "public"."tbl_sample_description_types" ADD CONSTRAINT "tbl_sample_description_types_pkey" PRIMARY KEY ("sample_description_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_descriptions
-- ----------------------------
ALTER TABLE "public"."tbl_sample_descriptions" ADD CONSTRAINT "tbl_sample_descriptions_pkey" PRIMARY KEY ("sample_description_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_dimensions
-- ----------------------------
ALTER TABLE "public"."tbl_sample_dimensions" ADD CONSTRAINT "pk_sample_dimensions" PRIMARY KEY ("sample_dimension_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_group_coordinates
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_coordinates" ADD CONSTRAINT "tbl_sample_group_coordinates_pkey" PRIMARY KEY ("sample_group_position_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_group_description_type_sampling_contexts
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_description_type_sampling_contexts" ADD CONSTRAINT "tbl_sample_group_description_type_sample_contexts_pkey" PRIMARY KEY ("sample_group_description_type_sampling_context_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_group_description_types
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_description_types" ADD CONSTRAINT "tbl_sample_group_description_types_pkey" PRIMARY KEY ("sample_group_description_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_group_descriptions
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_descriptions" ADD CONSTRAINT "pk_sample_group_description_id" PRIMARY KEY ("sample_group_description_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_group_dimensions
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_dimensions" ADD CONSTRAINT "pk_sample_group_dimensions" PRIMARY KEY ("sample_group_dimension_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_group_images
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_images" ADD CONSTRAINT "pk_sample_group_images" PRIMARY KEY ("sample_group_image_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_group_notes
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_notes" ADD CONSTRAINT "pk_sample_group_note_id" PRIMARY KEY ("sample_group_note_id");

-- ----------------------------
-- Indexes structure for table tbl_sample_group_references
-- ----------------------------
CREATE INDEX "idx_biblio_id" ON "public"."tbl_sample_group_references" USING btree (
  "biblio_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_sample_group_id" ON "public"."tbl_sample_group_references" USING btree (
  "sample_group_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tbl_sample_group_references
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_references" ADD CONSTRAINT "pk_sample_group_references" PRIMARY KEY ("sample_group_reference_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_group_sampling_contexts
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_sampling_contexts" ADD CONSTRAINT "pk_sample_group_sampling_contexts" PRIMARY KEY ("sampling_context_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_groups
-- ----------------------------
ALTER TABLE "public"."tbl_sample_groups" ADD CONSTRAINT "pk_sample_groups" PRIMARY KEY ("sample_group_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_horizons
-- ----------------------------
ALTER TABLE "public"."tbl_sample_horizons" ADD CONSTRAINT "pk_sample_horizons" PRIMARY KEY ("sample_horizon_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_images
-- ----------------------------
ALTER TABLE "public"."tbl_sample_images" ADD CONSTRAINT "pk_sample_images" PRIMARY KEY ("sample_image_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_location_type_sampling_contexts
-- ----------------------------
ALTER TABLE "public"."tbl_sample_location_type_sampling_contexts" ADD CONSTRAINT "tbl_sample_location_sampling_contexts_pkey" PRIMARY KEY ("sample_location_type_sampling_context_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_location_types
-- ----------------------------
ALTER TABLE "public"."tbl_sample_location_types" ADD CONSTRAINT "tbl_sample_location_types_pkey" PRIMARY KEY ("sample_location_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_locations
-- ----------------------------
ALTER TABLE "public"."tbl_sample_locations" ADD CONSTRAINT "tbl_sample_locations_pkey" PRIMARY KEY ("sample_location_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_notes
-- ----------------------------
ALTER TABLE "public"."tbl_sample_notes" ADD CONSTRAINT "pk_sample_notes" PRIMARY KEY ("sample_note_id");

-- ----------------------------
-- Primary Key structure for table tbl_sample_types
-- ----------------------------
ALTER TABLE "public"."tbl_sample_types" ADD CONSTRAINT "pk_sample_types" PRIMARY KEY ("sample_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_season_types
-- ----------------------------
ALTER TABLE "public"."tbl_season_types" ADD CONSTRAINT "pk_season_types" PRIMARY KEY ("season_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_seasons
-- ----------------------------
ALTER TABLE "public"."tbl_seasons" ADD CONSTRAINT "pk_seasons" PRIMARY KEY ("season_id");

-- ----------------------------
-- Primary Key structure for table tbl_site_images
-- ----------------------------
ALTER TABLE "public"."tbl_site_images" ADD CONSTRAINT "pk_site_images" PRIMARY KEY ("site_image_id");

-- ----------------------------
-- Primary Key structure for table tbl_site_locations
-- ----------------------------
ALTER TABLE "public"."tbl_site_locations" ADD CONSTRAINT "pk_site_location" PRIMARY KEY ("site_location_id");

-- ----------------------------
-- Primary Key structure for table tbl_site_natgridrefs
-- ----------------------------
ALTER TABLE "public"."tbl_site_natgridrefs" ADD CONSTRAINT "pk_sitenatgridrefs" PRIMARY KEY ("site_natgridref_id");

-- ----------------------------
-- Primary Key structure for table tbl_site_other_records
-- ----------------------------
ALTER TABLE "public"."tbl_site_other_records" ADD CONSTRAINT "pk_site_other_records" PRIMARY KEY ("site_other_records_id");

-- ----------------------------
-- Primary Key structure for table tbl_site_preservation_status
-- ----------------------------
ALTER TABLE "public"."tbl_site_preservation_status" ADD CONSTRAINT "pk_site_preservation_status" PRIMARY KEY ("site_preservation_status_id");

-- ----------------------------
-- Primary Key structure for table tbl_site_references
-- ----------------------------
ALTER TABLE "public"."tbl_site_references" ADD CONSTRAINT "pk_site_references" PRIMARY KEY ("site_reference_id");

-- ----------------------------
-- Primary Key structure for table tbl_sites
-- ----------------------------
ALTER TABLE "public"."tbl_sites" ADD CONSTRAINT "pk_sites" PRIMARY KEY ("site_id");

-- ----------------------------
-- Primary Key structure for table tbl_species_association_types
-- ----------------------------
ALTER TABLE "public"."tbl_species_association_types" ADD CONSTRAINT "tbl_association_types_pkey" PRIMARY KEY ("association_type_id");

-- ----------------------------
-- Primary Key structure for table tbl_species_associations
-- ----------------------------
ALTER TABLE "public"."tbl_species_associations" ADD CONSTRAINT "pk_species_associations" PRIMARY KEY ("species_association_id");

-- ----------------------------
-- Primary Key structure for table tbl_taxa_common_names
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_common_names" ADD CONSTRAINT "pk_taxa_common_names" PRIMARY KEY ("taxon_common_name_id");

-- ----------------------------
-- Primary Key structure for table tbl_taxa_images
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_images" ADD CONSTRAINT "tbl_taxa_images_pkey" PRIMARY KEY ("taxa_images_id");

-- ----------------------------
-- Primary Key structure for table tbl_taxa_measured_attributes
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_measured_attributes" ADD CONSTRAINT "pk_taxa_measured_attributes" PRIMARY KEY ("measured_attribute_id");

-- ----------------------------
-- Primary Key structure for table tbl_taxa_reference_specimens
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_reference_specimens" ADD CONSTRAINT "tbl_taxa_reference_specimens_pkey" PRIMARY KEY ("taxa_reference_specimen_id");

-- ----------------------------
-- Primary Key structure for table tbl_taxa_seasonality
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_seasonality" ADD CONSTRAINT "pk_taxa_seasonality" PRIMARY KEY ("seasonality_id");

-- ----------------------------
-- Primary Key structure for table tbl_taxa_synonyms
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_synonyms" ADD CONSTRAINT "pk_taxa_synonyms" PRIMARY KEY ("synonym_id");

-- ----------------------------
-- Indexes structure for table tbl_taxa_tree_authors
-- ----------------------------
CREATE INDEX "tbl_taxa_tree_authors_name" ON "public"."tbl_taxa_tree_authors" USING btree (
  "author_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tbl_taxa_tree_authors
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_tree_authors" ADD CONSTRAINT "pk_taxa_tree_authors" PRIMARY KEY ("author_id");

-- ----------------------------
-- Indexes structure for table tbl_taxa_tree_families
-- ----------------------------
CREATE INDEX "tbl_taxa_tree_families_name" ON "public"."tbl_taxa_tree_families" USING btree (
  "family_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxa_tree_families_order_id" ON "public"."tbl_taxa_tree_families" USING btree (
  "order_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tbl_taxa_tree_families
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_tree_families" ADD CONSTRAINT "pk_taxa_tree_families" PRIMARY KEY ("family_id");

-- ----------------------------
-- Indexes structure for table tbl_taxa_tree_genera
-- ----------------------------
CREATE INDEX "tbl_taxa_tree_genera_family_id" ON "public"."tbl_taxa_tree_genera" USING btree (
  "family_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxa_tree_genera_name" ON "public"."tbl_taxa_tree_genera" USING btree (
  "genus_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tbl_taxa_tree_genera
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_tree_genera" ADD CONSTRAINT "pk_taxa_tree_genera" PRIMARY KEY ("genus_id");

-- ----------------------------
-- Primary Key structure for table tbl_taxa_tree_master
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_tree_master" ADD CONSTRAINT "pk_taxa_tree_master" PRIMARY KEY ("taxon_id");

-- ----------------------------
-- Indexes structure for table tbl_taxa_tree_orders
-- ----------------------------
CREATE INDEX "tbl_taxa_tree_orders_order_id" ON "public"."tbl_taxa_tree_orders" USING btree (
  "order_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tbl_taxa_tree_orders
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_tree_orders" ADD CONSTRAINT "pk_taxa_tree_orders" PRIMARY KEY ("order_id");

-- ----------------------------
-- Indexes structure for table tbl_taxonomic_order
-- ----------------------------
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

-- ----------------------------
-- Primary Key structure for table tbl_taxonomic_order
-- ----------------------------
ALTER TABLE "public"."tbl_taxonomic_order" ADD CONSTRAINT "pk_taxonomic_order" PRIMARY KEY ("taxonomic_order_id");

-- ----------------------------
-- Indexes structure for table tbl_taxonomic_order_biblio
-- ----------------------------
CREATE INDEX "tbl_taxonomic_order_biblio_biblio_id" ON "public"."tbl_taxonomic_order_biblio" USING btree (
  "biblio_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxonomic_order_biblio_taxonomic_order_biblio_id" ON "public"."tbl_taxonomic_order_biblio" USING btree (
  "taxonomic_order_biblio_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "tbl_taxonomic_order_biblio_taxonomic_order_system_id" ON "public"."tbl_taxonomic_order_biblio" USING btree (
  "taxonomic_order_system_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tbl_taxonomic_order_biblio
-- ----------------------------
ALTER TABLE "public"."tbl_taxonomic_order_biblio" ADD CONSTRAINT "pk_taxonomic_order_biblio" PRIMARY KEY ("taxonomic_order_biblio_id");

-- ----------------------------
-- Indexes structure for table tbl_taxonomic_order_systems
-- ----------------------------
CREATE INDEX "tbl_taxonomic_order_systems_taxonomic_system_id" ON "public"."tbl_taxonomic_order_systems" USING btree (
  "taxonomic_order_system_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tbl_taxonomic_order_systems
-- ----------------------------
ALTER TABLE "public"."tbl_taxonomic_order_systems" ADD CONSTRAINT "pk_taxonomic_order_systems" PRIMARY KEY ("taxonomic_order_system_id");

-- ----------------------------
-- Primary Key structure for table tbl_taxonomy_notes
-- ----------------------------
ALTER TABLE "public"."tbl_taxonomy_notes" ADD CONSTRAINT "pk_taxonomy_notes" PRIMARY KEY ("taxonomy_notes_id");

-- ----------------------------
-- Primary Key structure for table tbl_tephra_dates
-- ----------------------------
ALTER TABLE "public"."tbl_tephra_dates" ADD CONSTRAINT "pk_tephra_dates" PRIMARY KEY ("tephra_date_id");

-- ----------------------------
-- Primary Key structure for table tbl_tephra_refs
-- ----------------------------
ALTER TABLE "public"."tbl_tephra_refs" ADD CONSTRAINT "pk_tephra_refs" PRIMARY KEY ("tephra_ref_id");

-- ----------------------------
-- Primary Key structure for table tbl_tephras
-- ----------------------------
ALTER TABLE "public"."tbl_tephras" ADD CONSTRAINT "pk_tephras" PRIMARY KEY ("tephra_id");

-- ----------------------------
-- Primary Key structure for table tbl_text_biology
-- ----------------------------
ALTER TABLE "public"."tbl_text_biology" ADD CONSTRAINT "pk_text_biology" PRIMARY KEY ("biology_id");

-- ----------------------------
-- Primary Key structure for table tbl_text_distribution
-- ----------------------------
ALTER TABLE "public"."tbl_text_distribution" ADD CONSTRAINT "pk_text_distribution" PRIMARY KEY ("distribution_id");

-- ----------------------------
-- Primary Key structure for table tbl_text_identification_keys
-- ----------------------------
ALTER TABLE "public"."tbl_text_identification_keys" ADD CONSTRAINT "pk_text_identification_keys" PRIMARY KEY ("key_id");

-- ----------------------------
-- Primary Key structure for table tbl_units
-- ----------------------------
ALTER TABLE "public"."tbl_units" ADD CONSTRAINT "pk_units" PRIMARY KEY ("unit_id");

-- ----------------------------
-- Primary Key structure for table tbl_updates_log
-- ----------------------------
ALTER TABLE "public"."tbl_updates_log" ADD CONSTRAINT "pk_updates_log" PRIMARY KEY ("updates_log_id");

-- ----------------------------
-- Primary Key structure for table tbl_years_types
-- ----------------------------
ALTER TABLE "public"."tbl_years_types" ADD CONSTRAINT "tbl_years_types_pkey" PRIMARY KEY ("years_type_id");

-- ----------------------------
-- Foreign Keys structure for table tbl_abundance_elements
-- ----------------------------
ALTER TABLE "public"."tbl_abundance_elements" ADD CONSTRAINT "fk_abundance_elements_record_type_id" FOREIGN KEY ("record_type_id") REFERENCES "public"."tbl_record_types" ("record_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_abundance_ident_levels
-- ----------------------------
ALTER TABLE "public"."tbl_abundance_ident_levels" ADD CONSTRAINT "fk_abundance_ident_levels_abundance_id" FOREIGN KEY ("abundance_id") REFERENCES "public"."tbl_abundances" ("abundance_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_abundance_ident_levels" ADD CONSTRAINT "fk_abundance_ident_levels_identification_level_id" FOREIGN KEY ("identification_level_id") REFERENCES "public"."tbl_identification_levels" ("identification_level_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_abundance_modifications
-- ----------------------------
ALTER TABLE "public"."tbl_abundance_modifications" ADD CONSTRAINT "fk_abundance_modifications_abundance_id" FOREIGN KEY ("abundance_id") REFERENCES "public"."tbl_abundances" ("abundance_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_abundance_modifications" ADD CONSTRAINT "fk_abundance_modifications_modification_type_id" FOREIGN KEY ("modification_type_id") REFERENCES "public"."tbl_modification_types" ("modification_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_abundances
-- ----------------------------
ALTER TABLE "public"."tbl_abundances" ADD CONSTRAINT "fk_abundances_abundance_elements_id" FOREIGN KEY ("abundance_element_id") REFERENCES "public"."tbl_abundance_elements" ("abundance_element_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_abundances" ADD CONSTRAINT "fk_abundances_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_abundances" ADD CONSTRAINT "fk_abundances_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_aggregate_datasets
-- ----------------------------
ALTER TABLE "public"."tbl_aggregate_datasets" ADD CONSTRAINT "fk_aggregate_datasets_aggregate_order_type_id" FOREIGN KEY ("aggregate_order_type_id") REFERENCES "public"."tbl_aggregate_order_types" ("aggregate_order_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_aggregate_datasets" ADD CONSTRAINT "fk_aggregate_datasets_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_aggregate_sample_ages
-- ----------------------------
ALTER TABLE "public"."tbl_aggregate_sample_ages" ADD CONSTRAINT "fk_aggregate_sample_ages_aggregate_dataset_id" FOREIGN KEY ("aggregate_dataset_id") REFERENCES "public"."tbl_aggregate_datasets" ("aggregate_dataset_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_aggregate_sample_ages" ADD CONSTRAINT "fk_aggregate_sample_ages_analysis_entity_age_id" FOREIGN KEY ("analysis_entity_age_id") REFERENCES "public"."tbl_analysis_entity_ages" ("analysis_entity_age_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_aggregate_samples
-- ----------------------------
ALTER TABLE "public"."tbl_aggregate_samples" ADD CONSTRAINT "fk_aggragate_samples_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_aggregate_samples" ADD CONSTRAINT "fk_aggregate_samples_aggregate_dataset_id" FOREIGN KEY ("aggregate_dataset_id") REFERENCES "public"."tbl_aggregate_datasets" ("aggregate_dataset_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_analysis_entities
-- ----------------------------
ALTER TABLE "public"."tbl_analysis_entities" ADD CONSTRAINT "fk_analysis_entities_dataset_id" FOREIGN KEY ("dataset_id") REFERENCES "public"."tbl_datasets" ("dataset_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_analysis_entities" ADD CONSTRAINT "fk_analysis_entities_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_analysis_entity_ages
-- ----------------------------
ALTER TABLE "public"."tbl_analysis_entity_ages" ADD CONSTRAINT "fk_analysis_entity_ages_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_analysis_entity_ages" ADD CONSTRAINT "fk_analysis_entity_ages_chronology_id" FOREIGN KEY ("chronology_id") REFERENCES "public"."tbl_chronologies" ("chronology_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_analysis_entity_dimensions
-- ----------------------------
ALTER TABLE "public"."tbl_analysis_entity_dimensions" ADD CONSTRAINT "fk_analysis_entity_dimensions_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_analysis_entity_dimensions" ADD CONSTRAINT "fk_analysis_entity_dimensions_dimension_id" FOREIGN KEY ("dimension_id") REFERENCES "public"."tbl_dimensions" ("dimension_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_analysis_entity_prep_methods
-- ----------------------------
ALTER TABLE "public"."tbl_analysis_entity_prep_methods" ADD CONSTRAINT "fk_analysis_entity_prep_methods_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_analysis_entity_prep_methods" ADD CONSTRAINT "fk_analysis_entity_prep_methods_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_biblio
-- ----------------------------
ALTER TABLE "public"."tbl_biblio" ADD CONSTRAINT "fk_biblio_collections_or_journals_id" FOREIGN KEY ("collection_or_journal_id") REFERENCES "public"."tbl_collections_or_journals" ("collection_or_journal_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_biblio" ADD CONSTRAINT "fk_biblio_publication_type_id" FOREIGN KEY ("publication_type_id") REFERENCES "public"."tbl_publication_types" ("publication_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_biblio" ADD CONSTRAINT "fk_biblio_publisher_id" FOREIGN KEY ("publisher_id") REFERENCES "public"."tbl_publishers" ("publisher_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_biblio_keywords
-- ----------------------------
ALTER TABLE "public"."tbl_biblio_keywords" ADD CONSTRAINT "fk_biblio_keywords_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_biblio_keywords" ADD CONSTRAINT "fk_biblio_keywords_keyword_id" FOREIGN KEY ("keyword_id") REFERENCES "public"."tbl_keywords" ("keyword_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_ceramics
-- ----------------------------
ALTER TABLE "public"."tbl_ceramics" ADD CONSTRAINT "fk_ceramics_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_ceramics" ADD CONSTRAINT "fk_ceramics_ceramics_measurement_id" FOREIGN KEY ("ceramics_measurement_id") REFERENCES "public"."tbl_ceramics_measurements" ("ceramics_measurement_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_ceramics_measurement_lookup
-- ----------------------------
ALTER TABLE "public"."tbl_ceramics_measurement_lookup" ADD CONSTRAINT "fk_ceramics_measurement_lookup_ceramics_measurements_id" FOREIGN KEY ("ceramics_measurement_id") REFERENCES "public"."tbl_ceramics_measurements" ("ceramics_measurement_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_ceramics_measurements
-- ----------------------------
ALTER TABLE "public"."tbl_ceramics_measurements" ADD CONSTRAINT "fk_ceramics_measurements_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_chron_controls
-- ----------------------------
ALTER TABLE "public"."tbl_chron_controls" ADD CONSTRAINT "fk_chron_controls_chron_control_type_id" FOREIGN KEY ("chron_control_type_id") REFERENCES "public"."tbl_chron_control_types" ("chron_control_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_chron_controls" ADD CONSTRAINT "fk_chron_controls_chronology_id" FOREIGN KEY ("chronology_id") REFERENCES "public"."tbl_chronologies" ("chronology_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_chronologies
-- ----------------------------
ALTER TABLE "public"."tbl_chronologies" ADD CONSTRAINT "fk_chronologies_contact_id" FOREIGN KEY ("contact_id") REFERENCES "public"."tbl_contacts" ("contact_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_chronologies" ADD CONSTRAINT "fk_chronologies_sample_group_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_collections_or_journals
-- ----------------------------
ALTER TABLE "public"."tbl_collections_or_journals" ADD CONSTRAINT "fk_collections_or_journals_publisher_id" FOREIGN KEY ("publisher_id") REFERENCES "public"."tbl_publishers" ("publisher_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_colours
-- ----------------------------
ALTER TABLE "public"."tbl_colours" ADD CONSTRAINT "fk_colours_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_coordinate_method_dimensions
-- ----------------------------
ALTER TABLE "public"."tbl_coordinate_method_dimensions" ADD CONSTRAINT "fk_coordinate_method_dimensions_dimensions_id" FOREIGN KEY ("dimension_id") REFERENCES "public"."tbl_dimensions" ("dimension_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_coordinate_method_dimensions" ADD CONSTRAINT "fk_coordinate_method_dimensions_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_data_types
-- ----------------------------
ALTER TABLE "public"."tbl_data_types" ADD CONSTRAINT "fk_data_types_data_type_group_id" FOREIGN KEY ("data_type_group_id") REFERENCES "public"."tbl_data_type_groups" ("data_type_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_dataset_contacts
-- ----------------------------
ALTER TABLE "public"."tbl_dataset_contacts" ADD CONSTRAINT "fk_dataset_contacts_contact_id" FOREIGN KEY ("contact_id") REFERENCES "public"."tbl_contacts" ("contact_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_dataset_contacts" ADD CONSTRAINT "fk_dataset_contacts_contact_type_id" FOREIGN KEY ("contact_type_id") REFERENCES "public"."tbl_contact_types" ("contact_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_dataset_contacts" ADD CONSTRAINT "fk_dataset_contacts_dataset_id" FOREIGN KEY ("dataset_id") REFERENCES "public"."tbl_datasets" ("dataset_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_dataset_masters
-- ----------------------------
ALTER TABLE "public"."tbl_dataset_masters" ADD CONSTRAINT "fk_dataset_masters_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_dataset_masters" ADD CONSTRAINT "fk_dataset_masters_contact_id" FOREIGN KEY ("contact_id") REFERENCES "public"."tbl_contacts" ("contact_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_dataset_submissions
-- ----------------------------
ALTER TABLE "public"."tbl_dataset_submissions" ADD CONSTRAINT "fk_dataset_submission_submission_type_id" FOREIGN KEY ("submission_type_id") REFERENCES "public"."tbl_dataset_submission_types" ("submission_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_dataset_submissions" ADD CONSTRAINT "fk_dataset_submissions_contact_id" FOREIGN KEY ("contact_id") REFERENCES "public"."tbl_contacts" ("contact_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_dataset_submissions" ADD CONSTRAINT "fk_dataset_submissions_dataset_id" FOREIGN KEY ("dataset_id") REFERENCES "public"."tbl_datasets" ("dataset_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_datasets
-- ----------------------------
ALTER TABLE "public"."tbl_datasets" ADD CONSTRAINT "fk_datasets_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_datasets" ADD CONSTRAINT "fk_datasets_data_type_id" FOREIGN KEY ("data_type_id") REFERENCES "public"."tbl_data_types" ("data_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_datasets" ADD CONSTRAINT "fk_datasets_master_set_id" FOREIGN KEY ("master_set_id") REFERENCES "public"."tbl_dataset_masters" ("master_set_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_datasets" ADD CONSTRAINT "fk_datasets_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_datasets" ADD CONSTRAINT "fk_datasets_project_id" FOREIGN KEY ("project_id") REFERENCES "public"."tbl_projects" ("project_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_datasets" ADD CONSTRAINT "fk_datasets_updated_dataset_id" FOREIGN KEY ("updated_dataset_id") REFERENCES "public"."tbl_datasets" ("dataset_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_dating_labs
-- ----------------------------
ALTER TABLE "public"."tbl_dating_labs" ADD CONSTRAINT "fk_dating_labs_contact_id" FOREIGN KEY ("contact_id") REFERENCES "public"."tbl_contacts" ("contact_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_dating_material
-- ----------------------------
ALTER TABLE "public"."tbl_dating_material" ADD CONSTRAINT "fk_dating_material_abundance_elements_id" FOREIGN KEY ("abundance_element_id") REFERENCES "public"."tbl_abundance_elements" ("abundance_element_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_dating_material" ADD CONSTRAINT "fk_dating_material_geochronology_geochron_id" FOREIGN KEY ("geochron_id") REFERENCES "public"."tbl_geochronology" ("geochron_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_dating_material" ADD CONSTRAINT "fk_dating_material_taxa_tree_master_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_dendro
-- ----------------------------
ALTER TABLE "public"."tbl_dendro" ADD CONSTRAINT "fk_dendro_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_dendro" ADD CONSTRAINT "fk_dendro_dendro_measurement_id" FOREIGN KEY ("dendro_measurement_id") REFERENCES "public"."tbl_dendro_measurements" ("dendro_measurement_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_dendro_date_notes
-- ----------------------------
ALTER TABLE "public"."tbl_dendro_date_notes" ADD CONSTRAINT "fk_dendro_date_notes_dendro_date_id" FOREIGN KEY ("dendro_date_id") REFERENCES "public"."tbl_dendro_dates" ("dendro_date_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_dendro_dates
-- ----------------------------
ALTER TABLE "public"."tbl_dendro_dates" ADD CONSTRAINT "fk_dendro_dates_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_dendro_dates" ADD CONSTRAINT "fk_dendro_dates_dating_uncertainty_id" FOREIGN KEY ("dating_uncertainty_id") REFERENCES "public"."tbl_dating_uncertainty" ("dating_uncertainty_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_dendro_dates" ADD CONSTRAINT "fk_dendro_dates_years_type_id" FOREIGN KEY ("years_type_id") REFERENCES "public"."tbl_years_types" ("years_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_dendro_measurement_lookup
-- ----------------------------
ALTER TABLE "public"."tbl_dendro_measurement_lookup" ADD CONSTRAINT "fk_dendro_measurement_lookup_dendro_measurement_id" FOREIGN KEY ("dendro_measurement_id") REFERENCES "public"."tbl_dendro_measurements" ("dendro_measurement_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_dendro_measurements
-- ----------------------------
ALTER TABLE "public"."tbl_dendro_measurements" ADD CONSTRAINT "fk_dendro_measurements_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_dimensions
-- ----------------------------
ALTER TABLE "public"."tbl_dimensions" ADD CONSTRAINT "fk_dimensions_method_group_id" FOREIGN KEY ("method_group_id") REFERENCES "public"."tbl_method_groups" ("method_group_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_dimensions" ADD CONSTRAINT "fk_dimensions_unit_id" FOREIGN KEY ("unit_id") REFERENCES "public"."tbl_units" ("unit_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_ecocode_definitions
-- ----------------------------
ALTER TABLE "public"."tbl_ecocode_definitions" ADD CONSTRAINT "fk_ecocode_definitions_ecocode_group_id" FOREIGN KEY ("ecocode_group_id") REFERENCES "public"."tbl_ecocode_groups" ("ecocode_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_ecocode_groups
-- ----------------------------
ALTER TABLE "public"."tbl_ecocode_groups" ADD CONSTRAINT "fk_ecocode_groups_ecocode_system_id" FOREIGN KEY ("ecocode_system_id") REFERENCES "public"."tbl_ecocode_systems" ("ecocode_system_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_ecocode_systems
-- ----------------------------
ALTER TABLE "public"."tbl_ecocode_systems" ADD CONSTRAINT "fk_ecocode_systems_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_ecocodes
-- ----------------------------
ALTER TABLE "public"."tbl_ecocodes" ADD CONSTRAINT "fk_ecocodes_ecocodedef_id" FOREIGN KEY ("ecocode_definition_id") REFERENCES "public"."tbl_ecocode_definitions" ("ecocode_definition_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_ecocodes" ADD CONSTRAINT "fk_ecocodes_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_features
-- ----------------------------
ALTER TABLE "public"."tbl_features" ADD CONSTRAINT "fk_feature_type_id_feature_type_id" FOREIGN KEY ("feature_type_id") REFERENCES "public"."tbl_feature_types" ("feature_type_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_geochron_refs
-- ----------------------------
ALTER TABLE "public"."tbl_geochron_refs" ADD CONSTRAINT "fk_geochron_refs_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_geochron_refs" ADD CONSTRAINT "fk_geochron_refs_geochron_id" FOREIGN KEY ("geochron_id") REFERENCES "public"."tbl_geochronology" ("geochron_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_geochronology
-- ----------------------------
ALTER TABLE "public"."tbl_geochronology" ADD CONSTRAINT "fk_geochronology_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_geochronology" ADD CONSTRAINT "fk_geochronology_dating_labs_id" FOREIGN KEY ("dating_lab_id") REFERENCES "public"."tbl_dating_labs" ("dating_lab_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_geochronology" ADD CONSTRAINT "fk_geochronology_dating_uncertainty_id" FOREIGN KEY ("dating_uncertainty_id") REFERENCES "public"."tbl_dating_uncertainty" ("dating_uncertainty_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_horizons
-- ----------------------------
ALTER TABLE "public"."tbl_horizons" ADD CONSTRAINT "fk_horizons_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_imported_taxa_replacements
-- ----------------------------
ALTER TABLE "public"."tbl_imported_taxa_replacements" ADD CONSTRAINT "fk_imported_taxa_replacements_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_lithology
-- ----------------------------
ALTER TABLE "public"."tbl_lithology" ADD CONSTRAINT "fk_lithology_sample_group_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_locations
-- ----------------------------
ALTER TABLE "public"."tbl_locations" ADD CONSTRAINT "fk_locations_location_type_id" FOREIGN KEY ("location_type_id") REFERENCES "public"."tbl_location_types" ("location_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_mcr_names
-- ----------------------------
ALTER TABLE "public"."tbl_mcr_names" ADD CONSTRAINT "fk_mcr_names_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_mcr_summary_data
-- ----------------------------
ALTER TABLE "public"."tbl_mcr_summary_data" ADD CONSTRAINT "fk_mcr_summary_data_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_mcrdata_birmbeetledat
-- ----------------------------
ALTER TABLE "public"."tbl_mcrdata_birmbeetledat" ADD CONSTRAINT "fk_mcrdata_birmbeetledat_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_measured_value_dimensions
-- ----------------------------
ALTER TABLE "public"."tbl_measured_value_dimensions" ADD CONSTRAINT "fk_measured_value_dimensions_dimension_id" FOREIGN KEY ("dimension_id") REFERENCES "public"."tbl_dimensions" ("dimension_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_measured_value_dimensions" ADD CONSTRAINT "fk_measured_weights_value_id" FOREIGN KEY ("measured_value_id") REFERENCES "public"."tbl_measured_values" ("measured_value_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_measured_values
-- ----------------------------
ALTER TABLE "public"."tbl_measured_values" ADD CONSTRAINT "fk_measured_values_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_methods
-- ----------------------------
ALTER TABLE "public"."tbl_methods" ADD CONSTRAINT "fk_methods_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_methods" ADD CONSTRAINT "fk_methods_method_group_id" FOREIGN KEY ("method_group_id") REFERENCES "public"."tbl_method_groups" ("method_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_methods" ADD CONSTRAINT "fk_methods_record_type_id" FOREIGN KEY ("record_type_id") REFERENCES "public"."tbl_record_types" ("record_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_methods" ADD CONSTRAINT "fk_methods_unit_id" FOREIGN KEY ("unit_id") REFERENCES "public"."tbl_units" ("unit_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_physical_sample_features
-- ----------------------------
ALTER TABLE "public"."tbl_physical_sample_features" ADD CONSTRAINT "fk_physical_sample_features_feature_id" FOREIGN KEY ("feature_id") REFERENCES "public"."tbl_features" ("feature_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_physical_sample_features" ADD CONSTRAINT "fk_physical_sample_features_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_physical_samples
-- ----------------------------
ALTER TABLE "public"."tbl_physical_samples" ADD CONSTRAINT "fk_physical_samples_sample_name_type_id" FOREIGN KEY ("alt_ref_type_id") REFERENCES "public"."tbl_alt_ref_types" ("alt_ref_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_physical_samples" ADD CONSTRAINT "fk_physical_samples_sample_type_id" FOREIGN KEY ("sample_type_id") REFERENCES "public"."tbl_sample_types" ("sample_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_physical_samples" ADD CONSTRAINT "fk_samples_sample_group_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_projects
-- ----------------------------
ALTER TABLE "public"."tbl_projects" ADD CONSTRAINT "fk_projects_project_stage_id" FOREIGN KEY ("project_stage_id") REFERENCES "public"."tbl_project_stages" ("project_stage_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_projects" ADD CONSTRAINT "fk_projects_project_type_id" FOREIGN KEY ("project_type_id") REFERENCES "public"."tbl_project_types" ("project_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_rdb
-- ----------------------------
ALTER TABLE "public"."tbl_rdb" ADD CONSTRAINT "fk_rdb_rdb_code_id" FOREIGN KEY ("rdb_code_id") REFERENCES "public"."tbl_rdb_codes" ("rdb_code_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_rdb" ADD CONSTRAINT "fk_rdb_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_rdb" ADD CONSTRAINT "fk_tbl_rdb_tbl_location_id" FOREIGN KEY ("location_id") REFERENCES "public"."tbl_locations" ("location_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_rdb_codes
-- ----------------------------
ALTER TABLE "public"."tbl_rdb_codes" ADD CONSTRAINT "fk_rdb_codes_rdb_system_id" FOREIGN KEY ("rdb_system_id") REFERENCES "public"."tbl_rdb_systems" ("rdb_system_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_rdb_systems
-- ----------------------------
ALTER TABLE "public"."tbl_rdb_systems" ADD CONSTRAINT "fk_rdb_systems_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_rdb_systems" ADD CONSTRAINT "fk_rdb_systems_location_id" FOREIGN KEY ("location_id") REFERENCES "public"."tbl_locations" ("location_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_relative_age_refs
-- ----------------------------
ALTER TABLE "public"."tbl_relative_age_refs" ADD CONSTRAINT "fk_relative_age_refs_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_relative_age_refs" ADD CONSTRAINT "fk_relative_age_refs_relative_age_id" FOREIGN KEY ("relative_age_id") REFERENCES "public"."tbl_relative_ages" ("relative_age_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_relative_ages
-- ----------------------------
ALTER TABLE "public"."tbl_relative_ages" ADD CONSTRAINT "fk_relative_ages_location_id" FOREIGN KEY ("location_id") REFERENCES "public"."tbl_locations" ("location_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_relative_ages" ADD CONSTRAINT "fk_relative_ages_relative_age_type_id" FOREIGN KEY ("relative_age_type_id") REFERENCES "public"."tbl_relative_age_types" ("relative_age_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_relative_dates
-- ----------------------------
ALTER TABLE "public"."tbl_relative_dates" ADD CONSTRAINT "fk_relative_dates_dating_uncertainty_id" FOREIGN KEY ("dating_uncertainty_id") REFERENCES "public"."tbl_dating_uncertainty" ("dating_uncertainty_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_relative_dates" ADD CONSTRAINT "fk_relative_dates_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_relative_dates" ADD CONSTRAINT "fk_relative_dates_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_relative_dates" ADD CONSTRAINT "fk_relative_dates_relative_age_id" FOREIGN KEY ("relative_age_id") REFERENCES "public"."tbl_relative_ages" ("relative_age_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_alt_refs
-- ----------------------------
ALTER TABLE "public"."tbl_sample_alt_refs" ADD CONSTRAINT "fk_sample_alt_refs_alt_ref_type_id" FOREIGN KEY ("alt_ref_type_id") REFERENCES "public"."tbl_alt_ref_types" ("alt_ref_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_alt_refs" ADD CONSTRAINT "fk_sample_alt_refs_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_colours
-- ----------------------------
ALTER TABLE "public"."tbl_sample_colours" ADD CONSTRAINT "fk_sample_colours_colour_id" FOREIGN KEY ("colour_id") REFERENCES "public"."tbl_colours" ("colour_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_colours" ADD CONSTRAINT "fk_sample_colours_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_coordinates
-- ----------------------------
ALTER TABLE "public"."tbl_sample_coordinates" ADD CONSTRAINT "fk_sample_coordinates_coordinate_method_dimension_id" FOREIGN KEY ("coordinate_method_dimension_id") REFERENCES "public"."tbl_coordinate_method_dimensions" ("coordinate_method_dimension_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_coordinates" ADD CONSTRAINT "fk_sample_coordinates_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_description_sample_group_contexts
-- ----------------------------
ALTER TABLE "public"."tbl_sample_description_sample_group_contexts" ADD CONSTRAINT "fk_sample_description_sample_group_contexts_sampling_context_id" FOREIGN KEY ("sampling_context_id") REFERENCES "public"."tbl_sample_group_sampling_contexts" ("sampling_context_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_sample_description_sample_group_contexts" ADD CONSTRAINT "fk_sample_description_types_sample_group_context_id" FOREIGN KEY ("sample_description_type_id") REFERENCES "public"."tbl_sample_description_types" ("sample_description_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_descriptions
-- ----------------------------
ALTER TABLE "public"."tbl_sample_descriptions" ADD CONSTRAINT "fk_sample_descriptions_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_sample_descriptions" ADD CONSTRAINT "fk_sample_descriptions_sample_description_type_id" FOREIGN KEY ("sample_description_type_id") REFERENCES "public"."tbl_sample_description_types" ("sample_description_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_dimensions
-- ----------------------------
ALTER TABLE "public"."tbl_sample_dimensions" ADD CONSTRAINT "fk_sample_dimensions_dimension_id" FOREIGN KEY ("dimension_id") REFERENCES "public"."tbl_dimensions" ("dimension_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_dimensions" ADD CONSTRAINT "fk_sample_dimensions_measurement_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_dimensions" ADD CONSTRAINT "fk_sample_dimensions_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_group_coordinates
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_coordinates" ADD CONSTRAINT "fk_sample_group_positions_coordinate_method_dimension_id" FOREIGN KEY ("coordinate_method_dimension_id") REFERENCES "public"."tbl_coordinate_method_dimensions" ("coordinate_method_dimension_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_group_coordinates" ADD CONSTRAINT "fk_sample_group_positions_sample_group_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_group_description_type_sampling_contexts
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_description_type_sampling_contexts" ADD CONSTRAINT "fk_sample_group_description_type_sampling_context_id" FOREIGN KEY ("sample_group_description_type_id") REFERENCES "public"."tbl_sample_group_description_types" ("sample_group_description_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_sample_group_description_type_sampling_contexts" ADD CONSTRAINT "fk_sample_group_sampling_context_id0" FOREIGN KEY ("sampling_context_id") REFERENCES "public"."tbl_sample_group_sampling_contexts" ("sampling_context_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_group_descriptions
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_descriptions" ADD CONSTRAINT "fk_sample_group_descriptions_sample_group_description_type_id" FOREIGN KEY ("sample_group_description_type_id") REFERENCES "public"."tbl_sample_group_description_types" ("sample_group_description_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_group_descriptions" ADD CONSTRAINT "fk_sample_groups_sample_group_descriptions_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_group_dimensions
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_dimensions" ADD CONSTRAINT "fk_sample_group_dimensions_dimension_id" FOREIGN KEY ("dimension_id") REFERENCES "public"."tbl_dimensions" ("dimension_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_group_dimensions" ADD CONSTRAINT "fk_sample_group_dimensions_sample_group_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_group_images
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_images" ADD CONSTRAINT "fk_sample_group_images_image_type_id" FOREIGN KEY ("image_type_id") REFERENCES "public"."tbl_image_types" ("image_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_group_images" ADD CONSTRAINT "fk_sample_group_images_sample_group_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_group_notes
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_notes" ADD CONSTRAINT "fk_tbl_sample_group_notes_sample_groups" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_group_references
-- ----------------------------
ALTER TABLE "public"."tbl_sample_group_references" ADD CONSTRAINT "fk_sample_group_references_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_group_references" ADD CONSTRAINT "fk_sample_group_references_sample_group_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_groups
-- ----------------------------
ALTER TABLE "public"."tbl_sample_groups" ADD CONSTRAINT "fk_sample_group_sampling_context_id" FOREIGN KEY ("sampling_context_id") REFERENCES "public"."tbl_sample_group_sampling_contexts" ("sampling_context_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_groups" ADD CONSTRAINT "fk_sample_groups_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_groups" ADD CONSTRAINT "fk_sample_groups_site_id" FOREIGN KEY ("site_id") REFERENCES "public"."tbl_sites" ("site_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_horizons
-- ----------------------------
ALTER TABLE "public"."tbl_sample_horizons" ADD CONSTRAINT "fk_sample_horizons_horizon_id" FOREIGN KEY ("horizon_id") REFERENCES "public"."tbl_horizons" ("horizon_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_horizons" ADD CONSTRAINT "fk_sample_horizons_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_images
-- ----------------------------
ALTER TABLE "public"."tbl_sample_images" ADD CONSTRAINT "fk_sample_images_image_type_id" FOREIGN KEY ("image_type_id") REFERENCES "public"."tbl_image_types" ("image_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_images" ADD CONSTRAINT "fk_sample_images_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_location_type_sampling_contexts
-- ----------------------------
ALTER TABLE "public"."tbl_sample_location_type_sampling_contexts" ADD CONSTRAINT "fk_sample_location_sampling_contexts_sampling_context_id" FOREIGN KEY ("sample_location_type_id") REFERENCES "public"."tbl_sample_location_types" ("sample_location_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_sample_location_type_sampling_contexts" ADD CONSTRAINT "fk_sample_location_type_sampling_context_id" FOREIGN KEY ("sampling_context_id") REFERENCES "public"."tbl_sample_group_sampling_contexts" ("sampling_context_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_locations
-- ----------------------------
ALTER TABLE "public"."tbl_sample_locations" ADD CONSTRAINT "fk_sample_locations_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_sample_locations" ADD CONSTRAINT "fk_sample_locations_sample_location_type_id" FOREIGN KEY ("sample_location_type_id") REFERENCES "public"."tbl_sample_location_types" ("sample_location_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_sample_notes
-- ----------------------------
ALTER TABLE "public"."tbl_sample_notes" ADD CONSTRAINT "fk_sample_notes_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_seasons
-- ----------------------------
ALTER TABLE "public"."tbl_seasons" ADD CONSTRAINT "fk_seasons_season_type_id" FOREIGN KEY ("season_type_id") REFERENCES "public"."tbl_season_types" ("season_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_site_images
-- ----------------------------
ALTER TABLE "public"."tbl_site_images" ADD CONSTRAINT "fk_site_images_contact_id" FOREIGN KEY ("contact_id") REFERENCES "public"."tbl_contacts" ("contact_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_site_images" ADD CONSTRAINT "fk_site_images_image_type_id" FOREIGN KEY ("image_type_id") REFERENCES "public"."tbl_image_types" ("image_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_site_images" ADD CONSTRAINT "fk_site_images_site_id" FOREIGN KEY ("site_id") REFERENCES "public"."tbl_sites" ("site_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_site_locations
-- ----------------------------
ALTER TABLE "public"."tbl_site_locations" ADD CONSTRAINT "fk_locations_location_id" FOREIGN KEY ("location_id") REFERENCES "public"."tbl_locations" ("location_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_site_locations" ADD CONSTRAINT "fk_locations_site_id" FOREIGN KEY ("site_id") REFERENCES "public"."tbl_sites" ("site_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_site_natgridrefs
-- ----------------------------
ALTER TABLE "public"."tbl_site_natgridrefs" ADD CONSTRAINT "fk_site_natgridrefs_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_site_natgridrefs" ADD CONSTRAINT "fk_site_natgridrefs_sites_id" FOREIGN KEY ("site_id") REFERENCES "public"."tbl_sites" ("site_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_site_other_records
-- ----------------------------
ALTER TABLE "public"."tbl_site_other_records" ADD CONSTRAINT "fk_site_other_records_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_site_other_records" ADD CONSTRAINT "fk_site_other_records_record_type_id" FOREIGN KEY ("record_type_id") REFERENCES "public"."tbl_record_types" ("record_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_site_other_records" ADD CONSTRAINT "fk_site_other_records_site_id" FOREIGN KEY ("site_id") REFERENCES "public"."tbl_sites" ("site_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_site_preservation_status
-- ----------------------------
ALTER TABLE "public"."tbl_site_preservation_status" ADD CONSTRAINT "fk_site_preservation_status_site_id " FOREIGN KEY ("site_id") REFERENCES "public"."tbl_sites" ("site_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_site_references
-- ----------------------------
ALTER TABLE "public"."tbl_site_references" ADD CONSTRAINT "fk_site_references_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_site_references" ADD CONSTRAINT "fk_site_references_site_id" FOREIGN KEY ("site_id") REFERENCES "public"."tbl_sites" ("site_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_species_associations
-- ----------------------------
ALTER TABLE "public"."tbl_species_associations" ADD CONSTRAINT "fk_species_associations_associated_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_species_associations" ADD CONSTRAINT "fk_species_associations_association_type_id" FOREIGN KEY ("association_type_id") REFERENCES "public"."tbl_species_association_types" ("association_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_species_associations" ADD CONSTRAINT "fk_species_associations_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_species_associations" ADD CONSTRAINT "fk_species_associations_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_taxa_common_names
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_common_names" ADD CONSTRAINT "fk_taxa_common_names_language_id" FOREIGN KEY ("language_id") REFERENCES "public"."tbl_languages" ("language_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxa_common_names" ADD CONSTRAINT "fk_taxa_common_names_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_taxa_images
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_images" ADD CONSTRAINT "fk_taxa_images_image_type_id" FOREIGN KEY ("image_type_id") REFERENCES "public"."tbl_image_types" ("image_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_taxa_images" ADD CONSTRAINT "fk_taxa_images_taxa_tree_master_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_taxa_measured_attributes
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_measured_attributes" ADD CONSTRAINT "fk_taxa_measured_attributes_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_taxa_reference_specimens
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_reference_specimens" ADD CONSTRAINT "fk_taxa_reference_specimens_contact_id" FOREIGN KEY ("contact_id") REFERENCES "public"."tbl_contacts" ("contact_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_taxa_reference_specimens" ADD CONSTRAINT "fk_taxa_reference_specimens_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_taxa_seasonality
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_seasonality" ADD CONSTRAINT "fk_taxa_seasonality_activity_type_id" FOREIGN KEY ("activity_type_id") REFERENCES "public"."tbl_activity_types" ("activity_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxa_seasonality" ADD CONSTRAINT "fk_taxa_seasonality_location_id" FOREIGN KEY ("location_id") REFERENCES "public"."tbl_locations" ("location_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_taxa_seasonality" ADD CONSTRAINT "fk_taxa_seasonality_season_id" FOREIGN KEY ("season_id") REFERENCES "public"."tbl_seasons" ("season_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxa_seasonality" ADD CONSTRAINT "fk_taxa_seasonality_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_taxa_synonyms
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_synonyms" ADD CONSTRAINT "fk_taxa_synonyms_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxa_synonyms" ADD CONSTRAINT "fk_taxa_synonyms_family_id" FOREIGN KEY ("family_id") REFERENCES "public"."tbl_taxa_tree_families" ("family_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxa_synonyms" ADD CONSTRAINT "fk_taxa_synonyms_genus_id" FOREIGN KEY ("genus_id") REFERENCES "public"."tbl_taxa_tree_genera" ("genus_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxa_synonyms" ADD CONSTRAINT "fk_taxa_synonyms_taxa_tree_author_id" FOREIGN KEY ("author_id") REFERENCES "public"."tbl_taxa_tree_authors" ("author_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_taxa_synonyms" ADD CONSTRAINT "fk_taxa_synonyms_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_taxa_tree_families
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_tree_families" ADD CONSTRAINT "fk_taxa_tree_families_order_id" FOREIGN KEY ("order_id") REFERENCES "public"."tbl_taxa_tree_orders" ("order_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_taxa_tree_genera
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_tree_genera" ADD CONSTRAINT "fk_taxa_tree_genera_family_id" FOREIGN KEY ("family_id") REFERENCES "public"."tbl_taxa_tree_families" ("family_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_taxa_tree_master
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_tree_master" ADD CONSTRAINT "fk_taxa_tree_master_author_id" FOREIGN KEY ("author_id") REFERENCES "public"."tbl_taxa_tree_authors" ("author_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxa_tree_master" ADD CONSTRAINT "fk_taxa_tree_master_genus_id" FOREIGN KEY ("genus_id") REFERENCES "public"."tbl_taxa_tree_genera" ("genus_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_taxa_tree_orders
-- ----------------------------
ALTER TABLE "public"."tbl_taxa_tree_orders" ADD CONSTRAINT "fk_taxa_tree_orders_record_type_id" FOREIGN KEY ("record_type_id") REFERENCES "public"."tbl_record_types" ("record_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_taxonomic_order
-- ----------------------------
ALTER TABLE "public"."tbl_taxonomic_order" ADD CONSTRAINT "fk_taxonomic_order_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxonomic_order" ADD CONSTRAINT "fk_taxonomic_order_taxonomic_order_system_id" FOREIGN KEY ("taxonomic_order_system_id") REFERENCES "public"."tbl_taxonomic_order_systems" ("taxonomic_order_system_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_taxonomic_order_biblio
-- ----------------------------
ALTER TABLE "public"."tbl_taxonomic_order_biblio" ADD CONSTRAINT "fk_taxonomic_order_biblio_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxonomic_order_biblio" ADD CONSTRAINT "fk_taxonomic_order_biblio_taxonomic_order_system_id" FOREIGN KEY ("taxonomic_order_system_id") REFERENCES "public"."tbl_taxonomic_order_systems" ("taxonomic_order_system_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_taxonomy_notes
-- ----------------------------
ALTER TABLE "public"."tbl_taxonomy_notes" ADD CONSTRAINT "fk_taxonomy_notes_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxonomy_notes" ADD CONSTRAINT "fk_taxonomy_notes_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_tephra_dates
-- ----------------------------
ALTER TABLE "public"."tbl_tephra_dates" ADD CONSTRAINT "fk_tephra_dates_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_tephra_dates" ADD CONSTRAINT "fk_tephra_dates_dating_uncertainty_id" FOREIGN KEY ("dating_uncertainty_id") REFERENCES "public"."tbl_dating_uncertainty" ("dating_uncertainty_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_tephra_dates" ADD CONSTRAINT "fk_tephra_dates_tephra_id" FOREIGN KEY ("tephra_id") REFERENCES "public"."tbl_tephras" ("tephra_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_tephra_refs
-- ----------------------------
ALTER TABLE "public"."tbl_tephra_refs" ADD CONSTRAINT "fk_tephra_refs_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_tephra_refs" ADD CONSTRAINT "fk_tephra_refs_tephra_id" FOREIGN KEY ("tephra_id") REFERENCES "public"."tbl_tephras" ("tephra_id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_text_biology
-- ----------------------------
ALTER TABLE "public"."tbl_text_biology" ADD CONSTRAINT "fk_text_biology_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_text_biology" ADD CONSTRAINT "fk_text_biology_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_text_distribution
-- ----------------------------
ALTER TABLE "public"."tbl_text_distribution" ADD CONSTRAINT "fk_text_distribution_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_text_distribution" ADD CONSTRAINT "fk_text_distribution_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_text_identification_keys
-- ----------------------------
ALTER TABLE "public"."tbl_text_identification_keys" ADD CONSTRAINT "fk_text_identification_keys_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_text_identification_keys" ADD CONSTRAINT "fk_text_identification_keys_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;
