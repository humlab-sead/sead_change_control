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

set client_encoding = 'UTF8';
set client_min_messages = warning;

set role sead_master;

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
            "qualifier_id" int primary key,
            "symbol" text not null unique,
            "description" text not null,
            "qualifier_uuid" uuid not null default uuid_generate_v4()
        );

        create table "tbl_value_qualifier_symbols" (
            "qualifier_symbol_id" int primary key,
            "symbol" text not null unique,
            "cardinal_qualifier_id" int not null references "tbl_value_qualifiers" ("qualifier_id") deferrable,
            "qualifier_uuid" uuid not null default uuid_generate_v4()
        );

        create table "tbl_value_types" (
            "value_type_id" int primary key,
            "unit_id" int null references "tbl_units" ("unit_id") deferrable,
            "data_type_id" int null references "tbl_data_types" ("data_type_id") deferrable,
            "name" text not null unique,
            "base_type" text not null,
            "precision" int null default null,
            "description" text not null,
            "value_type_uuid" uuid not null default uuid_generate_v4()
        );

        create table "tbl_value_type_items" (
            "value_type_item_id" int primary key,
            "value_type_id" int not null references "tbl_value_types" ("value_type_id") deferrable,
            "name" varchar(80) null default null,
            "description" text null default null
        );

        create table "tbl_value_classes" (
            "value_class_id" int not null primary key,
            "value_type_id" int not null references "tbl_value_types" ("value_type_id") deferrable,
            "method_id" int not null references "tbl_methods" ("method_id") deferrable,
            "parent_id" int null references "tbl_value_classes" ("value_class_id") deferrable,
            "name" varchar(80) not null,
            "description" text not null,
            "value_class_uuid" uuid not null default uuid_generate_v4()
        );

        create table "tbl_analysis_values" (
            "analysis_value_id" bigserial primary key,
            "value_class_id" int not null references "tbl_value_classes" ("value_class_id") deferrable,
            "analysis_entity_id" bigint not null references "tbl_analysis_entities" ("analysis_entity_id") deferrable,
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
            "analysis_value_id" bigint not null unique references "tbl_analysis_values" ("analysis_value_id") deferrable,
			"qualifier" text null default null,
            "value" bool null default null
        );

        create table "tbl_analysis_integer_values" (
            "analysis_integer_value_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id") deferrable,
            "qualifier" text null references tbl_value_qualifier_symbols(symbol) deferrable,
            "value" int null default null,
            "is_variant" bool null default null
        );

        create table "tbl_analysis_categorical_values" (
            "analysis_categorical_value_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id") deferrable,
            "value_type_item_id" int not null references "tbl_value_type_items" ("value_type_item_id") deferrable,
            "value" decimal(20,10) null default null, -- optional value,
            "is_variant" bool null default null
        );

        create table "tbl_analysis_numerical_values" (
            "analysis_numerical_value_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id") deferrable,
            "qualifier" text null references tbl_value_qualifier_symbols(symbol) deferrable,
            "value" decimal(20,10) null,
            "is_variant" bool null default null
        );

        create table "tbl_analysis_identifiers" (
            "analysis_identifier_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id") deferrable,
            "value" text not null
        );

        create table "tbl_analysis_numerical_ranges" (
            "analysis_numerical_range_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id") deferrable,
            "value" numrange not null,
            "low_is_uncertain" bool null,
            "high_is_uncertain" bool null,
            "low_qualifier" text null references tbl_value_qualifier_symbols(symbol) deferrable,
            "high_qualifier" text null references tbl_value_qualifier_symbols(symbol) deferrable,
            "is_variant" bool null default null
        );

        create table "tbl_analysis_integer_ranges" (
            "analysis_integer_range_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id") deferrable,
            "low_value" int null,
            "high_value" int null,
            "low_is_uncertain" bool null,
            "high_is_uncertain" bool null,
            "low_qualifier" text null references tbl_value_qualifier_symbols(symbol) deferrable,
            "high_qualifier" text null references tbl_value_qualifier_symbols(symbol) deferrable,
            "is_variant" bool null default null
        );

        create table "tbl_analysis_dating_ranges" (
            "analysis_dating_range_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id") deferrable,
            -- "value" int4range not null,
            "low_value" int null,
            "high_value" int null,
            "low_is_uncertain" bool null,
            "high_is_uncertain" bool null,
            "low_qualifier" text null references tbl_value_qualifier_symbols(symbol) deferrable,
            "high_qualifier" text null references tbl_value_qualifier_symbols(symbol) deferrable,
            "age_type_id" int not null default(1) references tbl_age_types ("age_type_id") deferrable,
            "season_id" int null default null references tbl_seasons("season_id") deferrable,
            "dating_uncertainty_id" int null default null references tbl_dating_uncertainty("dating_uncertainty_id") deferrable,
            "is_variant" bool null default null
        );

        create table "tbl_analysis_notes" (
            "analysis_note_id" bigserial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id") deferrable,
            "value" text not null
        );

        create table "tbl_analysis_value_dimensions" (
            "analysis_value_dimension_id" serial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id") deferrable,
            "dimension_id" int not null references "tbl_dimensions" ("dimension_id") deferrable,
            "value" numeric(20,10) not null
        );

        create table "tbl_analysis_taxon_counts" (
            "analysis_taxon_count_id" serial primary key,
            "analysis_value_id" bigint not null references "tbl_analysis_values" ("analysis_value_id") deferrable,
            "taxon_id" int not null references "tbl_taxa_tree_master" ("taxon_id") deferrable,
            "value" numeric(20,10) not null
        );

        -- These to FKs resolves #334
        if not sead_utility.column_exists('public', 'tbl_sample_dimensions', 'qualifier_id') then
            alter table "tbl_sample_dimensions" add column "qualifier_id" int null references "tbl_value_qualifiers" ("qualifier_id") deferrable;
        end if;

        if not sead_utility.column_exists('public', 'tbl_sample_group_dimensions ', 'qualifier_id') then
            alter table "tbl_sample_group_dimensions " add column "qualifier_id" int null references "tbl_value_qualifiers" ("qualifier_id") deferrable;
        end if;

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
    

    create view view_typed_analysis_tables as
        /*
        	with value_tables (table_name, base_type) as (
                select distinct table_name,
                    replace(replace(regexp_replace(
                        lower(regexp_replace(
                            substring(table_name FROM 'tbl_analysis_(\w+)$'),
                            '^value_|_values$',
                            ''
                        )),
                        's$',
                        ''
                    ), 'numerical', 'decimal'), 'categorical', 'category')
                from sead_utility.table_columns
                where table_name like 'tbl_analysis%'
                and table_name not like 'tbl_analysis_enti%'
                and table_name not in ('tbl_analysis_values')
            ) select *
            from value_tables
        */
        select table_id, table_name, base_type
        from (values 
            (1, 'tbl_analysis_boolean_values', 'boolean'),
            (2, 'tbl_analysis_categorical_values', 'category'),
            (3, 'tbl_analysis_dating_ranges', 'dating_range'),
            (4, 'tbl_analysis_identifiers', 'identifier'),
            (5, 'tbl_analysis_integer_ranges', 'integer_range'),
            (6, 'tbl_analysis_integer_values', 'integer'),
            (7, 'tbl_analysis_notes', 'note'),
            (8, 'tbl_analysis_numerical_ranges', 'decimal_range'),
            (9, 'tbl_analysis_numerical_values', 'decimal'),
            (10, 'tbl_analysis_taxon_counts', 'taxon_count'),
            (11, 'tbl_analysis_value_dimensions', 'dimension')
        ) as t(table_id, table_name, base_type);


    create view view_typed_analysis_values as
        select 1 as table_id, analysis_value_id from tbl_analysis_boolean_values
        union
        select 2 as table_id, analysis_value_id from tbl_analysis_categorical_values
        union
        select 3 as table_id, analysis_value_id from tbl_analysis_dating_ranges
        union
        select 4 as table_id, analysis_value_id from tbl_analysis_identifiers
        union
        select 5 as table_id, analysis_value_id from tbl_analysis_integer_ranges
        union
        select 6 as table_id, analysis_value_id from tbl_analysis_integer_values
        union
        select 7 as table_id, analysis_value_id from tbl_analysis_notes
        union
        select 8 as table_id, analysis_value_id from tbl_analysis_numerical_ranges
        union
        select 9 as table_id, analysis_value_id from tbl_analysis_numerical_values
        union
        select 10 as table_id, analysis_value_id from tbl_analysis_taxon_counts
        union
        select 11 as table_id, analysis_value_id from tbl_analysis_value_dimensions
    ;

    create view typed_analysis_values as 
        select analysis_value_id, table_name, base_type
        from view_typed_analysis_values
        join view_typed_analysis_tables using (table_id);


end $$;
commit;

reset role;

-- FIXME: This should be done by the clearinghouse project, but how to link/sync with this CR?
set role clearinghouse_worker;

call clearing_house_commit.create_or_update_clearinghouse_system(false, false, false);

reset role;
