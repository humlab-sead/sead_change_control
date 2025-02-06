CREATE TABLE "public"."tbl_abundance_elements" (
  "abundance_element_id" serial primary key,
  "record_type_id" int4,
  "element_name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "element_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_abundance_ident_levels" (
  "abundance_ident_level_id" serial primary key,
  "abundance_id" bigint NOT NULL,
  "identification_level_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_abundance_modifications" (
  "abundance_modification_id" serial primary key,
  "abundance_id" int4 NOT NULL,
  "modification_type_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_abundances" (
  "abundance_id" bigserial primary key,
  "taxon_id" int4 NOT NULL,
  "analysis_entity_id" bigint NOT NULL,
  "abundance_element_id" int4,
  "abundance" int4 NOT NULL DEFAULT 0,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_activity_types" (
  "activity_type_id" serial primary key,
  "activity_type" varchar(50) unique  COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_aggregate_datasets" (
  "aggregate_dataset_id" serial primary key,
  "aggregate_order_type_id" int4 NOT NULL,
  "biblio_id" int4,
  "aggregate_dataset_name" varchar(255) COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_aggregate_order_types" (
  "aggregate_order_type_id" serial primary key,
  "aggregate_order_type" varchar(60) unique  COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_aggregate_sample_ages" (
  "aggregate_sample_age_id" serial primary key,
  "aggregate_dataset_id" int4 NOT NULL,
  "analysis_entity_age_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_aggregate_samples" (
  "aggregate_sample_id" serial primary key,
  "aggregate_dataset_id" int4 NOT NULL,
  "analysis_entity_id" bigint NOT NULL,
  "aggregate_sample_name" varchar(50) COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_alt_ref_types" (
  "alt_ref_type_id" serial primary key,
  "alt_ref_type" varchar(50) unique COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_analysis_entities" (
  "analysis_entity_id" bigserial primary key,
  "physical_sample_id" int4,
  "dataset_id" int4,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_analysis_entity_ages" (
  "analysis_entity_age_id" serial primary key,
  "age" numeric(20, 5),
  "age_older" numeric(20, 5),
  "age_younger" numeric(20, 5),
  "analysis_entity_id" bigint,
  "chronology_id" int4,
  "date_updated" timestamp with time zone DEFAULT now(),
  "dating_specifier" text,
  "age_range" int4range null
      generated always as (
          case when age_younger is null and age_older is null then null
          else int4range(
              coalesce(age_younger::int, age_older::int),
              coalesce(age_older::int, age_younger::int) + 1
          )
        end) stored
);
CREATE TABLE "public"."tbl_analysis_entity_dimensions" (
  "analysis_entity_dimension_id" serial primary key,
  "analysis_entity_id" bigint NOT NULL,
  "dimension_id" int4 NOT NULL,
  "dimension_value" numeric NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_analysis_entity_prep_methods" (
  "analysis_entity_prep_method_id" serial primary key,
  "analysis_entity_id" bigint NOT NULL,
  "method_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_biblio" (
  "biblio_id" serial primary key,
  "author" varchar COLLATE "pg_catalog"."default",
  "biblio_keyword_id" int4,
  "bugs_author" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "bugs_biblio_id" int4,
  "bugs_reference" varchar(60) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "bugs_title" varchar COLLATE "pg_catalog"."default",
  "collection_or_journal_id" int4,
  "date_updated" timestamp with time zone DEFAULT now(),
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
);
CREATE TABLE "public"."tbl_biblio_keywords" (
  "biblio_keyword_id" serial primary key,
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "keyword_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_ceramics" (
  "ceramics_id" serial primary key,
  "analysis_entity_id" bigint NOT NULL,
  "ceramics_measurement_id" int4 NOT NULL,
  "measurement_value" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_ceramics_measurement_lookup" (
  "ceramics_measurement_lookup_id" serial primary key,
  "ceramics_measurement_id" int4 NOT NULL,
  "value" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_ceramics_measurements" (
  "ceramics_measurement_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "method_id" int4
);
CREATE TABLE "public"."tbl_chron_control_types" (
  "chron_control_type_id" serial primary key,
  "chron_control_type" varchar(50) COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_chron_controls" (
  "chron_control_id" serial primary key,
  "age" numeric(20, 5),
  "age_limit_older" numeric(20, 5),
  "age_limit_younger" numeric(20, 5),
  "chron_control_type_id" int4,
  "chronology_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "depth_bottom" numeric(20, 5),
  "depth_top" numeric(20, 5),
  "notes" text COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_chronologies" (
  "chronology_id" serial primary key,
  "age_model" text COLLATE "pg_catalog"."default",
  "relative_age_type_id" int4,
  "chronology_name" text unique COLLATE "pg_catalog"."default",
  "contact_id" int4,
  "date_prepared" timestamp(0),
  "date_updated" timestamp with time zone DEFAULT now(),
  "notes" text COLLATE "pg_catalog"."default",
);
CREATE TABLE "public"."tbl_collections_or_journals" (
  "collection_or_journal_id" serial primary key,
  "collection_or_journal_abbrev" varchar(128) COLLATE "pg_catalog"."default",
  "collection_title_or_journal_name" varchar COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now(),
  "issn" varchar(128) COLLATE "pg_catalog"."default",
  "number_of_volumes" varchar(50) COLLATE "pg_catalog"."default",
  "publisher_id" int4,
  "series_editor" varchar COLLATE "pg_catalog"."default",
  "series_title" varchar COLLATE "pg_catalog"."default",
  "volume_editor" varchar COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_colours" (
  "colour_id" serial primary key,
  "colour_name" varchar(30) unique COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "method_id" int4 NOT NULL,
  "rgb" int4
);
CREATE TABLE "public"."tbl_contact_types" (
  "contact_type_id" serial primary key,
  "contact_type_name" varchar(150) COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_contacts" (
  "contact_id" serial primary key,
  "address_1" varchar(255) COLLATE "pg_catalog"."default",
  "address_2" varchar(255) COLLATE "pg_catalog"."default",
  "location_id" int4,
  "email" varchar COLLATE "pg_catalog"."default",
  "first_name" varchar(50) COLLATE "pg_catalog"."default",
  "last_name" varchar(100) COLLATE "pg_catalog"."default",
  "phone_number" varchar(50) COLLATE "pg_catalog"."default",
  "url" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_coordinate_method_dimensions" (
  "coordinate_method_dimension_id" serial primary key,
  "dimension_id" int4 NOT NULL,
  "method_id" int4 NOT NULL,
  "limit_upper" numeric(18, 10),
  "limit_lower" numeric(18, 10),
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_data_type_groups" (
  "data_type_group_id" serial primary key,
  "data_type_group_name" varchar(25) unique COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_data_types" (
  "data_type_id" serial primary key,
  "data_type_group_id" int4 NOT NULL,
  "data_type_name" varchar(25) unique COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "date_updated" timestamp with time zone DEFAULT now(),
  "definition" text COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_dataset_contacts" (
  "dataset_contact_id" serial primary key,
  "contact_id" int4 NOT NULL,
  "contact_type_id" int4 NOT NULL,
  "dataset_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_dataset_masters" (
  "master_set_id" serial primary key,
  "contact_id" int4,
  "biblio_id" int4,
  "master_name" varchar(100) unique COLLATE "pg_catalog"."default",
  "master_notes" text COLLATE "pg_catalog"."default",
  "url" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_dataset_submission_types" (
  "submission_type_id" serial primary key,
  "submission_type" varchar(60) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_dataset_submissions" (
  "dataset_submission_id" serial primary key,
  "dataset_id" int4 NOT NULL,
  "submission_type_id" int4 NOT NULL,
  "contact_id" int4 NOT NULL,
  "date_submitted" text NULL,
  "notes" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_datasets" (
  "dataset_id" serial primary key,
  "master_set_id" int4,
  "data_type_id" int4 NOT NULL,
  "method_id" int4,
  "biblio_id" int4,
  "updated_dataset_id" int4,
  "project_id" int4,
  "dataset_name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_dating_labs" (
  "dating_lab_id" serial primary key,
  "contact_id" int4,
  "international_lab_id" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  "lab_name" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "country_id" int4,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_dating_material" (
  "dating_material_id" serial primary key,
  "geochron_id" int4 NOT NULL,
  "taxon_id" int4,
  "material_dated" varchar COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "abundance_element_id" int4,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_dating_uncertainty" (
  "dating_uncertainty_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "uncertainty" varchar unique COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_dendro_lookup" (
    "dendro_lookup_id" serial primary key,
    "method_id" int4,
    "name" varchar collate "pg_catalog"."default" not null,
    "description" text collate "pg_catalog"."default",
    "date_updated" timestamp with time zone default now()
);
CREATE TABLE "public"."tbl_dendro" (
    "dendro_id" serial primary key,
    "analysis_entity_id" integer not null,
    "measurement_value" character varying collate pg_catalog."default" not null,
    "date_updated" timestamp with time zone default now(),
    "dendro_lookup_id" integer not null
);
CREATE TABLE "public"."tbl_age_types" (
    "age_type_id" serial primary key,
    "age_type" character varying(150) not null,
    "description" text,
    "date_updated" timestamp with time zone default now()
);
CREATE TABLE "public"."tbl_dendro_dates"
(
    "dendro_date_id" serial primary key,
    "season_id" integer,
    "dating_uncertainty_id" integer,
    "dendro_lookup_id" integer not null,
    "age_type_id" integer not null,
    "analysis_entity_id" integer not null,
    "age_older" integer,
    "age_younger" integer,
    "date_updated" timestamp with time zone default now(),
	  "age_range" int4range null
        generated always as (
            case when age_younger is null and age_older is null then null
            else int4range(
                coalesce(age_older::int, age_younger::int),
                coalesce(age_younger::int, age_older::int) + 1
            )
          end) stored
);
CREATE TABLE "public"."tbl_dendro_date_notes"
(
    "dendro_date_note_id" serial primary key,
    "dendro_date_id" integer not null,
    "note" text collate pg_catalog."default",
    "date_updated" timestamp with time zone default now()
);
CREATE TABLE "public"."tbl_dimensions" (
  "dimension_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "dimension_abbrev" varchar(40) COLLATE "pg_catalog"."default",
  "dimension_description" text COLLATE "pg_catalog"."default",
  "dimension_name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "unit_id" int4,
  "method_group_id" int4
);
CREATE TABLE "public"."tbl_ecocode_definitions" (
  "ecocode_definition_id" serial primary key,
  "abbreviation" varchar(10) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "date_updated" timestamp with time zone DEFAULT now(),
  "definition" text COLLATE "pg_catalog"."default",
  "ecocode_group_id" int4 DEFAULT 0,
  "name" varchar(150) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "notes" text COLLATE "pg_catalog"."default",
  "sort_order" int2 DEFAULT 0
);
CREATE TABLE "public"."tbl_ecocode_groups" (
  "ecocode_group_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "definition" text COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "ecocode_system_id" int4 DEFAULT 0,
  "name" varchar(150) unique COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "abbreviation" varchar(255) COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_ecocode_systems" (
  "ecocode_system_id" serial primary key,
  "biblio_id" int4,
  "date_updated" timestamp with time zone DEFAULT now(),
  "definition" text COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "name" varchar(50) unique COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "notes" text COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_ecocodes" (
  "ecocode_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "ecocode_definition_id" int4 DEFAULT 0,
  "taxon_id" int4 DEFAULT 0
);
CREATE TABLE "public"."tbl_feature_types" (
  "feature_type_id" serial primary key,
  "feature_type_name" varchar(128) COLLATE "pg_catalog"."default",
  "feature_type_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_features" (
  "feature_id" serial primary key,
  "feature_type_id" int4 NOT NULL,
  "feature_name" varchar COLLATE "pg_catalog"."default",
  "feature_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_geochron_refs" (
  "geochron_ref_id" serial primary key,
  "geochron_id" int4 NOT NULL,
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_geochronology" (
  "geochron_id" serial primary key,
  "analysis_entity_id" bigint NOT NULL,
  "dating_lab_id" int4,
  "lab_number" varchar(40) COLLATE "pg_catalog"."default",
  "age" numeric(20, 5),
  "error_older" numeric(20, 5),
  "error_younger" numeric(20, 5),
  "delta_13c" numeric(10, 5),
  "notes" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now(),
  "dating_uncertainty_id" int4
);
CREATE TABLE "public"."tbl_horizons" (
  "horizon_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "horizon_name" varchar(15) COLLATE "pg_catalog"."default" NOT NULL,
  "method_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_identification_levels" (
  "identification_level_id" serial primary key,
  "identification_level_abbrev" varchar(50)  COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "identification_level_name" varchar(50)  unique COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "notes" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_image_types" (
  "image_type_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "image_type" varchar(40) unique COLLATE "pg_catalog"."default" NOT NULL
);
CREATE TABLE "public"."tbl_imported_taxa_replacements" (
  "imported_taxa_replacement_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "imported_name_replaced" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "taxon_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_keywords" (
  "keyword_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "definition" text COLLATE "pg_catalog"."default",
  "keyword" varchar COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_languages" (
  "language_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "language_name_english" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "language_name_native" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
);
CREATE TABLE "public"."tbl_lithology" (
  "lithology_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "depth_bottom" numeric(20, 5),
  "depth_top" numeric(20, 5) NOT NULL,
  "description" text COLLATE "pg_catalog"."default" NOT NULL,
  "lower_boundary" varchar(255) COLLATE "pg_catalog"."default",
  "sample_group_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_location_types" (
  "location_type_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "location_type" varchar(40) unique COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_locations" (
  "location_id" serial primary key,
  "location_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "location_type_id" int4 NOT NULL,
  "default_lat_dd" numeric(18, 10),
  "default_long_dd" numeric(18, 10),
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_mcr_names" (
  "taxon_id" serial primary key,
  "comparison_notes" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "date_updated" timestamp with time zone DEFAULT now(),
  "mcr_name_trim" varchar(80) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "mcr_number" int2 DEFAULT 0,
  "mcr_species_name" varchar(200) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
);
CREATE TABLE "public"."tbl_mcr_summary_data" (
  "mcr_summary_data_id" serial primary key,
  "cog_mid_tmax" int2 DEFAULT 0,
  "cog_mid_trange" int2 DEFAULT 0,
  "date_updated" timestamp with time zone DEFAULT now(),
  "taxon_id" int4 NOT NULL,
  "tmax_hi" int2 DEFAULT 0,
  "tmax_lo" int2 DEFAULT 0,
  "tmin_hi" int2 DEFAULT 0,
  "tmin_lo" int2 DEFAULT 0,
  "trange_hi" int2 DEFAULT 0,
  "trange_lo" int2 DEFAULT 0
);
CREATE TABLE "public"."tbl_mcrdata_birmbeetledat" (
  "mcrdata_birmbeetledat_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "mcr_data" text COLLATE "pg_catalog"."default",
  "mcr_row" int2 NOT NULL,
  "taxon_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_measured_value_dimensions" (
  "measured_value_dimension_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "dimension_id" int4 NOT NULL,
  "dimension_value" numeric(18, 10) NOT NULL,
  "measured_value_id" bigint NOT NULL
);
CREATE TABLE "public"."tbl_measured_values" (
  "measured_value_id" bigserial primary key,
  "analysis_entity_id" bigint NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "measured_value" numeric(20, 10) NOT NULL
);
CREATE TABLE "public"."tbl_method_groups" (
  "method_group_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default" NOT NULL,
  "group_name" varchar(100) unique COLLATE "pg_catalog"."default" NOT NULL
);
CREATE TABLE "public"."tbl_methods" (
  "method_id" serial primary key,
  "biblio_id" int4,
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default" NOT NULL,
  "method_abbrev_or_alt_name" varchar(50) unique COLLATE "pg_catalog"."default",
  "method_group_id" int4 NOT NULL,
  "method_name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "record_type_id" int4,
  "unit_id" int4
);
CREATE TABLE "public"."tbl_modification_types" (
  "modification_type_id" serial primary key,
  "modification_type_name" varchar(128) unique COLLATE "pg_catalog"."default",
  "modification_type_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_physical_sample_features" (
  "physical_sample_feature_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "feature_id" int4 NOT NULL,
  "physical_sample_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_physical_samples" (
  "physical_sample_id" serial primary key,
  "sample_group_id" int4 NOT NULL DEFAULT 0,
  "alt_ref_type_id" int4,
  "sample_type_id" int4 NOT NULL,
  "sample_name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "date_sampled" varchar COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_project_stages" (
  "project_stage_id" serial primary key,
  "stage_name" varchar unique COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_project_types" (
  "project_type_id" serial primary key,
  "project_type_name" varchar unique COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_projects" (
  "project_id" serial primary key,
  "project_type_id" int4,
  "project_stage_id" int4,
  "project_name" varchar(150) COLLATE "pg_catalog"."default",
  "project_abbrev_name" varchar(25) COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_publication_types" (
  "publication_type_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "publication_type" varchar(30) COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_publishers" (
  "publisher_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "place_of_publishing_house" varchar COLLATE "pg_catalog"."default",
  "publisher_name" varchar(255) COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_radiocarbon_calibration" (
  "radiocarbon_calibration_id" serial primary key,
  "c14_yr_bp" int4 NOT NULL,
  "cal_yr_bp" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_rdb" (
  "rdb_id" serial primary key,
  "location_id" int4 NOT NULL,
  "rdb_code_id" int4,
  "taxon_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_rdb_codes" (
  "rdb_code_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "rdb_category" varchar(4) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "rdb_definition" varchar(200) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "rdb_system_id" int4 DEFAULT 0
);
CREATE TABLE "public"."tbl_rdb_systems" (
  "rdb_system_id" serial primary key,
  "biblio_id" int4 NOT NULL,
  "location_id" int4 NOT NULL,
  "rdb_first_published" int2,
  "rdb_system" varchar(10) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "rdb_system_date" int4,
  "rdb_version" varchar(10) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_record_types" (
  "record_type_id" serial primary key,
  "record_type_name" varchar(50) unique COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "record_type_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_relative_age_refs" (
  "relative_age_ref_id" serial primary key,
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "relative_age_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_relative_age_types" (
  "relative_age_type_id" serial primary key,
  "age_type" varchar unique COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_relative_ages" (
  "relative_age_id" serial primary key,
  "relative_age_type_id" int4,
  "relative_age_name" varchar(50) COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "c14_age_older" numeric(20, 5),
  "c14_age_younger" numeric(20, 5),
  "cal_age_older" numeric(20, 5),
  "cal_age_younger" numeric(20, 5),
  "notes" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now(),
  "location_id" int4,
  "abbreviation" varchar COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_relative_dates" (
  "relative_date_id" serial primary key,
  "relative_age_id" int4,
  "physical_sample_id" int4 NOT NULL,
  "method_id" int4,
  "notes" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now(),
  "dating_uncertainty_id" int4
);
CREATE TABLE "public"."tbl_sample_alt_refs" (
  "sample_alt_ref_id" serial primary key,
  "alt_ref" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "alt_ref_type_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "physical_sample_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_sample_colours" (
  "sample_colour_id" serial primary key,
  "colour_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "physical_sample_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_sample_coordinates" (
  "sample_coordinate_id" serial primary key,
  "physical_sample_id" int4 NOT NULL,
  "coordinate_method_dimension_id" int4 NOT NULL,
  "measurement" numeric(20, 10) NOT NULL,
  "accuracy" numeric(20, 10),
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sample_description_sample_group_contexts" (
  "sample_description_sample_group_context_id" serial primary key,
  "sampling_context_id" int4,
  "sample_description_type_id" int4,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sample_description_types" (
  "sample_description_type_id" serial primary key,
  "type_name" varchar(255) unique COLLATE "pg_catalog"."default",
  "type_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sample_descriptions" (
  "sample_description_id" serial primary key,
  "sample_description_type_id" int4 NOT NULL,
  "physical_sample_id" int4 NOT NULL,
  "description" varchar COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sample_dimensions" (
  "sample_dimension_id" serial primary key,
  "physical_sample_id" int4 NOT NULL,
  "dimension_id" int4 NOT NULL,
  "method_id" int4 NOT NULL,
  "dimension_value" numeric(20, 10) NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sample_group_coordinates" (
  "sample_group_position_id" serial primary key,
  "coordinate_method_dimension_id" int4 NOT NULL,
  "sample_group_position" numeric(20, 10),
  "position_accuracy" varchar(128) COLLATE "pg_catalog"."default",
  "sample_group_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sample_group_description_type_sampling_contexts" (
  "sample_group_description_type_sampling_context_id" serial primary key,
  "sampling_context_id" int4 NOT NULL,
  "sample_group_description_type_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sample_group_description_types" (
  "sample_group_description_type_id" serial primary key,
  "type_name" varchar(255) unique COLLATE "pg_catalog"."default",
  "type_description" varchar COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sample_group_descriptions" (
  "sample_group_description_id" serial primary key,
  "group_description" varchar COLLATE "pg_catalog"."default",
  "sample_group_description_type_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "sample_group_id" int4
);
CREATE TABLE "public"."tbl_sample_group_dimensions" (
  "sample_group_dimension_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "dimension_id" int4 NOT NULL,
  "dimension_value" numeric(20, 5) NOT NULL,
  "sample_group_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_sample_group_images" (
  "sample_group_image_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "image_location" text COLLATE "pg_catalog"."default" NOT NULL,
  "image_name" varchar(80) COLLATE "pg_catalog"."default",
  "image_type_id" int4 NOT NULL,
  "sample_group_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_sample_group_notes" (
  "sample_group_note_id" serial primary key,
  "sample_group_id" int4 NOT NULL,
  "note" varchar COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sample_group_references" (
  "sample_group_reference_id" serial primary key,
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "sample_group_id" int4 DEFAULT 0
);
CREATE TABLE "public"."tbl_sample_group_sampling_contexts" (
  "sampling_context_id" serial primary key,
  "sampling_context" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "sort_order" int2 NOT NULL DEFAULT 0,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sample_groups" (
  "sample_group_id" serial primary key,
  "site_id" int4 DEFAULT 0,
  "sampling_context_id" int4,
  "method_id" int4 NOT NULL,
  "sample_group_name" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "sample_group_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sample_horizons" (
  "sample_horizon_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "horizon_id" int4 NOT NULL,
  "physical_sample_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_sample_images" (
  "sample_image_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "image_location" text COLLATE "pg_catalog"."default" NOT NULL,
  "image_name" varchar(80) COLLATE "pg_catalog"."default",
  "image_type_id" int4 NOT NULL,
  "physical_sample_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_sample_location_type_sampling_contexts" (
  "sample_location_type_sampling_context_id" serial primary key,
  "sampling_context_id" int4 NOT NULL,
  "sample_location_type_id" int4 not null, -- Note was SERIAL
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sample_location_types" (
  "sample_location_type_id" serial primary key,
  "location_type" varchar(255) unique COLLATE "pg_catalog"."default",
  "location_type_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sample_locations" (
  "sample_location_id" serial primary key,
  "sample_location_type_id" int4 NOT NULL,
  "physical_sample_id" int4 NOT NULL,
  "location" varchar(255) COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sample_notes" (
  "sample_note_id" serial primary key,
  "physical_sample_id" int4 NOT NULL,
  "note_type" varchar COLLATE "pg_catalog"."default",
  "note" text COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sample_types" (
  "sample_type_id" serial primary key,
  "type_name" varchar(40) unique  COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_season_types" (
  "season_type_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "season_type" varchar(30) unique COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_seasons" (
  "season_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "season_name" varchar(20) unique COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "season_type" varchar(30) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "season_type_id" int4,
  "sort_order" int2 DEFAULT 0
);
CREATE TABLE "public"."tbl_site_images" (
  "site_image_id" serial primary key,
  "contact_id" int4,
  "credit" varchar(100) COLLATE "pg_catalog"."default",
  "date_taken" date,
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "image_location" text COLLATE "pg_catalog"."default" NOT NULL,
  "image_name" varchar(80) COLLATE "pg_catalog"."default",
  "image_type_id" int4 NOT NULL,
  "site_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_site_locations" (
  "site_location_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "location_id" int4 NOT NULL,
  "site_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_site_natgridrefs" (
  "site_natgridref_id" serial primary key,
  "site_id" int4 NOT NULL,
  "method_id" int4 NOT NULL,
  "natgridref" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_site_other_records" (
  "site_other_records_id" serial primary key,
  "site_id" int4,
  "biblio_id" int4,
  "record_type_id" int4,
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_site_preservation_status" (
  "site_preservation_status_id" serial primary key,
  "site_id" int4,
  "preservation_status_or_threat" varchar COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "assessment_type" varchar COLLATE "pg_catalog"."default",
  "assessment_author_contact_id" int4,
  "date_updated" timestamp with time zone DEFAULT now(),
  "Evaluation_date" date
);
CREATE TABLE "public"."tbl_site_references" (
  "site_reference_id" serial primary key,
  "site_id" int4 DEFAULT 0,
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_sites" (
  "site_id" serial primary key,
  "altitude" numeric(18, 10),
  "latitude_dd" numeric(18, 10),
  "longitude_dd" numeric(18, 10),
  "national_site_identifier" varchar(255) COLLATE "pg_catalog"."default",
  "site_description" text COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "site_name" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "site_preservation_status_id" int4,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_species_association_types" (
  "association_type_id" serial primary key,
  "association_type_name" varchar(255) unique COLLATE "pg_catalog"."default",
  "association_description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_species_associations" (
  "species_association_id" serial primary key,
  "associated_taxon_id" int4 NOT NULL,
  "biblio_id" int4,
  "date_updated" timestamp with time zone DEFAULT now(),
  "taxon_id" int4 NOT NULL,
  "association_type_id" int4,
  "referencing_type" text COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_taxa_common_names" (
  "taxon_common_name_id" serial primary key,
  "common_name" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "date_updated" timestamp with time zone DEFAULT now(),
  "language_id" int4 DEFAULT 0,
  "taxon_id" int4 DEFAULT 0
);
CREATE TABLE "public"."tbl_taxa_images" (
  "taxa_images_id" serial primary key,
  "image_name" varchar COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "image_location" text COLLATE "pg_catalog"."default",
  "image_type_id" int4,
  "taxon_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_taxa_measured_attributes" (
  "measured_attribute_id" serial primary key,
  "attribute_measure" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "attribute_type" varchar(25) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "attribute_units" varchar(10) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "data" numeric(18, 10) DEFAULT 0,
  "date_updated" timestamp with time zone DEFAULT now(),
  "taxon_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_taxa_reference_specimens" (
  "taxa_reference_specimen_id" serial primary key,
  "taxon_id" int4 NOT NULL,
  "contact_id" int4 NOT NULL,
  "notes" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_taxa_seasonality" (
  "seasonality_id" serial primary key,
  "activity_type_id" int4 NOT NULL,
  "season_id" int4 DEFAULT 0,
  "taxon_id" int4 NOT NULL,
  "location_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_taxa_synonyms" (
  "synonym_id" serial primary key,
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "family_id" int4,
  "genus_id" int4,
  "notes" text COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "taxon_id" int4,
  "author_id" int4,
  "synonym" varchar(255) COLLATE "pg_catalog"."default",
  "reference_type" varchar COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_taxa_tree_authors" (
  "author_id" serial primary key,
  "author_name" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "date_updated" timestamp with time zone DEFAULT now()
);
CREATE TABLE "public"."tbl_taxa_tree_families" (
  "family_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "family_name" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "order_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_taxa_tree_genera" (
  "genus_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "family_id" int4,
  "genus_name" varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
);
CREATE TABLE "public"."tbl_taxa_tree_master" (
  "taxon_id" serial primary key,
  "author_id" int4,
  "date_updated" timestamp with time zone DEFAULT now(),
  "genus_id" int4,
  "species" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
);
CREATE TABLE "public"."tbl_taxa_tree_orders" (
  "order_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "order_name" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "record_type_id" int4,
  "sort_order" int4
);
CREATE TABLE "public"."tbl_taxonomic_order" (
  "taxonomic_order_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "taxon_id" int4 DEFAULT 0,
  "taxonomic_code" numeric(18, 10) DEFAULT 0,
  "taxonomic_order_system_id" int4 DEFAULT 0
);
CREATE TABLE "public"."tbl_taxonomic_order_biblio" (
  "taxonomic_order_biblio_id" serial primary key,
  "biblio_id" int4 DEFAULT 0,
  "date_updated" timestamp with time zone DEFAULT now(),
  "taxonomic_order_system_id" int4 DEFAULT 0
);
CREATE TABLE "public"."tbl_taxonomic_order_systems" (
  "taxonomic_order_system_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "system_description" text COLLATE "pg_catalog"."default",
  "system_name" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
);
CREATE TABLE "public"."tbl_taxonomy_notes" (
  "taxonomy_notes_id" serial primary key,
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "taxon_id" int4 NOT NULL,
  "taxonomy_notes" text COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_tephra_dates" (
  "tephra_date_id" serial primary key,
  "analysis_entity_id" bigint NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "notes" text COLLATE "pg_catalog"."default",
  "tephra_id" int4 NOT NULL,
  "dating_uncertainty_id" int4
);
CREATE TABLE "public"."tbl_tephra_refs" (
  "tephra_ref_id" serial primary key,
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "tephra_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_tephras" (
  "tephra_id" serial primary key,
  "c14_age" numeric(20, 5),
  "c14_age_older" numeric(20, 5),
  "c14_age_younger" numeric(20, 5),
  "cal_age" numeric(20, 5),
  "cal_age_older" numeric(20, 5),
  "cal_age_younger" numeric(20, 5),
  "date_updated" timestamp with time zone DEFAULT now(),
  "notes" text COLLATE "pg_catalog"."default",
  "tephra_name" varchar(80) COLLATE "pg_catalog"."default"
);
CREATE TABLE "public"."tbl_text_biology" (
  "biology_id" serial primary key,
  "biblio_id" int4 NOT NULL,
  "biology_text" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now(),
  "taxon_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_text_distribution" (
  "distribution_id" serial primary key,
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "distribution_text" text COLLATE "pg_catalog"."default",
  "taxon_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_text_identification_keys" (
  "key_id" serial primary key,
  "biblio_id" int4 NOT NULL,
  "date_updated" timestamp with time zone DEFAULT now(),
  "key_text" text COLLATE "pg_catalog"."default",
  "taxon_id" int4 NOT NULL
);
CREATE TABLE "public"."tbl_units" (
  "unit_id" serial primary key,
  "date_updated" timestamp with time zone DEFAULT now(),
  "description" text COLLATE "pg_catalog"."default",
  "unit_abbrev" varchar(15) unique COLLATE "pg_catalog"."default",
  "unit_name" varchar(50) unique COLLATE "pg_catalog"."default" NOT NULL
);
CREATE TABLE "public"."tbl_updates_log" (
  "updates_log_id" int4 NOT NULL primary key,
  "table_name" varchar(150) COLLATE "pg_catalog"."default" NOT NULL,
  "last_updated" date NOT NULL
);
CREATE TABLE "public"."tbl_years_types" (
  "years_type_id" serial primary key,
  "name" varchar unique COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "date_updated" timestamp with time zone DEFAULT now()
);
