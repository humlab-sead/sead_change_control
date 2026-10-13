
        with pilot as (
            select distinct dataset_id
            from tbl_dendro
            join tbl_analysis_entities using (analysis_entity_id)
            join tbl_datasets using (dataset_id)
            where master_set_id = 10
        ), living_trees as (
            select distinct dataset_id
            from tbl_datasets
            where master_set_id = 10
              and dataset_id not in ( select dataset_id from pilot)
        ), site_datasets as (
            select distinct site_id, dataset_id
            from tbl_sites s
            join tbl_sample_groups sg using (site_id)
            join tbl_physical_samples ps using (sample_group_id)
            join tbl_analysis_entities ae using (physical_sample_id)
            join tbl_datasets d using (dataset_id)
            where d.master_set_id = 10
        ), sample_datasets as (
            select distinct physical_sample_id, dataset_id
            from tbl_physical_samples ps
            join tbl_analysis_entities ae using (physical_sample_id)
            join tbl_datasets d using (dataset_id)
            where d.master_set_id = 10
        )

            select physical_sample_id, sum(case when lt.dataset_id is not null then 1 else 0 end) as living_tree_count,
                   sum(case when p.dataset_id is not null then 1 else 0 end) as pilot_count
            from sample_datasets sd
            left join living_trees lt on lt.dataset_id = sd.dataset_id
            left join pilot p on p.dataset_id = sd.dataset_id
            group by physical_sample_id

            -- select site_id,
            --     bool_or(lt.dataset_id is not null) as is_living_tree,
            --     bool_or(p.dataset_id is not null) as is_pilot
            -- from site_datasets sd
            -- left join living_trees lt on lt.dataset_id = sd.dataset_id
            -- left join pilot p on p.dataset_id = sd.dataset_id
            -- group by site_id


select *
from tbl_submissions


SELECT s.site_id, count(t.tracked_identity_uuid) AS mapping_count
FROM public.tbl_sites AS s
LEFT JOIN sead_identity.tracked_identities AS t
  ON t.entity_type = 'site'
 AND t.sead_internal_id = s.site_id
GROUP BY s.site_id
HAVING count(t.tracked_identity_uuid) <> 1;



select record_type_id, record_type_name
from tbl_record_types
order by 1


select *
from public.tbl_taxa_tree_master
