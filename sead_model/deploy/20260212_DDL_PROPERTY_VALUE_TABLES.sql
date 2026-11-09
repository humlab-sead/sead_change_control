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
    drop table if exists tbl_feature_properties cascade;
    drop table if exists tbl_site_properties cascade;
    drop table if exists tbl_abundance_properties cascade;
    drop table if exists tbl_property_types cascade;
    drop table if exists tbl_property_type_groups cascade;
    
    create table  tbl_property_type_groups (
        "property_type_group_id" serial primary key,
        "property_type_group" text not null,
        "property_type_group_abbrev" text not null unique,
        "description" text not null
    );

    create table tbl_property_types (
        "property_type_id" serial primary key,
        "uuid" uuid not null unique default gen_random_uuid(),
        "property_scope" text not null default 'global',
        "property_type_name" text not null unique,
        "description" text not null,
        "property_type_group_id" int not null references tbl_property_type_groups("property_type_group_id") on delete cascade,
        "value_type_id" int null references tbl_value_types("value_type_id") on delete cascade,
        "value_class_id" int null references tbl_value_classes("value_class_id") on delete cascade
    );

    -- serialized value stored as text, can be deserialized based on the property type

    create table tbl_site_properties (
        "site_property_id" serial primary key,
        "site_id" integer not null references tbl_sites("site_id") on delete cascade,
        "property_type_id" int not null references tbl_property_types("property_type_id") on delete cascade,
        "property_value" text not null 
    );


    create table tbl_abundance_properties (
        "abundance_property_id" serial primary key,
        "abundance_id" integer not null references tbl_abundances("abundance_id") on delete cascade,
        "property_type_id" int not null references tbl_property_types("property_type_id") on delete cascade,
        "property_value" text not null
    );

    create table tbl_feature_properties (
        "feature_property_id" serial primary key,
        "feature_id" integer not null references tbl_features("feature_id") on delete cascade,
        "property_type_id" int not null references tbl_property_types("property_type_id") on delete cascade,
        "property_value" text not null 
    );

    insert into tbl_property_type_groups ("property_type_group", "property_type_group_abbrev", "description")
        values ('Unspecified Group', 'DEFAULT', 'Unspecified property type group');

    insert into tbl_property_types ("property_type_name", "description", "property_type_group_id")
        values ('Unspecified Property Type', 'Unspecified property type', 1);

    comment on table tbl_property_type_groups is
        'Stores groups used to organize property type definitions.';
    comment on column tbl_property_type_groups.property_type_group_id is
        'Primary key (automatically incremented).';
    comment on column tbl_property_type_groups.property_type_group is
        'Name of the property type group.';
    comment on column tbl_property_type_groups.property_type_group_abbrev is
        'Unique abbreviated code used to identify the property type group.';
    comment on column tbl_property_type_groups.description is
        'Description of the property type group.';

    comment on table tbl_property_types is
        'Defines property types, their scope, and optional metadata used to interpret their values.';
    comment on column tbl_property_types.property_type_id is
        'Primary key (automatically incremented).';
    comment on column tbl_property_types.uuid is
        'Unique UUID generated for the property type.';
    comment on column tbl_property_types.property_scope is
        'Scope in which the property type applies. The default scope is global.';
    comment on column tbl_property_types.property_type_name is
        'Unique name of the property type.';
    comment on column tbl_property_types.description is
        'Description of the property type and the information it represents.';
    comment on column tbl_property_types.property_type_group_id is
        'Identifies the group to which this property type belongs.';
    comment on column tbl_property_types.value_type_id is
        'Identifies the value type used to interpret the property value, when specified.';
    comment on column tbl_property_types.value_class_id is
        'Identifies the value class used to interpret the property value, when specified.';

    comment on table tbl_site_properties is
        'Stores property values assigned to sites.';
    comment on column tbl_site_properties.site_property_id is
        'Primary key (automatically incremented).';
    comment on column tbl_site_properties.site_id is
        'Identifies the site assigned this property value.';
    comment on column tbl_site_properties.property_type_id is
        'Identifies the type that defines and describes this property value.';
    comment on column tbl_site_properties.property_value is
        'Property value stored as text. Its format is determined by the associated property type.';

    comment on table tbl_abundance_properties is
        'Stores property values assigned to abundance records.';
    comment on column tbl_abundance_properties.abundance_property_id is
        'Primary key (automatically incremented).';
    comment on column tbl_abundance_properties.abundance_id is
        'Identifies the abundance record assigned this property value.';
    comment on column tbl_abundance_properties.property_type_id is
        'Identifies the type that defines and describes this property value.';
    comment on column tbl_abundance_properties.property_value is
        'Property value stored as text. Its format is determined by the associated property type.';

    comment on table tbl_feature_properties is
        'Stores property values assigned to features.';
    comment on column tbl_feature_properties.feature_property_id is
        'Primary key (automatically incremented).';
    comment on column tbl_feature_properties.feature_id is
        'Identifies the feature assigned this property value.';
    comment on column tbl_feature_properties.property_type_id is
        'Identifies the type that defines and describes this property value.';
    comment on column tbl_feature_properties.property_value is
        'Property value stored as text. Its format is determined by the associated property type.';

commit;
