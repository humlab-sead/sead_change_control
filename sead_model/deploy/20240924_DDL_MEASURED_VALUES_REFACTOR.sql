-- Deploy sead_model: 20240924_DDL_MEASURED_VALUES_REFACTOR

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-09-24
  Description   Refactor of measurements DB model to make it more generic
  Issue         https://github.com/humlab-sead/sead_change_control/issues/319
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin
    drop table if exists "tbl_analysis_value_dimensions" cascade;
    drop table if exists "tbl_analysis_identifiers" cascade;
    drop table if exists "tbl_analysis_numerical_values" cascade;
    drop table if exists "tbl_analysis_numerical_ranges" cascade;
    drop table if exists "tbl_analysis_integer_values" cascade;
    drop table if exists "tbl_analysis_integer_ranges" cascade;
    drop table if exists "tbl_analysis_categorical_values" cascade;
    drop table if exists "tbl_analysis_boolean_values" cascade;
    drop table if exists "tbl_analysis_dating_ranges" cascade;
    drop table if exists "tbl_analysis_taxon_counts" cascade;
    drop table if exists "tbl_analysis_notes" cascade;
    drop table if exists "tbl_analysis_values" cascade;
    drop table if exists "tbl_value_classes" cascade;
    drop table if exists "tbl_value_type_items" cascade;
    drop table if exists "tbl_value_types" cascade;
    drop table if exists "tbl_value_qualifier_symbols" cascade;
    drop table if exists "tbl_value_qualifiers" cascade;
    

    begin
 
        create table "tbl_value_qualifiers" (
            "symbol" text primary key,
            "description" text not null
        );

        create table "tbl_value_qualifier_symbols" (
            "symbol" text not null primary key,
            "cardinal_symbol" text not null references "tbl_value_qualifiers" ("symbol")
        );

        create table "tbl_value_types" (
            "value_type_id" int primary key,
            "unit_id" int null references "tbl_units" ("unit_id"),
            "data_type_id" int null references "tbl_data_types" ("data_type_id"),
            "name" text not null unique,
            "base_type" text not null,
            "precision" int null default null,
            "description" text not null
        );

        create table "tbl_value_type_items" (
            "value_type_item_id" int primary key,
            "value_type_id" int not null references "tbl_value_types" ("value_type_id"),
            "name" varchar(80) null default null,
            "description" text null default null
        );


        create table "tbl_value_classes" (
            "value_class_id" int not null primary key,
            "value_type_id" int not null references "tbl_value_types" ("value_type_id"),
            "method_id" int not null references "tbl_methods" ("method_id"),
            "parent_id" int null references "tbl_value_classes" ("value_class_id"),
            "name" varchar(80) not null,
            "description" text not null
        );

        create table "tbl_analysis_values" (
            "analysis_value_id" bigserial primary key,
            "value_class_id" int not null references "tbl_value_classes" ("value_class_id"),
            "analysis_entity_id" bigint not null references "tbl_analysis_entities" ("analysis_entity_id"),
            "analysis_value" text null default null,
            "boolean_value" boolean null default null,
            "is_boolean" boolean null default null, -- if the value is of type boolean, could be deduced from value type table though
            "is_uncertain" boolean null default null,
            "is_undefined" boolean null default null,
            "is_not_analyzed" boolean null default null,
            "is_indeterminable" boolean null default null,
            "is_anomaly" boolean null default null
        );

        create table "tbl_analysis_boolean_values" (
            "analysis_boolean_value_id" serial primary key,
            "analysis_value_id" bigint not null unique references "tbl_analysis_values" ("analysis_value_id"),
			"qualifier" text null default null,
            "value" bool null default null
        );

        create table "tbl_analysis_integer_values" (
            "analysis_integer_value_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "qualifier" text null references tbl_value_qualifier_symbols(symbol),
            "value" int null default null,
            "is_variant" bool null default null
        );

        create table "tbl_analysis_categorical_values" (
            "analysis_categorical_value_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "value_type_item_id" int not null references "tbl_value_type_items" ("value_type_item_id"),
            "value" decimal(20,10) null default null, -- optional value,
            "is_variant" bool null default null
        );

        create table "tbl_analysis_numerical_values" (
            "analysis_numerical_value_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "qualifier" text null references tbl_value_qualifier_symbols(symbol),
            "value" decimal(20,10) null,
            "is_variant" bool null default null
        );

        create table "tbl_analysis_identifiers" (
            "analysis_identifier_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "value" text not null
        );

        create table "tbl_analysis_numerical_ranges" (
            "analysis_numerical_range_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "value" numrange not null,
            "low_is_uncertain" bool null,
            "high_is_uncertain" bool null,
            "low_qualifier" text null references tbl_value_qualifier_symbols(symbol),
            "high_qualifier" text null references tbl_value_qualifier_symbols(symbol),
            "is_variant" bool null default null
        );

        create table "tbl_analysis_integer_ranges" (
            "analysis_integer_range_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "low_value" int null,
            "high_value" int null,
            "low_is_uncertain" bool null,
            "high_is_uncertain" bool null,
            "low_qualifier" text null references tbl_value_qualifier_symbols(symbol),
            "high_qualifier" text null references tbl_value_qualifier_symbols(symbol),
            "is_variant" bool null default null
        );

        create table "tbl_analysis_dating_ranges" (
            "analysis_dating_range_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            -- "value" int4range not null,
            "low_value" int null,
            "high_value" int null,
            "low_is_uncertain" bool null,
            "high_is_uncertain" bool null,
            "low_qualifier" text null references tbl_value_qualifier_symbols(symbol),
            "high_qualifier" text null references tbl_value_qualifier_symbols(symbol),
            "age_type_id" int not null default(1) references tbl_age_types ("age_type_id"),
            "season_id" int null default null references tbl_seasons("season_id"),
            "dating_uncertainty_id" int null default null references tbl_dating_uncertainty("dating_uncertainty_id"),
            "is_variant" bool null default null
        );

        create table "tbl_analysis_notes" (
            "analysis_note_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "value" text not null
        );

        create table "tbl_analysis_value_dimensions" (
            "analysis_value_dimension_id" serial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "dimension_id" int not null references "tbl_dimensions" ("dimension_id"),
            "value" numeric(20,10) not null
        );

        create table "tbl_analysis_taxon_counts" (
            "analysis_taxon_count_id" serial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "taxon_id" int not null references "tbl_taxa_tree_master" ("taxon_id"),
            "value" numeric(20,10) not null
        );

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
    grant select on "tbl_analysis_value_dimensions" to public;
    grant select on "tbl_analysis_identifiers" to public;
    grant select on "tbl_analysis_numerical_values" to public;
    grant select on "tbl_analysis_numerical_ranges" to public;
    grant select on "tbl_analysis_integer_values" to public;
    grant select on "tbl_analysis_integer_ranges" to public;
    grant select on "tbl_analysis_categorical_values" to public;
    grant select on "tbl_analysis_boolean_values" to public;
    grant select on "tbl_analysis_dating_ranges" to public;
    grant select on "tbl_analysis_taxon_counts" to public;
    grant select on "tbl_analysis_notes" to public;
    grant select on "tbl_analysis_values" to public;
    grant select on "tbl_value_classes" to public;
    grant select on "tbl_value_type_items" to public;
    grant select on "tbl_value_types" to public;
    grant select on "tbl_value_qualifier_symbols" to public;
    grant select on "tbl_value_qualifiers" to public;
    
end $$;
commit;
