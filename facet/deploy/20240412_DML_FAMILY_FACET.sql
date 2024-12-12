-- Deploy facet: 20240412_DML_FAMILY_FACET

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-04-03
  Description   Review of troublesome existing "family" facet
  Issue         https://github.com/humlab-sead/sead_change_control/issues/273
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;

set search_path = facet, pg_catalog;
set client_encoding = 'UTF8';

do $$
begin

declare s_facets text;
declare j_facets jsonb;
declare v_facet_id int;
declare abundance_table_id int;
declare shortcut_table_id int;
begin

    /*

    FIXME: This facet is NOT Bugs specific!
    */

    DROP VIEW IF EXISTS facet.family_taxon_shortcut;

    CREATE OR REPLACE VIEW facet.family_taxon_shortcut as 
        SELECT family_id, family_name, taxon_id, record_type_id
        FROM public.tbl_taxa_tree_families
        INNER JOIN public.tbl_taxa_tree_orders USING (order_id)
        INNER JOIN public.tbl_taxa_tree_genera USING (family_id)
        INNER JOIN public.tbl_taxa_tree_master USING (genus_id)
        WHERE 1 = 1
    ;

    /* Drop table if exists */
    shortcut_table_id = (select max(table_id) from facet.table where table_or_udf_name = 'facet.family_taxon_shortcut');
    if shortcut_table_id is not null then
        delete from facet.table_relation
            where table_relation_id in (
                select table_relation_id
                from facet.table_relation
                where shortcut_table_id in (source_table_id, target_table_id)
            );
        delete from facet.table where table_id = shortcut_table_id;
    end if;

    abundance_table_id = (select max(table_id) from facet.table where table_or_udf_name = 'tbl_abundances');
    shortcut_table_id = (select max(table_id) + 1 from facet.table);

    /* Add the shortcut to the facet tables */
    insert into facet.table(table_id, schema_name, table_or_udf_name, primary_key_name, is_udf)
        values (shortcut_table_id, '', 'facet.family_taxon_shortcut', 'xxxx', false);

    /* Add the relation between sites and locations via new route with high penelty*/
    insert into facet.table_relation (source_table_id, target_table_id, weight, source_column_name, target_column_name)
        values (abundance_table_id /* tbl_abundance */, shortcut_table_id /* shortcut_table_id */, 50, 'taxon_id', 'taxon_id');


    /* TARGET QUERY:

    SELECT category, count(value) AS count
    FROM (
        SELECT facet.family_taxon_shortcut.family_id AS category, tbl_analysis_entities.analysis_entity_id AS value
        FROM facet.family_taxon_shortcut
        INNER JOIN tbl_abundances USING (taxon_id)
        INNER JOIN tbl_analysis_entities USING (analysis_entity_id)
        WHERE 1 = 1
        GROUP BY facet.family_taxon_shortcut.family_id, tbl_analysis_entities.analysis_entity_id
    ) AS x
    GROUP BY category;

    */

    s_facets = $facets$
    [
        {
            "facet_id": 23,
            "facet_code": "family",
            "display_title": "Family",
            "description": "Taxonomic family",
            "facet_group_id":"6",
            "facet_type_id": 1,
            "category_id_expr": "facet.family_taxon_shortcut.family_id",
            "category_id_type": "integer",
            "category_id_operator": "=",
            "category_name_expr": "facet.family_taxon_shortcut.family_name",
            "sort_expr": "facet.family_taxon_shortcut.family_name",
            "is_applicable": true,
            "is_default": false,
            "aggregate_type": "count",
            "aggregate_title": "Number of samples",
            "aggregate_facet_code": "result_facet",
            "tables": [
                {
                    "sequence_id": 1,
                    "table_name": "facet.family_taxon_shortcut",
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

    insert into facet.facet_children(facet_code, child_facet_code, position)
        select f.facet_code, 'family', coalesce((select max(position) + 1 from facet.facet_children x where x.facet_code = f.facet_code), 0)
        from facet.facet f
        left join facet.facet_children x
            on x.facet_code = f.facet_code
            and x.child_facet_code = 'family'
        where f.facet_group_id = 999
            and x.facet_code is null;


    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
