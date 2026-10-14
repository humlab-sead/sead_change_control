-- Deploy facet: 20261006_DML_CERAMIC_TEMPERING_FACET

/****************************************************************************************************************
  Author        Johan von Boer
  Date          2026-10-06
  Description   New discrete facet "Tempering" listing the temper types identified in a ceramic sherd's fabric,
                added to the ceramic domain.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/458
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes         The "Tempering: ..." ceramics lookups are presence/absence observations with free-text values
                (e.g. "Granit", "Sandsten", "nej", "NEJ"). A temper counts as present unless its value is a
                negative or not-observed one. "Tempering: Max Grain Size" is numeric and is left out.
                The helper view relates to tbl_analysis_entities only, so that the domain clause on tbl_datasets
                applies to the ceramic analysis entity (tbl_ceramics_lookup has an edge to tbl_methods, which
                must not be used to reach tbl_datasets).
*****************************************************************************************************************/

begin;

do $$
declare s_facets text;
declare j_facets jsonb;
declare i_facet_id int;
declare i_table_id int;
declare i_analysis_entity_table_id int;
begin

    set client_encoding = 'UTF8';
    set client_min_messages = warning;

    create or replace view facet.ceramic_tempering as
        select c.analysis_entity_id,
               cl.ceramics_lookup_id as tempering_id,
               trim(substr(cl.name, length('Tempering:') + 1)) as tempering_name
        from public.tbl_ceramics c
        join public.tbl_ceramics_lookup cl using (ceramics_lookup_id)
        where cl.name like 'Tempering:%'
          and cl.name <> 'Tempering: Max Grain Size'
          and lower(trim(c.measurement_value)) not in ('', 'nej', 'ej obs.');

    i_table_id = (select table_id from facet.table where table_or_udf_name = 'facet.ceramic_tempering');

    if i_table_id is null then
        i_table_id = (select coalesce(max(table_id), 0) + 1 from facet.table);
        insert into facet.table (table_id, schema_name, table_or_udf_name, primary_key_name, is_udf)
            values (i_table_id, '', 'facet.ceramic_tempering', 'tempering_id', false);
    end if;

    i_analysis_entity_table_id = (select table_id from facet.table where table_or_udf_name = 'tbl_analysis_entities');

    if not exists (
        select 1
        from facet.table_relation
        where source_table_id = i_table_id
          and target_table_id = i_analysis_entity_table_id
    ) then
        insert into facet.table_relation (source_table_id, target_table_id, weight, source_column_name, target_column_name)
            values (i_table_id, i_analysis_entity_table_id, 20, 'analysis_entity_id', 'analysis_entity_id');
    end if;

    i_facet_id = coalesce(
        (select facet_id from facet.facet where facet_code = 'ceramic_tempering'),
        (select coalesce(max(facet_id), 0) + 1 from facet.facet where facet_id < 1000)
    );

    s_facets = format(
$facets$
[
    {
        "facet_id": %s,
        "facet_code": "ceramic_tempering",
        "display_title": "Tempering",
        "description": "Temper types identified in the fabric of ceramic sherds, e.g. granite, chamotte, sand or organic material",
        "facet_group_id": "5",
        "facet_type_id": 1,
        "category_id_expr": "facet.ceramic_tempering.tempering_id",
        "category_id_type": "integer",
        "category_id_operator": "=",
        "category_name_expr": "facet.ceramic_tempering.tempering_name",
        "sort_expr": "facet.ceramic_tempering.tempering_name",
        "is_applicable": true,
        "is_default": false,
        "aggregate_type": "count",
        "aggregate_title": "Number of analysis entities",
        "aggregate_facet_code": "result_facet",
        "tables": [
            {
                "sequence_id": 1,
                "table_name": "facet.ceramic_tempering",
                "udf_call_arguments": null,
                "alias": null
            }
        ],
        "clauses": []
    }
]
$facets$,
        i_facet_id
    );

    j_facets = s_facets::jsonb;

    perform facet.create_or_update_facet(v.facet::jsonb)
    from jsonb_array_elements(j_facets) as v(facet);

    insert into facet.facet_children (facet_code, child_facet_code, position)
        select 'ceramic',
               'ceramic_tempering',
               coalesce((select max(c.position) + 1 from facet.facet_children c where c.facet_code = 'ceramic'), 0)
        on conflict (facet_code, child_facet_code) do nothing;

end $$;

commit;
