-- Deploy facet: 20250402_DML_ADNA_DOMAIN_FACET

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2025-04-02
  Description   Domain facet for aDNA
  Issue         https://github.com/humlab-sead/sead_change_control/issues/369
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
    declare v_methods_sql text;
begin

    set search_path = facet, pg_catalog;
    set default_with_oids = false;
    set statement_timeout = 0;
    set lock_timeout = 0;
    set client_encoding = 'UTF8';
    set standard_conforming_strings = on;
    set check_function_bodies = false;
    set client_min_messages = warning;
    
    v_methods_sql = 'tbl_datasets.method_id in (
    select m.method_id
    from tbl_methods m
    join tbl_record_types r using (record_type_id)
    where r.record_type_name = ''DNA''
)';


	s_facets = format(
$facets$[
	{
		"facet_id": null,
		"facet_code": "adna",
		"display_title": "aDNA",
		"description": "Ancient DNA domain facet",
		"facet_group_id":"999",
		"facet_type_id": 1,
		"category_id_expr": "tbl_datasets.dataset_id",
		"category_id_type": "integer",
        "category_id_operator": "=",
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
			"clause": "%s",
            "enforce_constraint": true
		}
	]
	}
]$facets$,
    replace(v_methods_sql, E'\n', ' ')
);

	j_facets = s_facets::jsonb;

	perform facet.create_or_update_facet(v.facet::jsonb)
	from jsonb_array_elements(j_facets) as v(facet);


	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'adna', facet_code, position
		from facet.facet
		join (values
			('activeseason', 6),
			('feature_type', 11),
			('tbl_biblio_modern', 12),
			('country', 14),
			('sites', 15),
			('region', 16),
			('sample_groups', 17),
			('sample_group_sampling_contexts', 18),
			('data_types', 19),
            ('relative_age_name', 20),
            ('record_types', 21),
            ('dataset_provider', 22),
            ('location_types', 23),
            ('constructions', 24),
            ('sites_polygon', 25),
            ('species', 26)
		) as v(facet_code, position) using (facet_code)
		where is_applicable = TRUE;

end $$;


commit;
