-- Deploy sead_api: 20200120_DML_ADD_DOMAIN_FACETS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
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

    set search_path = facet, pg_catalog;
    set default_with_oids = false;
    set statement_timeout = 0;
    set lock_timeout = 0;
    set client_encoding = 'UTF8';
    set standard_conforming_strings = on;
    set check_function_bodies = false;
    set client_min_messages = warning;

    insert into facet.facet_group(
	    facet_group_id, facet_group_key, display_title, description, is_applicable, is_default)
     values (999, 'DOMAIN', 'Domain facets', 'DOMAIN', false, false)
        on conflict (facet_group_id) do nothing;

    delete from  facet.facet_children;
    
    /*
    select master_set_id, array_agg(distinct ds.method_id)
    from public.tbl_datasets ds
    join public.tbl_dataset_masters mds using (master_set_id)
    group by master_set_id
    */

	s_facets = $facets$

[
	{
		"facet_id": 1001,
		"facet_code": "palaeoentomology",
		"display_title": "Palaeoentomology",
		"description": "Palaeoentomology domain facet",
		"facet_group_id":"999",
		"facet_type_id": 1,
		"category_id_expr": "tbl_datasets.dataset_id",
		"category_name_expr": "tbl_datasets.dataset_name ",
		"sort_expr": "tbl_datasets.dataset_name",
		"is_applicable": false,
		"is_default": false,
		"aggregate_type": "count",
		"aggregate_title": "Number of datasets",
		"aggregate_facet_code": "result_facet",
		"tables": [
            {
                "sequence_id": 1,
                "table_name": "tbl_datasets",
                "udf_call_arguments": null,
                "alias":  null
            }
        ],
		"clauses": [
		{
			"clause": "tbl_datasets.method_id in (3, 6)",
            "enforce_constraint": true
		}
	]
	},
	{
		"facet_id": 1002,
		"facet_code": "archaeobotany",
		"display_title": "Archaeobotany",
		"description": "Archaeobotany domain facet",
		"facet_group_id":"999",
		"facet_type_id": 1,
		"category_id_expr": "tbl_datasets.dataset_id",
		"category_name_expr": "tbl_datasets.dataset_name ",
		"sort_expr": "tbl_datasets.dataset_name",
		"is_applicable": false,
		"is_default": false,
		"aggregate_type": "count",
		"aggregate_title": "Number of datasets",
		"aggregate_facet_code": "result_facet",
		"tables": [
            {
                "sequence_id": 1,
                "table_name": "tbl_datasets",
                "udf_call_arguments": null,
                "alias":  null
            }
        ],
		"clauses": [
		{
			"clause": "tbl_datasets.method_id in (4, 8)",
            "enforce_constraint": true
		}
		]
	},
	{
		"facet_id": 1003,
		"facet_code": "pollen",
		"display_title": "Pollen",
		"description": "Pollen domain facet",
		"facet_group_id":"999",
		"facet_type_id": 1,
		"category_id_expr": "tbl_datasets.dataset_id",
		"category_name_expr": "tbl_datasets.dataset_name ",
		"sort_expr": "tbl_datasets.dataset_name",
		"is_applicable": false,
		"is_default": false,
		"aggregate_type": "count",
		"aggregate_title": "Number of datasets",
		"aggregate_facet_code": "result_facet",
		"tables": [
            {
                "sequence_id": 1,
                "table_name": "tbl_datasets",
                "udf_call_arguments": null,
                "alias":  null
            }
        ],
		"clauses": [
		{
			"clause": "tbl_datasets.method_id in (14, 15, 21)",
            "enforce_constraint": true
		}
		]
	},
	{
		"facet_id": 1004,
		"facet_code": "geoarchaeology",
		"display_title": "Geoarchaeology",
		"description": "Geoarchaeology domain facet",
		"facet_group_id":"999",
		"facet_type_id": 1,
		"category_id_expr": "tbl_datasets.dataset_id",
		"category_name_expr": "tbl_datasets.dataset_name ",
		"sort_expr": "tbl_datasets.dataset_name",
		"is_applicable": false,
		"is_default": false,
		"aggregate_type": "count",
		"aggregate_title": "Number of datasets",
		"aggregate_facet_code": "result_facet",
		"tables": [
            {
                "sequence_id": 1,
                "table_name": "tbl_datasets",
                "udf_call_arguments": null,
                "alias":  null
            }
        ],
		"clauses": [
		{
			"clause": "tbl_datasets.method_id in (32, 33, 35, 36, 37, 94, 106)",
            "enforce_constraint": true
		}
		]
	},
	{
		"facet_id": 1005,
		"facet_code": "dendrochronology",
		"display_title": "Dendrochronology",
		"description": "Dendrochronology domain facet",
		"facet_group_id":"999",
		"facet_type_id": 1,
		"category_id_expr": "tbl_datasets.dataset_id",
		"category_name_expr": "tbl_datasets.dataset_name ",
		"sort_expr": "tbl_datasets.dataset_name",
		"is_applicable": false,
		"is_default": false,
		"aggregate_type": "count",
		"aggregate_title": "Number of datasets",
		"aggregate_facet_code": "result_facet",
		"tables": [
            {
                "sequence_id": 1,
                "table_name": "tbl_datasets",
                "udf_call_arguments": null,
                "alias":  null
            }
        ],
		"clauses": [
		{
			"clause": "tbl_datasets.method_id in (10)",
            "enforce_constraint": true
		}
		]
	},
	{
		"facet_id": 1006,
		"facet_code": "ceramic",
		"display_title": "Ceramic",
		"description": "Ceramic domain facet",
		"facet_group_id":"999",
		"facet_type_id": 1,
		"category_id_expr": "tbl_datasets.dataset_id",
		"category_name_expr": "tbl_datasets.dataset_name ",
		"sort_expr": "tbl_datasets.dataset_name",
		"is_applicable": false,
		"is_default": false,
		"aggregate_type": "count",
		"aggregate_title": "Number of datasets",
		"aggregate_facet_code": "result_facet",
		"tables": [
            {
                "sequence_id": 1,
                "table_name": "tbl_datasets",
                "udf_call_arguments": null,
                "alias":  null
            }
        ],
		"clauses": [
		{
			"clause": "tbl_datasets.method_id in (172, 171)",
            "enforce_constraint": true
		}
		]
	},
	{
		"facet_id": 1007,
		"facet_code": "isotope",
		"display_title": "Isotope",
		"description": "Isotope domain facet",
		"facet_group_id":"999",
		"facet_type_id": 1,
		"category_id_expr": "tbl_datasets.dataset_id",
		"category_name_expr": "tbl_datasets.dataset_name ",
		"sort_expr": "tbl_datasets.dataset_name",
		"is_applicable": false,
		"is_default": false,
		"aggregate_type": "count",
		"aggregate_title": "Number of datasets",
		"aggregate_facet_code": "result_facet",
		"tables": [
            {
                "sequence_id": 1,
                "table_name": "tbl_datasets",
                "udf_call_arguments": null,
                "alias":  null
            }
        ],
		"clauses": [
		{
			"clause": "tbl_datasets.method_id in (175)",
            "enforce_constraint": true
		}
		]
	}
]

$facets$;

	j_facets = s_facets::jsonb;

	perform facet.create_or_update_facet(v.facet::jsonb)
	from jsonb_array_elements(j_facets) as v(facet);

    update facet.facet_clause
        set enforce_constraint = TRUE
        where facet_id in (select facet_id from facet.facet where facet_group_id = 999);


end $$;

commit;

