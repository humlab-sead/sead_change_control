-- Deploy sead_model: 20240924_DDL_MEASURED_VALUES_REFACTOR

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-09-24
  Description   Refactor of neasured value DB model to make it more generic
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
		-- drop table if exists "tbl_analysis_fuzzy_numerical_ranges";
        drop table if exists "tbl_analysis_numerical_values";
        drop table if exists "tbl_analysis_categorical_values";
        drop table if exists "tbl_analysis_numerical_ranges";
        drop table if exists "tbl_analysis_integer_ranges";
        drop table if exists "tbl_analysis_values";
        drop table if exists "tbl_value_classes";
        drop table if exists "tbl_value_category_items";
        drop table if exists "tbl_value_categories";
        drop table if exists "tbl_value_types";


        create table "tbl_analysis_values" (
            "analysis_value_id" bigserial primary key,
            "value_class_id" int not null,
            "analysis_entity_id" bigint not null,
            "analysis_value" varchar(256),
            "boolean_value" boolean null
        );
        
        create table "tbl_analysis_categorical_values" (
            "analysis_categorical_value_id" int primary key,
            "analysis_value_id" bigint not null,
            "value_category_item_id" int not null
        );

        create table "tbl_analysis_numerical_values" (
            "analysis_numerical_value_id" bigserial primary key,
            "analysis_value_id" bigint not null,
            "uncertainty" bool null,
            "qualifier" varchar(256) null,
            "value" decimal(20,10) null
        );

        -- create table "tbl_analysis_fuzzy_numerical_ranges" (
        --     "analysis_value_range_id" bigserial primary key,
        --     "analysis_value_id" bigint not null,
        --     "lower_value_id" bigint not null,
        --     "upper_value_id" bigint not null
        -- );

        create table "tbl_analysis_numerical_ranges" (
            "analysis_value_range_id" bigserial primary key,
            "analysis_value_id" bigint not null,
            "range" numrange not null
            "low_uncertainty" bool null,
            "high_uncertainty" bool null,
            "low_qualifier" varchar(60) null,
            "high_qualifier" varchar(60) null
        );

        create table "tbl_analysis_integer_ranges" (
            "analysis_value_range_id" bigserial primary key,
            "analysis_value_id" bigint not null,
            "range" int4range not null
            "low_uncertainty" bool null,
            "high_uncertainty" bool null,
            "low_qualifier" varchar(60) null,
            "high_qualifier" varchar(60) null
        );

        create table "tbl_value_categories" (
            "value_category_id" bigint primary key,
            "name" varchar(80),
            "description" varchar(512)
        );

        create table "tbl_value_category_items" (
            "value_category_item_id" int primary key,
            "value_category_id" int,
            "name" varchar(80),
            "description" varchar(512)
        );

        create table "tbl_value_classes" (
            "value_class_id" int not null primary key,
            "value_category_id" int,
            "value_type_id" int not null,
            "method_id" int not null,
            "name" varchar(80) not null,
            "description" varchar(512) not null
        );

        create table "tbl_value_types" (
            "value_type_id" int primary key,
            "unit_id" int not null,
            "data_type_id" int null,
            "description" varchar(256) not null
        );

        alter table "tbl_analysis_categorical_values" add constraint "fk_tbl_analysis_categorical_values_tbl_analysis_values" foreign key ("analysis_value_id") references "tbl_analysis_values" ("analysis_value_id");
        alter table "tbl_analysis_categorical_values" add constraint "fk_tbl_analysis_categorical_values_tbl_value_category_items" foreign key ("value_category_item_id") references "tbl_value_category_items" ("value_category_item_id");
        alter table "tbl_analysis_numerical_values" add constraint "fk_tbl_analysis_numerical_values_tbl_analysis_values" foreign key ("analysis_value_id") references "tbl_analysis_values" ("analysis_value_id");
        -- alter table "tbl_analysis_fuzzy_numerical_ranges" add constraint "fk_tbl_analysis_value_ranges_tbl_analysis_numerical_values_1" foreign key ("lower_value_id") references "tbl_analysis_numerical_values" ("analysis_numerical_value_id");
        -- alter table "tbl_analysis_fuzzy_numerical_ranges" add constraint "fk_tbl_analysis_value_ranges_tbl_analysis_numerical_values_2" foreign key ("upper_value_id") references "tbl_analysis_numerical_values" ("analysis_numerical_value_id");
        -- alter table "tbl_analysis_fuzzy_numerical_ranges" add constraint "fk_tbl_analysis_value_ranges_tbl_analysis_values" foreign key ("analysis_value_id") references "tbl_analysis_values" ("analysis_value_id");
        alter table "tbl_analysis_integer_ranges" add constraint "fk_tbl_analysis_integer_ranges_tbl_analysis_values" foreign key ("analysis_value_id") references "tbl_analysis_values" ("analysis_value_id");
        alter table "tbl_analysis_numerical_ranges" add constraint "fk_tbl_analysis_numerical_ranges_tbl_analysis_values" foreign key ("analysis_value_id") references "tbl_analysis_values" ("analysis_value_id");
        alter table "tbl_analysis_values" add constraint "fk_tbl_analysis_values_tbl_analysis_entities_1" foreign key ("analysis_entity_id") references "tbl_analysis_entities" ("analysis_entity_id");
        alter table "tbl_value_category_items" add constraint "fk_tbl_value_category_items_tbl_value_categories" foreign key ("value_category_id") references "tbl_value_categories" ("value_category_id");
        alter table "tbl_value_classes" add constraint "fk_tbl_value_classes_tbl_value_categories" foreign key ("value_category_id") references "tbl_value_categories" ("value_category_id");
        alter table "tbl_value_classes" add constraint "fk_tbl_value_classes_tbl_value_types" foreign key ("value_type_id") references "tbl_value_types" ("value_type_id");
        alter table "tbl_value_types" add constraint "fk_tbl_analysis_value_types_tbl_units" foreign key ("unit_id") references "tbl_units" ("unit_id");
        alter table "tbl_value_types" add constraint "fk_tbl_analysis_value_types_tbl_data_types" foreign key ("data_type_id") references "tbl_data_types" ("data_type_id");

        comment on table "tbl_value_classes" is 'this entity represents descriptive information of a "column" in the numerical values stored as a spreadsheet paradigm.';

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
