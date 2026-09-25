-- Deploy ./adna: 20260201_DML_ADNA_ACCESSION_LINK

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2026-02-01
  Description   Add aDNA accession type and link
  Issue         https://github.com/humlab-sead/sead_change_control/issues/395
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/
begin;
do $$
declare
    v_description_type_id integer;
    v_type_name constant text := 'Link to archived data';
    v_master_name constant text := 'SciLifelab Ancient DNA';
    v_accession_link constant text := 'https://www.ebi.ac.uk/ena/browser/view/PRJEB90617';
begin
    if not exists (select 1 from tbl_sample_group_description_types where "type_name" = v_type_name) then
        insert into tbl_sample_group_description_types("type_name", "type_description")
            values ('Link to archived data', 'Link to external database where the data is archived (e.g. aADNA accession link)');
    end if;

    if (select count(*) from tbl_sample_group_description_types where "type_name" = v_type_name) <> 1 then
        raise exception 'Unexpected description type count for %', v_type_name;
    end if;

    v_description_type_id := (
        select sample_group_description_type_id
        from tbl_sample_group_description_types
        where "type_name" = v_type_name
    );

    -- delete from tbl_sample_group_descriptions
    -- where sample_group_description_type_id = v_description_type_id
    --   and sample_group_id in (
    --     select distinct sg.sample_group_id
    --     from tbl_dataset_masters dm
    --     join tbl_datasets ds using (master_set_id)
    --     join tbl_analysis_entities ae using (dataset_id)
    --     join tbl_physical_samples ps using (physical_sample_id)
    --     join tbl_sample_groups sg using (sample_group_id)
    --     where dm.master_name = v_master_name
    -- );

    raise notice 'Using description_type_id: %', v_description_type_id;

    with adna_sample_groups as (
        select distinct sg.sample_group_id
        from tbl_dataset_masters dm
        join tbl_datasets ds using (master_set_id)
        join tbl_analysis_entities ae using (dataset_id)
        join tbl_physical_samples ps using (physical_sample_id)
        join tbl_sample_groups sg using (sample_group_id)
        where dm.master_name = v_master_name
    )
    insert into tbl_sample_group_descriptions(sample_group_id, sample_group_description_type_id, group_description)
        select distinct sg.sample_group_id, v_description_type_id, v_accession_link
        from adna_sample_groups sg
        left join tbl_sample_group_descriptions sgd
          on sg.sample_group_id = sgd.sample_group_id
         and sgd.sample_group_description_type_id = v_description_type_id
        where sgd.sample_group_description_id is null;
    
end $$;
commit;
--rollback;
/*
select * -- delete
from tbl_sample_group_descriptions
where sample_group_description_type_id =  81

select sg.sample_group_id, ps.physical_sample_id, sg.method_id, ds.dataset_id, sgd.sample_group_description_id
from tbl_dataset_masters dm
join tbl_datasets ds using (master_set_id)
join tbl_analysis_entities ae using (dataset_id)
join tbl_physical_samples ps using (physical_sample_id)
join tbl_sample_groups sg using (sample_group_id)
join tbl_sample_group_descriptions sgd using (sample_group_id)
join tbl_sample_group_description_types sgdt using (sample_group_description_type_id)
where dm.master_name = 'SciLifelab Ancient DNA'
  and sgd.sample_group_description_type_id = 81
;

*/