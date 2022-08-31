SELECT DISTINCT sgd.group_description
FROM tbl_sites s
join tbl_sample_groups sg on s.site_id = sg.site_id
join tbl_sample_group_descriptions sgd on sg.sample_group_id = sgd.sample_group_id
join tbl_sample_group_description_types sgdt on sgdt.sample_group_description_type_id = sgd.sample_group_description_type_id 
join tbl_physical_samples ps on sg.sample_group_id = ps.sample_group_id
Where sgd.sample_group_description_type_id = 58