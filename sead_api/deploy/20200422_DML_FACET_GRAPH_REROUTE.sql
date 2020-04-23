-- Deploy sead_api:20200422_DML_FACET_GRAPH_REROUTE to pg

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
begin

    begin

        /* Changed route */

        update facet.table_relation
            set target_table_id = 4,
                source_column_name = 'analysis_entity_id',
                target_column_name = 'analysis_entity_id'
        where table_relation_id in (
            select r.table_relation_id
            from facet.table_relation r
            join facet.table t1 on t1.table_id = source_table_id
            join facet.table t2 on t2.table_id = target_table_id
            where t1.table_or_udf_name = 'tbl_relative_dates'
            and t2.table_or_udf_name = 'tbl_physical_samples'
            and r.source_column_name = 'physical_sample_id'
            and r.target_column_name = 'physical_sample_id'
		);

        /* Routes that are missing */

        insert into facet.table_relation (source_table_id, target_table_id, weight, source_column_name, target_column_name)
            with  new_edges(source_table, target_table, column_name) as ( values
                ('tbl_analysis_entities'     , 'tbl_isotopes'           , 'analysis_entity_id'),
                ('tbl_ceramics'              , 'tbl_ceramics_lookup'    , 'ceramics_lookup_id'),
                ('tbl_ceramics_lookup'       , 'tbl_methods'            , 'method_id'),
                ('tbl_isotope_measurements'  , 'tbl_isotopes'           , 'isotope_measurement_id'),
                ('tbl_isotope_measurements'  , 'tbl_methods'            , 'method_id'),
                ('tbl_dendro'                , 'tbl_dendro_lookup'      , 'dendro_lookup_id'),
                ('tbl_dendro_lookup'         , 'tbl_methods'            , 'method_id')
            ) select t1.table_id as source_table_id,
                    t2.table_id as target_table_id,
                    20 as weight,
                    column_name as source_column_name,
                    column_name as target_column_name
            from new_edges
            join facet.table t1 on t1.table_or_udf_name = new_edges.source_table
            join facet.table t2 on t2.table_or_udf_name = new_edges.target_table
            left join facet.table_relation cx
                on cx.source_table_id = t1.table_id
            and cx.target_table_id = t2.table_id
            where cx.table_relation_id is null;

            /* Query used to compare SEAD public schema FK's to facet graph edges:

                with public_foreign_keys as (
                    select	table_name 			as source_name,
                            foreign_table_name 	as target_name,
                            foreign_column_name as column_name
                    from sead_utility.foreign_key_columns
                    where table_schema = 'public'
                ), public_relations as (
                    select source_name, target_name, column_name
                    from public_foreign_keys
                    union all
                    select target_name, source_name, column_name
                    from public_foreign_keys
                ), facet_undirected_relations as (
                    select	t1.table_or_udf_name 	as source_name,
                            t2.table_or_udf_name 	as target_name,
                            r.target_column_name    as column_name
                    from facet.table_relation r
                    join facet.table t1 on t1.table_id = r.source_table_id
                    join facet.table t2 on t2.table_id = r.target_table_id
                    where r.source_column_name = r.target_column_name
                ), facet_relations as (
                    select source_name, target_name, column_name
                    from facet_undirected_relations
                    union all
                    select target_name, source_name, column_name
                    from facet_undirected_relations
                ), consolidated_relations as (
                    select coalesce(p.source_name, f.source_name) as source_name,
                        coalesce(p.target_name, f.target_name) as target_name,
                        coalesce(p.column_name, f.column_name) as column_name,
                        case when p.source_name is null then '' else 'FK' end as is_public,
                        case when f.source_name is null then '' else 'EDGE' end as is_facet
                    from public_relations p
                    full outer join facet_relations f
                    on f.source_name = p.source_name
                    and f.target_name = p.target_name
                ) select distinct
                        '(''' || case when source_name <= target_name then source_name else target_name end || ''', ''' ||
                        '''' || case when source_name  > target_name then source_name else target_name end || ''', ''' ||
                        '''' || column_name || '''),  -- ' || is_public || ' ' || is_facet
                from consolidated_relations
                where is_public || is_facet <> 'FKEDGE'
                    and source_name not like 'facet.%'
                    and target_name not like 'facet.%'
                order by 1;

            */

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;

