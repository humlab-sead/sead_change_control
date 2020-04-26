-- Deploy sead_api:20200120_DML_ADD_DOMAIN_FACETS to pg

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

-- Deploy sead_api:20190101_DML_FACET_SCHEMA to pg

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

    if sead_utility.column_exists('facet', 'result_field', 'datatype') <> TRUE then

        alter table facet.result_field
            add column datatype varchar(40) not null default('text');

        update facet.result_field set datatype = 'text' where result_field_id = 1; -- sitename, tbl_sites.site_name
        update facet.result_field set datatype = 'text' where result_field_id = 2; -- record_type, tbl_record_types.record_type_name
        update facet.result_field set datatype = 'int' where result_field_id = 3; -- analysis_entities, tbl_analysis_entities.analysis_entity_id
        update facet.result_field set datatype = 'int' where result_field_id = 4; -- site_link, tbl_sites.site_id
        update facet.result_field set datatype = 'int' where result_field_id = 5; -- site_link_filtered, tbl_sites.site_id
        update facet.result_field set datatype = 'text' where result_field_id = 6; -- aggregate_all_filtered, 'Aggregated'::text
        update facet.result_field set datatype = 'int' where result_field_id = 7; -- sample_group_link, tbl_sample_groups.sample_group_id
        update facet.result_field set datatype = 'int' where result_field_id = 8; -- sample_group_link_filtered, tbl_sample_groups.sample_group_id
        update facet.result_field set datatype = 'text' where result_field_id = 9; -- abundance, tbl_abundances.abundance
        update facet.result_field set datatype = 'int' where result_field_id = 10; -- taxon_id, tbl_abundances.taxon_id
        update facet.result_field set datatype = 'text' where result_field_id = 11; -- dataset, tbl_datasets.dataset_name
        update facet.result_field set datatype = 'int' where result_field_id = 12; -- dataset_link, tbl_datasets.dataset_id
        update facet.result_field set datatype = 'int' where result_field_id = 13; -- dataset_link_filtered, tbl_datasets.dataset_id
        update facet.result_field set datatype = 'text' where result_field_id = 14; -- sample_group, tbl_sample_groups.sample_group_name
        update facet.result_field set datatype = 'text' where result_field_id = 15; -- methods, tbl_methods.method_name
        update facet.result_field set datatype = 'int' where result_field_id = 18; -- category_id, category_id
        update facet.result_field set datatype = 'text' where result_field_id = 19; -- category_name, category_name
        update facet.result_field set datatype = 'decimal' where result_field_id = 20; -- latitude_dd, latitude_dd
        update facet.result_field set datatype = 'decimal' where result_field_id = 21; -- longitude_dd, longitude_dd

    end if;

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

    /* Add new column that enforces that facets withot picks are involved in query */
	if sead_utility.column_exists('facet', 'result_field', 'datatype') <> TRUE then

        alter table facet.facet_clause
            add column enforce_constraint bool not null default(FALSE);

    end if;

    update facet.facet_clause
        set enforce_constraint = TRUE
        where facet_id in (select facet_id from facet.facet where facet_group_id = 999);


end $$;

commit;

