-- Deploy facet: 20240530_DML_CONSTRUCTION_TYPE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-05-30
  Description   New facet Vonstruction Type
  Issue         https://github.com/humlab-sead/sead_change_control/issues/271
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

    begin

    set client_encoding = 'UTF8';

	if exists (select 1 from facet.facet where facet_id = 48 and facet_code = 'construction_type') then
	
		delete from facet.facet_children where child_facet_code = 'construction_type';

	    update facet.facet
	      set facet_code = 'constructions',
	          display_title = 'Constructions',
	          description = 'Constructions'
	        where facet_id = 48;

		insert into facet.facet_children (facet_code, child_facet_code, position)
			values ('dendrochronology', 'constructions', 22);

	end if;

	drop view if exists facet.sample_group_construction_purposes;

    create view facet.sample_group_construction_purposes as 
		with purposes (purpose) as (
	        select distinct group_description as purpose
	        from tbl_sample_group_descriptions
	        where sample_group_description_type_id = 62
			order by 1
		) select row_number() OVER () as purpose_id, purpose
			from purposes;

    insert into facet.table (table_id, schema_name, table_or_udf_name, primary_key_name, is_udf)
        values (177, '', 'facet.sample_group_construction_purposes', 'purpose', false)
            on conflict (table_id) do nothing;

    insert into facet.table_relation (table_relation_id, source_table_id, target_table_id, weight, source_column_name, target_column_name)
        values (237, 130, 177, 25, 'group_description', 'purpose')
            on conflict (table_relation_id) do nothing;
            
    s_facets = $facets$
    [
		{
			"facet_id": 54,
			"facet_code": "construction_purpose",
			"display_title": "Construction purpose",
			"description": "Construction purpose",
			"facet_group_id":"6",
			"facet_type_id": 1,
			"category_id_expr": "facet.sample_group_construction_purposes.purpose_id",
			"category_id_type": "text",
			"category_id_operator": "=",
			"category_name_expr": "facet.sample_group_construction_purposes.purpose",
			"sort_expr": "1",
			"is_applicable": true,
			"is_default": false,
			"aggregate_type": "count",
			"aggregate_title": "Count of Analysis",
			"aggregate_facet_code": "result_facet",
			"tables": [
				{
					"sequence_id": 1,
					"table_name": "facet.sample_group_construction_purposes",
					"udf_call_arguments": null,
					"alias":  null
				},
				{
					"sequence_id": 2,
					"table_name": "tbl_sample_group_descriptions",
					"udf_call_arguments": null,
					"alias":  null
				} ]
		} 
    ]

$facets$;

    j_facets = s_facets::jsonb;

    perform facet.create_or_update_facet(v.facet::jsonb)
    from jsonb_array_elements(j_facets) as v(facet);

	insert into facet.facet_children (facet_code, child_facet_code, position)
		values ('dendrochronology', 'construction_purpose', 22)
            on conflict (facet_code, child_facet_code) do nothing;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
