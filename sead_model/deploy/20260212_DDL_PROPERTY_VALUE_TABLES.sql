-- Deploy ./sead_model: 20260212_DDL_PROPERTY_VALUE_TABLES

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2026-02-12
  Description   New tables for storing generic key-value properties
  Issue         https://github.com/humlab-sead/sead_change_control/issues/412
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;

    drop table if exists tbl_site_properties cascade;
    drop table if exists tbl_abundance_properties cascade;
    drop table if exists tbl_property_types cascade;

    create table tbl_property_types (
        "uuid" uuid not null unique default gen_random_uuid(),
        "property_type_id" serial primary key,
        "property_type_name" text not null unique,
        "description" text not null,
        "value_type_id" int null references tbl_value_types("value_type_id") on delete cascade,
        "value_class_id" int null references tbl_value_classes("value_class_id") on delete cascade
    );

    create table tbl_site_properties (
        "site_property_id" serial primary key,
        "site_id" integer not null references tbl_sites("site_id") on delete cascade,
        "property_type_id" int not null references tbl_property_types("property_type_id") on delete cascade,
        "property_value" text not null -- serialized value stored as text, can be deserialized based on the property type
    );


    create table tbl_abundance_properties (
        "abundance_property_id" serial primary key,
        "abundance_id" integer not null references tbl_abundances("abundance_id") on delete cascade,
        "property_type_id" int not null references tbl_property_types("property_type_id") on delete cascade,
        "property_value" text not null -- serialized value stored as text, can be deserialized based on the property type
    );

commit;
