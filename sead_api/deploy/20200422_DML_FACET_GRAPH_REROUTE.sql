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

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
  
