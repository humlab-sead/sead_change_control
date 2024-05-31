-- Deploy facet: 20240404_DDL_ANALYSIS_AGES_FACET

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-04-04
  Description   Analysis ages range intersect facet.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/
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
begin

    set client_encoding = 'UTF8';

    s_facets = $facets$
    [
        {
            "facet_id": 52,
            "facet_code": "analysis_entity_ages",
            "display_title": "Analysis entity ages",
            "description": "Analysis entity ages (intersects)",
            "facet_group_id":"2",
            "facet_type_id": 4,
            "category_id_expr": "age_range",
            "category_id_type": "int4range",
            "category_id_operator": "&&",
            "category_name_expr": "age_range",
            "sort_expr": "1",
            "is_applicable": true,
            "is_default": true,
            "aggregate_type": "count",
            "aggregate_title": "Number of samples",
            "aggregate_facet_code": "result_facet",
            "tables": [
                {
                    "sequence_id": 1,
                    "table_name": "tbl_analysis_entity_ages",
                    "udf_call_arguments": null,
                    "alias":  null
                } ],
            "clauses": [  ]
        }
    ]

$facets$;

    j_facets = s_facets::jsonb;

    perform facet.create_or_update_facet(v.facet::jsonb)
    from jsonb_array_elements(j_facets) as v(facet);

end $$;
commit;
