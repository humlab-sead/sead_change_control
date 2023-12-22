-- Deploy sead_api: 20200507_DDL_FACET_GRAPH_UPDATE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2020-05-07
  Description   Add missing edge
  Issue         https://github.com/humlab-sead/sead_change_control/issues/71
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

        /* Add missing relation */
        insert into facet.table_relation (source_table_id, target_table_id, weight, source_column_name, target_column_name)
            with  new_edges(source_table, target_table, column_name) as ( values
                ('tbl_dataset_methods', 'tbl_methods', 'method_id')
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

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
