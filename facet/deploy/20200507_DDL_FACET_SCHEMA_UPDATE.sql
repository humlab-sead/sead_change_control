-- Deploy sead_api: 20200507_DDL_FACET_SCHEMA_UPDATE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2020-05-07
  Description   Schema improvements / cleanups
  Issue         https://github.com/humlab-sead/sead_change_control/issues/71
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

        if sead_utility.column_exists('facet'::text, 'result_specification'::text, 'specification_key'::text) = TRUE then
            raise exception SQLSTATE 'GUARD';
        end if;

        alter table facet.result_view_type
            add column if not exists result_facet_code varchar(40) not null default(''),
            add column if not exists sql_compiler varchar(80) not null default(''),
            add column if not exists specification_key varchar(40) not null default('');

        update facet.result_view_type
            set result_facet_code = 'result_facet', sql_compiler = 'TabularResultSqlCompiler', specification_key = 'site_level'
                where view_type_id = 'tabular';

        update facet.result_view_type
            set result_facet_code = 'map_result', sql_compiler = 'MapResultSqlCompiler', specification_key = 'map_result'
                where view_type_id = 'map';

        alter table if exists facet.result_aggregate
            rename to result_specification;

        alter table if exists facet.result_aggregate_field
            rename to result_specification_field;

        alter table facet.result_specification
            rename column aggregate_key to specification_key;

        alter table facet.result_specification
            rename column aggregate_id to specification_id;

        alter table facet.result_specification
            drop column input_type,
            drop column has_selector;

        alter table facet.result_specification_field
            rename column aggregate_field_id to specification_field_id;

        alter table facet.result_specification_field
            rename column aggregate_id to specification_id;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
