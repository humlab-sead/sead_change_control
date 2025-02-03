-- Deploy general: 20231129_DDL_MISSING_UNIQUE_CONSTRAINTS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2023-11-29
  Description   Add missing unique constraints to the SEAD database.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/142
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/


begin;
do $$
begin
    declare v_duplicate_id int;
    begin
    
        if sead_utility.constraint_exists('public', 'tbl_sample_alt_refs', 'physical_sample_id', 'alt_ref', 'alt_ref_type_id') is null then

            for v_duplicate_id in (
                select max(sample_alt_ref_id)
                from tbl_sample_alt_refs
                group by physical_sample_id, alt_ref, alt_ref_type_id, date_updated
                having count(*) > 1
            ) loop
                -- raise notice 'deleted duplicate sample_alt_ref_id: %', v_duplicate_id;
                delete from tbl_sample_alt_refs where sample_alt_ref_id = v_duplicate_id;
            end loop;

            alter table tbl_sample_alt_refs
                add constraint uq_tbl_sample_alt_refs unique (physical_sample_id, alt_ref, alt_ref_type_id);

        end if;

        if sead_utility.constraint_exists('public', 'tbl_site_references', 'site_id', 'biblio_id') is null then

            for v_duplicate_id in (
                select max(site_reference_id) as site_reference_id
                from tbl_site_references
                group by site_id, biblio_id
                having count(*) > 1
            ) loop
                -- raise notice 'duplicate site_reference_id: %', v_duplicate_id;
                delete from tbl_site_references where site_reference_id = v_duplicate_id;
            end loop;

            alter table tbl_site_references
                add constraint uq_site_references unique (site_id, biblio_id);

        end if;


    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
