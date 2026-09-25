-- Verify facet:20260331_DML_DATASETS_FACET on pg

BEGIN;

-- Facet exists with key metadata.
select 1 / count(*)
from facet.facet
where facet_code = 'datasets'
  and display_title = 'Datasets'
  and facet_group_id = 2
  and facet_type_id = 1
  and category_id_expr = 'tbl_datasets.dataset_id'
  and category_name_expr = 'tbl_datasets.dataset_name'
  and sort_expr = 'tbl_datasets.dataset_name'
  and is_applicable = true
  and is_default = false
  and aggregate_type = 'count'
  and aggregate_title = 'Number of analysis entities';

-- Aggregate target points to result_facet.
select 1 / count(*)
from facet.facet f
join facet.facet agg
  on agg.facet_id = f.aggregate_facet_id
where f.facet_code = 'datasets'
  and agg.facet_code = 'result_facet';

-- Facet uses tbl_datasets table source.
select 1 / count(*)
from facet.facet_table ft
join facet.facet f
  on f.facet_id = ft.facet_id
join facet.table t
  on t.table_id = ft.table_id
where f.facet_code = 'datasets'
  and ft.sequence_id = 1
  and t.table_or_udf_name = 'tbl_datasets';

-- Facet has no facet clauses.
select 1 / count(*)
from (
    select 1
    where not exists (
        select 1
        from facet.facet_clause c
        join facet.facet f
          on f.facet_id = c.facet_id
        where f.facet_code = 'datasets'
    )
) as x;

-- Datasets is attached to all domain facets.
do $$
declare i_domain_count int;
declare i_linked_count int;
begin
    select count(*)
    into i_domain_count
    from facet.facet
    where facet_group_id = 999;

    select count(distinct d.facet_code)
    into i_linked_count
    from facet.facet d
    join facet.facet_children fc
      on fc.facet_code = d.facet_code
     and fc.child_facet_code = 'datasets'
    where d.facet_group_id = 999;

    if i_domain_count <> i_linked_count then
        raise exception
            'datasets facet missing from one or more domain facets (domains: %, linked: %)',
            i_domain_count,
            i_linked_count;
    end if;
end $$;

ROLLBACK;
