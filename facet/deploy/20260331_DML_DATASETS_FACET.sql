-- Deploy facet: 20260331_DML_DATASETS_FACET

/****************************************************************************************************************
  Author        Johan
  Date          2026-03-31
  Description   Add datasets facet from tbl_datasets and associate with all domain facets
  Issue         Local-only change (no GitHub issue yet)
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;

do $$
declare s_facets text;
declare j_facets jsonb;
declare i_facet_id int;
begin

    set search_path = facet, pg_catalog;
    set client_encoding = 'UTF8';
    set client_min_messages = warning;

    i_facet_id = coalesce(
        (select max(facet_id) from facet.facet where facet_code = 'datasets'),
        57
    );

    if exists (
        select 1
        from facet.facet
        where facet_id = i_facet_id
          and facet_code <> 'datasets'
    ) then
        i_facet_id = (select coalesce(max(facet_id), 0) + 1 from facet.facet);
    end if;

    s_facets = format(
$facets$
[
    {
        "facet_id": %s,
        "facet_code": "datasets",
        "display_title": "Datasets",
        "description": "Datasets",
        "facet_group_id":"2",
        "facet_type_id": 1,
        "category_id_expr": "tbl_datasets.dataset_id",
        "category_id_type": "integer",
        "category_id_operator": "=",
        "category_name_expr": "tbl_datasets.dataset_name",
        "sort_expr": "tbl_datasets.dataset_name",
        "is_applicable": true,
        "is_default": false,
        "aggregate_type": "count",
        "aggregate_title": "Number of analysis entities",
        "aggregate_facet_code": "result_facet",
        "tables": [
            {
                "sequence_id": 1,
                "table_name": "tbl_datasets",
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
        select
            d.facet_code,
            'datasets',
            coalesce(
                (
                    select max(x.position) + 1
                    from facet.facet_children x
                    where x.facet_code = d.facet_code
                ),
                0
            ) as position
        from facet.facet d
        left join facet.facet_children fc
            on fc.facet_code = d.facet_code
           and fc.child_facet_code = 'datasets'
        where d.facet_group_id = 999
          and fc.facet_code is null
        on conflict (facet_code, child_facet_code)
        do nothing;

end $$;

commit;
