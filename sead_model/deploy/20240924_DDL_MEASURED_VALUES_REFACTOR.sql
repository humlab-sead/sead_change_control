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

        /* tbl_analysis_values */
    
        create table tbl_analysis_values (
            "analysis_value_id" int primary key,
            "analysis_entity_id" int not null,
            "analysis_value" varchar(256) not null,
            "value_class_id" int not null
        );

        alter table tbl_analysis_values 
            add constraint "fk_analysis_values_analysis_entity_id"
                foreign key ("analysis_entity_id") references tbl_analysis_entities ("analysis_entity_id")
                    on delete no action on update cascade;

        alter table tbl_analysis_values
            add constraint "fk_analysis_values_value_category_id"
                foreign key ("value_category_id") references tbl_value_category ("value_category_id")
                    on delete no action on update cascade;


        alter table tbl_analysis_values
            add constraint "fk_analysis_values_unit_id"
                foreign key ("unit_id") references tbl_units ("unit_id")
                    on delete no action on update cascade;


        alter table tbl_analysis_values
            add constraint "fk_analysis_values_value_type_id"
                foreign key ("value_type_id") references tbl_analysis_value_types ("value_type_id")
                    on delete no action on update cascade;


        alter table tbl_analysis_values
            add constraint "fk_analysis_values_value_class_id"
                foreign key ("value_class_id") references tbl_analysis_value_class ("value_class_id")
                    on delete no action on update cascade;


        /* tbl_analysis_value_types */

        create table tbl_analysis_value_types (
            "value_type_id" int primary key,
            "unit_id" int not null,
            "type_id" int not null, -- What was the perpose of this? Base type??? (int, numeric etc.)
            "description" varchar(256) not null
        );

        alter table tbl_analysis_value_types
            add constraint "fk_analysis_value_types_unit_id"
                foreign key ("unit_id") references tbl_units ("unit_id")
                    on delete no action on update cascade;

        -- alter table tbl_analysis_value_types
        --     add constraint "fk_analysis_value_types_type_id"
        --         foreign key ("type_id") references tbl_???_types ("type_id")
        --             on delete no action on update cascade;


        /* tbl_analysis_values */
    
        create table tbl_analysis_value_class (
            "analysis_value_class_id" int primary key,
            "method_id" int not null,
            "name" varchar(256) not null,
            "description" varchar(1024) not null,
            "date_updated" timestamp with time zone DEFAULT now()
        );

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
