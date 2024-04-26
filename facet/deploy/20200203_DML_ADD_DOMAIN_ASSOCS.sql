-- Deploy sead_api: 20200203_DML_ADD_DOMAIN_ASSOCS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2020-02-03
  Description   New domain facets associations
  Issue         https://github.com/humlab-sead/sead_change_control/issues/149
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

        set search_path = facet, pg_catalog;
        set client_encoding = 'UTF8';

        delete from  facet.facet_children;

        if current_database() not like 'sead_staging%' then
            raise exception 'This script must be run in sead_staging!';
        end if;

		s_facets = $facets$
        [
            {
                "facet_id": 42,
                "facet_code": "data_types",
                "display_title": "Data types",
                "description": "Data types",
                "facet_group_id":"1",
                "facet_type_id": 1,
                "category_id_expr": "tbl_data_types.data_type_id",
        		"category_id_type": "integer",
                "category_name_expr": "tbl_data_types.data_type_name",
                "sort_expr": "tbl_data_types.data_type_name",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [ {
                    "sequence_id": 1,
                    "table_name": "tbl_data_types",
                    "udf_call_arguments": null,
                    "alias":  null
                } ],
                "clauses": [  ]
            },

            {
                "facet_id": 43,
                "facet_code": "rdb_systems",
                "display_title": "RDB system",
                "description": "RDB system",
                "facet_group_id":"1",
                "facet_type_id": 1,
                "category_id_expr": "tbl_rdb_systems.rdb_system_id",
        		"category_id_type": "integer",
                "category_name_expr": "tbl_rdb_systems.rdb_system",
                "sort_expr": "tbl_rdb_systems.rdb_system",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [ {
                    "sequence_id": 1,
                    "table_name": "tbl_rdb_systems",
                    "udf_call_arguments": null,
                    "alias":  null
                } ],
                "clauses": [  ]
            },

            {
                "facet_id": 44,
                "facet_code": "rdb_codes",
                "display_title": "RDB Code",
                "description": "RDB Code",
                "facet_group_id":"1",
                "facet_type_id": 1,
                "category_id_expr": "tbl_rdb_codes.rdb_code_id",
        		"category_id_type": "integer",
                "category_name_expr": "tbl_rdb_codes.rdb_definition",
                "sort_expr": "tbl_rdb_codes.rdb_definition",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [ {
                    "sequence_id": 1,
                    "table_name": "tbl_rdb_codes",
                    "udf_call_arguments": null,
                    "alias":  null
                } ],
                "clauses": [  ]
            },

            {
                "facet_id": 45,
                "facet_code": "modification_types",
                "display_title": "Modification Types",
                "description": "Modification Types",
                "facet_group_id":"1",
                "facet_type_id": 1,
                "category_id_expr": "tbl_modification_types.modification_type_id",
        		"category_id_type": "integer",
                "category_name_expr": "tbl_modification_types.modification_type_name",
                "sort_expr": "tbl_modification_types.modification_type_name",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [ {
                    "sequence_id": 1,
                    "table_name": "tbl_modification_types",
                    "udf_call_arguments": null,
                    "alias":  null
                } ],
                "clauses": [  ]
            },

            {
                "facet_id": 46,
                "facet_code": "abundance_elements",
                "display_title": "Abundance Elements",
                "description": "Abundance Elements",
                "facet_group_id":"1",
                "facet_type_id": 1,
                "category_id_expr": "tbl_abundance_elements.abundance_element_id",
        		"category_id_type": "integer",
                "category_name_expr": "tbl_abundance_elements.element_name",
                "sort_expr": "tbl_abundance_elements.element_name",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_abundance_elements",
                        "udf_call_arguments": null,
                        "alias":  null
                    }, {
                        "sequence_id": 2,
                        "table_name": "tbl_abundances",
                        "udf_call_arguments": null,
                        "alias":  null
                    }
                ],
                "clauses": [  ]
            },
            {
                "facet_id": 47,
                "facet_code": "sample_group_sampling_contexts",
                "display_title": "Sampling Contexts",
                "description": "Sampling Contexts",
                "facet_group_id":"1",
                "facet_type_id": 1,
                "category_id_expr": "tbl_sample_group_sampling_contexts.sampling_context_id",
        		"category_id_type": "integer",
                "category_name_expr": "tbl_sample_group_sampling_contexts.sampling_context",
                "sort_expr": "tbl_sample_group_sampling_contexts.sort_order",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [ {
                        "sequence_id": 1,
                        "table_name": "tbl_sample_group_sampling_contexts",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "tbl_sample_groups",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 3,
                        "table_name": "tbl_physical_samples",
                        "udf_call_arguments": null,
                        "alias":  null
                    }
                 ],
                "clauses": [  ]
            }

        ]
$facets$;

	j_facets = s_facets::jsonb;

	PERFORM facet.create_or_update_facet(v.facet::jsonb)
	from jsonb_array_elements(j_facets) as v(facet);

    -- with facet_relation as (
    --     select facet_code, unnest(domain_codes) as domain_code, position
    --     from ( values
    --         (1, 'data_types', ARRAY [ 'palaeoentomology', 'archaeobotany', 'pollen', 'geoarchaeology', 'dendrochronology', 'ceramic' ]),
    --         (2, 'rdb_systems', ARRAY [ 'palaeoentomology' ]),
    --         (3, 'rdb_codes', ARRAY [ 'palaeoentomology']),
    --         (4, 'modification_types', ARRAY [ 'archaeobotany'])
    --     ) as x(position, facet_code, domain_codes)
    -- ) insert into facet.facet_children (facet_code, child_facet_code, position)
    -- select r.domain_code, r.facet_code, r.position
    -- from facet_relation r
    -- join facet.facet domain_facet
    --     on domain_facet.facet_code = r.domain_code
    -- --join facet.facet user_facet on user_facet.facet_code = r.facet_code
    -- left join facet.facet_children x
    --     on x.facet_code = r.domain_code
    -- and x.child_facet_code = r.facet_code
    -- where x.facet_code is null;

   exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;

-- "record_types"
-- "abundance_classification"
-- "tbl_biblio_sample_groups"
-- "tbl_biblio_sites"
-- "dataset_master"
-- "dataset_methods"
-- "region"

begin;

do $$

    declare s_facets text;
    declare j_facets jsonb;

    begin

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'palaeoentomology', facet_code, position
		from facet.facet
		join (values
			('ecocode_system', 1),
			('ecocode', 2),
			('abundances_all', 3),
			('geochronology', 4),
			('relative_age_name', 5),
			('activeseason', 6),
			('family', 7),
			('genus', 8),
			('species', 9),
			('species_author', 10),
			('feature_type', 11),
			('tbl_biblio_modern', 12),
			-- ('Bibligraphy fossil', 13), -- missing
			('country', 14),
			('sites', 15),
			('sample_groups', 16),
			('rdb_systems', 17), -- missing fungerar på samma sätt som ecocodes',
			('rdb_codes', 18), -- missing fungerar på samma sätt som ecocodes',
			-- ('Analysis entity ages', 19), -- missing
			('sample_group_sampling_contexts', 20), -- missing
			('data_types', 21) -- missing
		) as v(facet_code, position) using (facet_code)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'archaeobotany', facet_code, position
		from facet.facet
		join (values
			('ecocode_system', 1),
			('ecocode', 2),
			('abundances_all', 3),
			('geochronology', 4),
			('relative_age_name', 5),
			('activeseason', 6),
			('family', 7),
			('genus', 8),
			('species', 9),
			('species_author', 10),
			('feature_type', 11),
			('tbl_biblio_modern', 12),
			-- ('Bibligraphy fossil', 13), -- missing
			('country', 14),
			('sites', 15),
			('sample_groups', 16),
			-- ('Analysis entity ages', 19), -- missing
			('sample_group_sampling_contexts', 20), -- missing
			('data_types', 21), -- missing
			('modification_types', 22), -- missing
			('abundance_elements', 23) -- missing
		) as v(facet_code, position) using (facet_code)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'pollen', facet_code, position
		from facet.facet
		join (values
			('ecocode_system', 1),
			('ecocode', 2),
			('abundances_all', 3),
			('geochronology', 4),
			('relative_age_name', 5),
			('activeseason', 6),
			('family', 7),
			('genus', 8),
			('species', 9),
			('species_author', 10),
			('feature_type', 11),
			('tbl_biblio_modern', 12),
			-- ('Bibligraphy fossil', 13), -- missing
			('country', 14),
			('sites', 15),
			('sample_groups', 16),
			-- ('Analysis entity ages', 19), -- missing
			('sample_group_sampling_contexts', 20), -- missing
			('data_types', 21), -- missing
			('abundance_elements', 23) -- missing
		) as v(facet_code, position) using (facet_code)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'geoarchaeology', facet_code, position
		from facet.facet
		join (values
			('tbl_denormalized_measured_values_33_82', 1),
			('tbl_denormalized_measured_values_37', 2),
			('geochronology', 3),
			('relative_age_name', 4),
			('feature_type', 5),
			('tbl_biblio_modern', 6),
			-- ('Bibligraphy fossil', 7), -- missing
			('country', 8),
			('sites', 9),
			('sample_groups', 10),
			-- ('Analysis entity ages', 11), -- missing
			('sample_group_sampling_contexts', 12), -- missing
			('data_types', 13), -- missing
			('tbl_denormalized_measured_values_32', 14),
			('tbl_denormalized_measured_values_33_0', 15)
		) as v(facet_code, position) using (facet_code)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'dendrochronology', facet_code, position
		from facet.facet
		join (values
			('geochronology', 1),
			('relative_age_name', 2),
			('family', 3),
			('genus', 4),
			('species', 5),
			('species_author', 6),
			('feature_type', 7),
			('tbl_biblio_modern', 8),
			-- ('Bibligraphy fossil', 9), -- missing
			('country', 10),
			('sites', 11),
			('sample_groups', 12),
			-- ('Analysis entity ages', 19), -- missing
			('sample_group_sampling_contexts', 20), -- missing
			('data_types', 21) -- missing
		) as v(facet_code, position) using (facet_code)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'ceramic', facet_code, position
		from facet.facet
		join (values
			('geochronology', 1),
			('relative_age_name', 2),
			('feature_type', 7),
			('tbl_biblio_modern', 8),
			-- ('Bibligraphy fossil', 9), -- missing
			('country', 10),
			('sites', 11),
			('sample_groups', 12),
			-- ('Analysis entity ages', 19), -- missing
			('sample_group_sampling_contexts', 20), -- missing
			('data_types', 21) -- missing
		) as v(facet_code, position) using (facet_code)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'isotope', facet_code, position
		from facet.facet
		join (values
			('relative_age_name', 2),
			('feature_type', 7),
			('tbl_biblio_modern', 8),
			-- ('Bibligraphy fossil', 9), -- missing
			('country', 10),
			('sites', 11),
			('sample_groups', 12),
			-- ('Analysis entity ages', 19), -- missing
			('sample_group_sampling_contexts', 20), -- missing
			('data_types', 21) -- missing
		) as v(facet_code, position) using (facet_code)
		where is_applicable = TRUE;

    /* Change name of two facets */
    update facet.facet set display_title = 'Loss on Ignition' where facet_code = 'tbl_denormalized_measured_values_32' and display_title = 'Loss of Ignition';
    update facet.facet set display_title = 'Taxa' where facet_code = 'species' and display_title = 'Taxon';

    -- ALTER TABLE public.tbl_species_associations DROP CONSTRAINT tbl_species_associations_taxon_id_fkey1;

end $$;

commit;


--    select facet_code, display_title, is_applicable from facet.facet order by display_title

-- with facet_undirected_relations as (
--     select	t1.table_or_udf_name 	as source_name,
--             t2.table_or_udf_name 	as target_name,
--             r.target_column_name    as column_name
--     from facet.table_relation r
--     join facet.table t1 on t1.table_id = r.source_table_id
--     join facet.table t2 on t2.table_id = r.target_table_id
--     where r.source_column_name = r.target_column_name
-- ), facet_relations as (
--     select source_name, target_name, column_name
--     from facet_undirected_relations
--     union all
--     select target_name, source_name, column_name
--     from facet_undirected_relations
-- ) select *
--   from facet_relations
--   order by 1

-- with facet_undirected_relations as (
--     select	t1.table_or_udf_name 	as source_name,
--             t2.table_or_udf_name 	as target_name,
--             r.target_column_name    as column_name
--     from facet.table_relation r
--     join facet.table t1 on t1.table_id = r.source_table_id
--     join facet.table t2 on t2.table_id = r.target_table_id
--     where r.source_column_name = r.target_column_name
-- ), facet_relations as (
--     select source_name, target_name, column_name
--     from facet_undirected_relations
--     union all
--     select target_name, source_name, column_name
--     from facet_undirected_relations
-- ) select *
--   from facet_relations
--   order by 1

/*
select  ' | ' || domain_code ||
        ' | ' || doman_display_name ||
        ' | ' || facet_code  ||
        ' | ' || display_title ||
        ' | ' || position::text ||
        ' | ' || status || ' | '
from (
select  d.facet_code as domain_code,
        d.display_title as "doman_display_name",
        c.facet_code,
        c.display_title,
        r.position,
        case when c.facet_id >= 42 then 'NEW!' else '' end as status
from facet.facet d
join facet.facet_children r on r.facet_code = d.facet_code
join facet.facet c on c.facet_code = r.child_facet_code
where d.facet_group_id = 999
order by 1, 5
) as X

*/
