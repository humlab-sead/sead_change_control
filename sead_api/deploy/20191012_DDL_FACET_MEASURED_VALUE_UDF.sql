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
	/* Moved to 20190101_DxL_FACET_SCHEMA-sql */
		Raise Notice 'Merged with 20190101_DxL_FACET_SCHEMA';
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



