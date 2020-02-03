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

    begin


        insert into facet.facet_group values (0, 'DOMAIN', 'Domain facets', 'DOMAIN', false, false)
            on conflict (facet_group_id) do nothing;

        /*
        select master_set_id, array_agg(distinct ds.method_id)
        from public.tbl_datasets ds
        join public.tbl_dataset_masters mds using (master_set_id)
        group by master_set_id
        */

        -- select * from public.tbl_dataset_masters mds


        set search_path = facet, pg_catalog;
        set default_with_oids = false;
        set statement_timeout = 0;
        set lock_timeout = 0;
        set client_encoding = 'UTF8';
        set standard_conforming_strings = on;
        set check_function_bodies = false;
        set client_min_messages = warning;

        if current_database() not like 'sead_staging%' then
            raise exception 'This script must be run in sead_staging!';
        end if;

		s_facets = $facets$

[
	{
		"facet_id": 1001,
		"facet_code": "palaeoentomology",
		"display_title": "Palaeoentomology",
		"description": "Palaeoentomology domain facet",
		"facet_group_id":"0",
		"facet_type_id": 1,
		"category_id_expr": "tbl_methods.method_id",
		"category_name_expr": "tbl_methods.method_name ",
		"sort_expr": "tbl_methods.method_name",
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
		},
		{
			"sequence_id": 2,
			"table_name": "tbl_methods",
			"udf_call_arguments": null,
			"alias":  null
		} ],
		"clauses": [
		{
			"clause": "tbl_methods.method_id in (3, 6)"
		}
	]
	},
	{
		"facet_id": 1002,
		"facet_code": "archaeobotany",
		"display_title": "Archaeobotany",
		"description": "Archaeobotany domain facet",
		"facet_group_id":"0",
		"facet_type_id": 1,
		"category_id_expr": "tbl_methods.method_id",
		"category_name_expr": "tbl_methods.method_name ",
		"sort_expr": "tbl_methods.method_name",
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
		},
		{
			"sequence_id": 2,
			"table_name": "tbl_methods",
			"udf_call_arguments": null,
			"alias":  null
		} ],
		"clauses": [
		{
			"clause": "tbl_methods.method_id in (4, 8)"
		}
		]
	},
	{
		"facet_id": 1003,
		"facet_code": "pollen",
		"display_title": "Pollen",
		"description": "Pollen domain facet",
		"facet_group_id":"0",
		"facet_type_id": 1,
		"category_id_expr": "tbl_methods.method_id",
		"category_name_expr": "tbl_methods.method_name ",
		"sort_expr": "tbl_methods.method_name",
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
		},
		{
			"sequence_id": 2,
			"table_name": "tbl_methods",
			"udf_call_arguments": null,
			"alias":  null
		} ],
		"clauses": [
		{
			"clause": "tbl_methods.method_id in (14, 15, 21)"
		}
		]
	},
	{
		"facet_id": 1004,
		"facet_code": "geoarchaeology",
		"display_title": "Geoarchaeology",
		"description": "Geoarchaeology domain facet",
		"facet_group_id":"0",
		"facet_type_id": 1,
		"category_id_expr": "tbl_methods.method_id",
		"category_name_expr": "tbl_methods.method_name ",
		"sort_expr": "tbl_methods.method_name",
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
		},
		{
			"sequence_id": 2,
			"table_name": "tbl_methods",
			"udf_call_arguments": null,
			"alias":  null
		} ],
		"clauses": [
		{
			"clause": "tbl_methods.method_id in (32, 33, 35, 36, 37, 94, 106)"
		}
		]
	},
	{
		"facet_id": 1005,
		"facet_code": "dendrochronology",
		"display_title": "Dendrochronology",
		"description": "Dendrochronology domain facet",
		"facet_group_id":"0",
		"facet_type_id": 1,
		"category_id_expr": "tbl_methods.method_id",
		"category_name_expr": "tbl_methods.method_name ",
		"sort_expr": "tbl_methods.method_name",
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
		},
		{
			"sequence_id": 2,
			"table_name": "tbl_methods",
			"udf_call_arguments": null,
			"alias":  null
		} ],
		"clauses": [
		{
			"clause": "tbl_methods.method_id in (10)"
		}
		]
	},
	{
		"facet_id": 1006,
		"facet_code": "ceramic",
		"display_title": "Ceramic",
		"description": "Ceramic domain facet",
		"facet_group_id":"0",
		"facet_type_id": 1,
		"category_id_expr": "tbl_methods.method_id",
		"category_name_expr": "tbl_methods.method_name ",
		"sort_expr": "tbl_methods.method_name",
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
		},
		{
			"sequence_id": 2,
			"table_name": "tbl_methods",
			"udf_call_arguments": null,
			"alias":  null
		} ],
		"clauses": [
		{
			"clause": "tbl_methods.master_set_id in (select master_set_id from public.tbl_dataset_masters where master_name = 'The Laboratory for Ceramic Research (Lund/KFL)')"
		}
		]
	},
	{
		"facet_id": 1007,
		"facet_code": "isotope",
		"display_title": "Isotope",
		"description": "Isotope domain facet",
		"facet_group_id":"0",
		"facet_type_id": 1,
		"category_id_expr": "tbl_methods.method_id",
		"category_name_expr": "tbl_methods.method_name ",
		"sort_expr": "tbl_methods.method_name",
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
		},
		{
			"sequence_id": 2,
			"table_name": "tbl_methods",
			"udf_call_arguments": null,
			"alias":  null
		} ],
		"clauses": [
		{
			"clause": "tbl_methods.master_set_id in (select master_set_id from public.tbl_dataset_masters where master_name = 'Sample data Isotopes')"
		}
		]
	}
]

$facets$;

	j_facets = s_facets::jsonb;

	PERFORM facet.create_or_update_facet(v.facet::jsonb)
	from jsonb_array_elements(j_facets) as v(facet);



   exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;


	drop table if exists facet.facet_children;

	create table facet.facet_children (
		facet_code character varying not null,
		child_facet_code character varying not null,
		position int not null default(0),
		constraint fk_facet_children_facet_code_facet_code foreign key (facet_code)
			references facet.facet (facet_code) match simple on update no action on delete no action,
		constraint fk_facet_children_child_facet_code_facet_code foreign key (child_facet_code)
			references facet.facet (facet_code) match simple on update no action on delete no action,
		constraint child_facet_pkey primary key (facet_code, child_facet_code)
	);

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'palaeoentomology', facet_code, position
		from facet.facet
		join (values
			('Eco code system', 1),
			('Eco code', 2),
			('Abundances', 3),
			('Geochronology', 4),
			('Time periods', 5),
			('Seasons', 6),
			('Family', 7),
			('Genus', 8),
			('Taxa', 9),
			('Author', 10),
			('Feature type', 11),
			('Bibligraphy modern', 12),
			-- ('Bibligraphy fossil', 13), -- missing
			('Country', 14),
			('Site', 15),
			('Sample group', 16)
			-- ('rdb_system', 17), -- missing fungerar på samma sätt som eco codes',
			-- ('rdb_codes', 18), -- missing fungerar på samma sätt som eco codes',
			-- ('Analysis entity ages', 19), -- missing
			-- ('tbl_sample_group_sampling_contexts', 20), -- missing
			-- ('tbl_data_types', 21) -- missing
		) as v(display_title, position) using (display_title)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'archaeobotany', facet_code, position
		from facet.facet
		join (values
			('Eco code system', 1),
			('Eco code', 2),
			('Abundances', 3),
			('Geochronology', 4),
			('Time periods', 5),
			('Seasons', 6),
			('Family', 7),
			('Genus', 8),
			('Taxa', 9),
			('Author', 10),
			('Feature type', 11),
			('Bibligraphy modern', 12),
			-- ('Bibligraphy fossil', 13), -- missing
			('Country', 14),
			('Site', 15),
			('Sample group', 16)
			-- ('Analysis entity ages', 19), -- missing
			-- ('tbl_sample_group_sampling_contexts', 20), -- missing
			-- ('tbl_data_types', 21), -- missing
			-- ('tbl_modification_types', 22), -- missing
			-- ('tbl_abundance_elements', 23) -- missing
		) as v(display_title, position) using (display_title)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'pollen', facet_code, position
		from facet.facet
		join (values
			('Eco code system', 1),
			('Eco code', 2),
			('Abundances', 3),
			('Geochronology', 4),
			('Time periods', 5),
			('Seasons', 6),
			('Family', 7),
			('Genus', 8),
			('Taxa', 9),
			('Author', 10),
			('Feature type', 11),
			('Bibligraphy modern', 12),
			-- ('Bibligraphy fossil', 13), -- missing
			('Country', 14),
			('Site', 15),
			('Sample group', 16)
			-- ('Analysis entity ages', 19), -- missing
			-- ('tbl_sample_group_sampling_contexts', 20), -- missing
			-- ('tbl_data_types', 21), -- missing
			-- ('tbl_abundance_elements', 23) -- missing
		) as v(display_title, position) using (display_title)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'geoarchaeology', facet_code, position
		from facet.facet
		join (values
			('MS Heating 550', 1),
			('Phosphate p-kvot', 2),
			('Geochronology', 3),
			('Time periods', 4),
			('Feature type', 5),
			('Bibligraphy modern', 6),
			-- ('Bibligraphy fossil', 7), -- missing
			('Country', 8),
			('Site', 9),
			('Sample group', 10),
			-- ('Analysis entity ages', 11), -- missing
			-- ('tbl_sample_group_sampling_contexts', 12), -- missing
			-- ('tbl_data_types', 13), -- missing
			('Loss on ignition', 14),
			('MS', 15)
		) as v(display_title, position) using (display_title)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'dendrochronology', facet_code, position
		from facet.facet
		join (values
			('Geochronology', 1),
			('Time periods', 2),
			('Family', 3),
			('Genus', 4),
			('Taxa', 5),
			('Author', 6),
			('Feature type', 7),
			('Bibligraphy modern', 8),
			-- ('Bibligraphy fossil', 9), -- missing
			('Country', 10),
			('Site', 11),
			('Sample group', 12)
			-- ('Analysis entity ages', 19), -- missing
			-- ('tbl_sample_group_sampling_contexts', 20), -- missing
			-- ('tbl_data_types', 21), -- missing
		) as v(display_title, position) using (display_title)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'ceramic', facet_code, position
		from facet.facet
		join (values
			('Geochronology', 1),
			('Time periods', 2),
			('Feature type', 7),
			('Bibligraphy modern', 8),
			-- ('Bibligraphy fossil', 9), -- missing
			('Country', 10),
			('Site', 11),
			('Sample group', 12)
			-- ('Analysis entity ages', 19), -- missing
			-- ('tbl_sample_group_sampling_contexts', 20), -- missing
			-- ('tbl_data_types', 21), -- missing
		) as v(display_title, position) using (display_title)
		where is_applicable = TRUE;

--select * from facet.facet

end $$;
commit;

