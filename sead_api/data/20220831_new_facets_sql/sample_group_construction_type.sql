select group_description, count(distinct analysis_entity_id)
from tbl_sites s
join tbl_sample_groups sg using (site_id)
join tbl_sample_group_descriptions sgd using (sample_group_id)
join tbl_sample_group_description_types sgdt using (sample_group_description_type_id)
join tbl_physical_samples ps using (sample_group_id)
join tbl_analysis_entities ae using (physical_sample_id)
where sgd.sample_group_description_type_id = 60
group by group_description;

select *
from facet.facet
where facet_id < 1000;
