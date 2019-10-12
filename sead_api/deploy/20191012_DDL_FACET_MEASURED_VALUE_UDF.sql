-- Deploy sead_api:20191012_DDL_FACET_MEASURED_VALUE_UDF to pg

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

        if sead_utility.column_exists('public'::text, 'table_name'::text, 'column_name'::text) = TRUE then
            raise exception SQLSTATE 'GUARD';
        end if;

        -- insert your DDL code here

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;

/*
select ds.method_id as dataset_method_id, coalesce(aepm.method_id, 0) as prep_method_id, count(*)
from tbl_analysis_entities ae
join (select distinct analysis_entity_id from tbl_measured_values) as mv using (analysis_entity_id)
left join tbl_analysis_entity_prep_methods aepm using (analysis_entity_id)
join tbl_datasets ds using (dataset_id)
where ds.method_id is not null
group by ds.method_id, prep_method_id
order by ds.method_id
*/

/*
select ds.method_id as dataset_method_id, coalesce(aepm.method_id, 0) as prep_method_id, count(*)
from tbl_analysis_entities ae
join (select distinct analysis_entity_id from tbl_measured_values) as mv using (analysis_entity_id)
left join tbl_analysis_entity_prep_methods aepm using (analysis_entity_id)
join tbl_datasets ds using (dataset_id)
where ds.method_id is not null
group by ds.method_id, prep_method_id
order by ds.method_id
*/

create or replace function facet.method_measured_values(p_dataset_method_id int, p_prep_method_id int)
returns table (
    physical_sample_id int,
    analysis_entity_id int,
    measured_value numeric(20,10)
) as $$
begin

    return query
        select ae.physical_sample_id, mv.analysis_entity_id, mv.measured_value
        from tbl_measured_values mv
        join tbl_analysis_entities ae using (analysis_entity_id)
        join tbl_datasets ds using (dataset_id)
        left join tbl_analysis_entity_prep_methods pm using (analysis_entity_id)
        where ds.method_id = p_dataset_method_id
          and coalesce(pm.method_id, 0) = p_prep_method_id;

end $$ language plpgsql;

select *
from facet.method_measured_values(32, 0)
order by 1, 2;

alter table facet.facet_table rename column table_name to table_or_udf_name;
alter table facet.facet_table add column udf_call_arguments character varying(80) null;

update facet.facet
    set category_id_expr = 'method_values.measured_value',
        category_name_expr = 'method_values.measured_value',
        icon_id_expr = 'method_values.measured_value',
        sort_expr = 'method_values.measured_value'
where facet_id = 3
  and category_id_expr <> 'method_values.measured_value';

update facet.facet_table
    set table_or_udf_name = 'facet.method_measured_values',
        alias = 'method_values',
        udf_call_arguments = '(33, 0)'
where facet_id = 3
  and alias <> 'method_values';


with new_node (table_id, table_name) as (
    values (149, 'facet.method_measured_values')
)
    insert into facet.graph_table (table_id, table_name)
        select n.table_id, n.table_name
        from new_node n
        left join facet.graph_table r using (table_name)
        where r.table_name is null;

with new_edge (source_table_id, target_table_id, weight, source_column_name, target_column_name) as (
    values (102, 149, 20, 'physical_sample_id', 'physical_sample_id')
)
    insert into facet.graph_table_relation (relation_id, source_table_id, target_table_id, weight, source_column_name, target_column_name)
        select (select max(relation_id) + 1 from facet.graph_table_relation),
                n.source_table_id, n.target_table_id, n.weight, n.source_column_name, n.target_column_name
        from new_edge n
        left join facet.graph_table_relation r using (source_table_id, target_table_id)
        where r.source_table_id is null;

/*
$counter=0;

 while ($row = pg_fetch_assoc($rs)) {
    $build_view_selects[]=" max( values_".$row["dataset_method"]."_".$row["prep_method"]. ".measured_value)  as value_".$row["dataset_method"]."_".$row["prep_method"];
  //  $build_view_selects[]="min(values_".$row["dataset_method"]."_".$row["prep_method"]. ".measured_value) as min_value_".$row["dataset_method"]."_".$row["prep_method"];
   // $build_view_selects[]="avg(values_".$row["dataset_method"]."_".$row["prep_method"]. ".measured_value) as value_".$row["dataset_method"]."_".$row["prep_method"];
  // $build_view_selects[]="count(values_".$row["dataset_method"]."_".$row["prep_method"]. ") as count_".$row["dataset_method"]."_".$row["prep_method"];

    $build_view_joins[$counter]="  LEFT JOIN (SELECT tbl_measured_values.measured_value,
                         tbl_measured_values.analysis_entity_id
                  FROM   tbl_measured_values
                         JOIN tbl_analysis_entities
                           ON tbl_measured_values.analysis_entity_id =
                              tbl_analysis_entities.analysis_entity_id
                         JOIN tbl_datasets
                           ON tbl_datasets.dataset_id =
                              tbl_analysis_entities.dataset_id
                          left join tbl_analysis_entity_prep_methods
                            on  tbl_analysis_entity_prep_methods.analysis_entity_id=tbl_analysis_entities.analysis_entity_id

             WHERE  tbl_datasets.method_id = ".$row["dataset_method"].
            " and   COALESCE( tbl_analysis_entity_prep_methods.method_id,0) = ".$row["prep_method"]."   )
             AS values_".$row["dataset_method"]."_".$row["prep_method"] . "
                     ON tbl_analysis_entities.analysis_entity_id =values_".$row["dataset_method"]."_".$row["prep_method"].".analysis_entity_id  ";


            $having[]=" count_".$row["dataset_method"]."_".$row["prep_method"] .">1";
 $counter++;

 }

 //print_r($build_view_select);
 //print_r($build_view_joins);
 $q="select tbl_physical_samples.physical_sample_id,";
 $q.="\n ". implode(",",$build_view_selects);
 $q.=" FROM   tbl_analysis_entities
        join tbl_physical_samples
	on tbl_physical_samples.physical_sample_id=tbl_analysis_entities.physical_sample_id";

 $q.=implode("\n -- next \n ",$build_view_joins);
 $q.=" group by tbl_physical_samples.physical_sample_id
        order by
        tbl_physical_samples.physical_sample_id";
   // $q.=" having ".implode(" AND ",$having)  ;
  echo SqlFormatter::format($q,false);
   ?>
*/
