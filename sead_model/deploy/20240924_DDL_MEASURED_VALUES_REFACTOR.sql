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

    begin
        drop table if exists "tbl_analysis_value_dimensions";
        drop table if exists "tbl_analysis_numerical_values";
        drop table if exists "tbl_analysis_numerical_ranges";
        drop table if exists "tbl_analysis_integer_values";
        drop table if exists "tbl_analysis_integer_ranges";
        drop table if exists "tbl_analysis_categorical_values";
        drop table if exists "tbl_analysis_boolean_values";
        drop table if exists "tbl_analysis_dating_ranges";
        drop table if exists "tbl_analysis_value_taxon_counts";
        drop table if exists "tbl_analysis_values";
        drop table if exists "tbl_value_classes";
        drop table if exists "tbl_value_type_items";
        drop table if exists "tbl_value_types";
		drop table if exists "tbl_value_qualifiers";

        create table tbl_value_qualifiers (
            "qualifier_id" serial primary key,
            "qualifier_symbol" text not null unique,
            "description" text not null
        );

        with qualifiers_data(qualifier_symbol, "description") as (
            values
                ('<', 'Less than. The value is smaller than the compared value.'),
                ('>', 'Greater than. The value is larger than the compared value.'),
                ('=', 'Equal to. The value is exactly equal to the compared value.'),
                ('<=', 'Less than or equal to. The value is smaller than or equal to the compared value.'),
                ('>=', 'Greater than or equal to. The value is larger than or equal to the compared value.'),
                ('~', 'Approximately equal to. The value is roughly around the compared value, but not exact.'),
                ('≈', 'Almost equal to. The value is very close to the compared value but may not be exactly the same.'),
                ('≠', 'Not equal to. The value is different from the compared value.'),
                ('≅', 'Approximately congruent to. Often used in geometry to represent values that are congruent or similar.'),
                ('±', 'Plus-minus. Indicates a value range where the actual value could be either greater or smaller by a specific amount.'),
                ('≈ but ≠', 'Almost equal to but not the same. The value is very close to the compared value but not be exactly the same.')
            )
            insert into tbl_value_qualifiers (qualifier_symbol, "description")
                select qualifier_symbol, "description" from qualifiers_data;


        create table "tbl_value_types" (
            "value_type_id" int primary key,
            "unit_id" int null references "tbl_units" ("unit_id"),
            "data_type_id" int null references "tbl_data_types" ("data_type_id"),
            "name" text not null,
            "base_type" text not null,
            "precision" int null default null,
            "description" text not null
        );

        -- create table "tbl_value_type_record_type_constraints" (
        --     "value_type_record_type_id" serial primary key,
        --     "value_type_id" int not null key references "tbl_value_types" ("value_type_id"),
        --     "record_type_id" int null references "tbl_record_types" ("record_type_id")
        -- );

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
            "name" varchar(80) not null,
            "description" text not null
        );

        create table "tbl_analysis_values" (
            "analysis_value_id" bigserial primary key,
            "value_class_id" int not null,
            "analysis_entity_id" bigint not null references "tbl_analysis_entities" ("analysis_entity_id"),
            "analysis_value" varchar(256),
            "flag_value" boolean null default null,
            "is_uncertain" boolean null default null,
            "is_flag" boolean null default null, -- if the value is a flag value, could be deduced from value type table though
            "is_undefined" boolean null default null,
            "is_indeterminable" boolean null default null,
            "is_anomaly" boolean null default null
        );

        create table "tbl_analysis_boolean_values" (
            "analysis_boolean_value_id" int primary key,
            "value" bool null default null
        );

        create table "tbl_analysis_integer_values" (
            "analysis_integer_value_id" int primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "qualifier" text null references tbl_value_qualifiers(qualifier_symbol),
            "value" int null default null
        );

        create table "tbl_analysis_categorical_values" (
            "analysis_categorical_value_id" int primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "value_type_item_id" int not null references "tbl_value_type_items" ("value_type_item_id")
        );

        create table "tbl_analysis_numerical_values" (
            "analysis_numerical_value_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "qualifier" text null references tbl_value_qualifiers(qualifier_symbol),
            "value" decimal(20,10) null
        );

        create table "tbl_analysis_numerical_ranges" (
            "analysis_numerical_range_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "value" numrange not null,
            "low_is_uncertain" bool null,
            "high_is_uncertain" bool null,
            "low_qualifier" text null references tbl_value_qualifiers(qualifier_symbol),
            "high_qualifier" text null references tbl_value_qualifiers(qualifier_symbol)
        );

        create table "tbl_analysis_integer_ranges" (
            "analysis_integer_range_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "value" int4range not null,
            "low_is_uncertain" bool null,
            "high_is_uncertain" bool null,
            "low_qualifier" text null references tbl_value_qualifiers(qualifier_symbol),
            "high_qualifier" text null references tbl_value_qualifiers(qualifier_symbol)
        );

        create table "tbl_analysis_dating_ranges" (
            "analysis_dating_range_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "age_type_id" int not null default(1) references tbl_age_types ("age_type_id"),
            "value" int4range not null,
            "season_id" int null default null references tbl_seasons("season_id"),
            "dating_uncertainty_id" int
        );

        create table "tbl_analysis_value_dimensions" (
            "analysis_value_dimension_id" serial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "dimension_id" int not null references "tbl_dimensions" ("dimension_id"),
            "value" numeric(20,10) not null
        );

        create table "tbl_analysis_value_taxon_counts" (
            "analysis_value_dimension_id" serial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id"),
            "taxon_id" int not null references "tbl_taxa_tree_master" ("taxon_id"),
            "value" numeric(20,10) not null
        );

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
