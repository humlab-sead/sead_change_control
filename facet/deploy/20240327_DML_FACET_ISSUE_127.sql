-- Deploy facet: 20240327_DML_FACET_ISSUE_127

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-03-27
  Description   Resolves region/country facets conflict
  Issue         https://github.com/humlab-sead/sead_query_api/issues/127
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
declare v_site_table_id int;
declare v_shortcut_table_id int;
begin

    begin

        set search_path = facet, pg_catalog;
        set client_encoding = 'UTF8';

        if current_database() not like 'sead_staging%' then
            raise exception 'This script must be run in sead_staging!';
        end if;

        /* Create a shortcut route between sites and locations */
        create or replace view facet.site_location_shortcut as
            select sl.site_id, l.location_id, l.location_name, l.location_type_id, l.default_lat_dd, l.default_long_dd, l.date_updated
            from public.tbl_site_locations sl
            join public.tbl_locations l using (location_id);


		/* Drop table if exists */
		v_shortcut_table_id = (select max(table_id) from facet.table where table_or_udf_name = 'facet.site_location_shortcut');
		if v_shortcut_table_id is not null then
			delete from facet.table_relation
				where table_relation_id in (
					select table_relation_id
					from facet.table_relation
					where v_shortcut_table_id in (source_table_id, target_table_id)
				);
			delete from facet.table where table_id = v_shortcut_table_id;
		end if;

        v_site_table_id = (select max(table_id) from facet.table where table_or_udf_name = 'tbl_sites');
        v_shortcut_table_id = (select max(table_id) + 1 from facet.table);

        /* Add the shortcut to the facet tables */
        insert into facet.table(table_id, schema_name, table_or_udf_name, primary_key_name, is_udf)
            values (v_shortcut_table_id, '', 'facet.site_location_shortcut', 'xxxx', false);

        /* Add the relation between sites and locations via new route */
        insert into facet.table_relation (source_table_id, target_table_id, weight, source_column_name, target_column_name)
            values (v_site_table_id /* tbl_sites */, v_shortcut_table_id /* v_shortcut_table_id */, 20, 'site_id', 'site_id');


		s_facets = $facets$
        [
            {
                "facet_id": 21,
                "facet_code": "country",
                "display_title": "Countries",
                "description": "The name of the country, at the time of collection, in which the samples were collected",
                "facet_group_id":"2",
                "facet_type_id": 1,
                "category_id_expr": "countries.location_id",
                "category_id_type": "integer",
                "category_name_expr": "countries.location_name ",
                "sort_expr": "countries.location_name",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "facet.site_location_shortcut",
                        "udf_call_arguments": null,
                        "alias":  "countries"
                    }
				],
                "clauses": [
                    {
                        "clause": "countries.location_type_id=1",
                        "enforce_constraint": true
                    } ]
            },
            {
                "facet_id": 41,
                "facet_code": "region",
                "display_title": "Region",
                "description": "Region",
                "facet_group_id":"2",
                "facet_type_id": 1,
                "category_id_expr": "region.location_id ",
                "category_id_type": "integer",
                "category_name_expr": "region.location_name",
                "sort_expr": "region.location_name",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "facet.site_location_shortcut",
                        "udf_call_arguments": null,
                        "alias":  "region"
                    }],
                "clauses": [
                    {
                        "clause": "region.location_type_id in (2, 7, 14, 16, 18)",
                        "enforce_constraint": true
                    } ]
            }
        ]

$facets$;

        /* Add normal facets */
        j_facets = s_facets::jsonb;

        perform facet.create_or_update_facet(v.facet::jsonb)
            from jsonb_array_elements(j_facets) as v(facet);

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
