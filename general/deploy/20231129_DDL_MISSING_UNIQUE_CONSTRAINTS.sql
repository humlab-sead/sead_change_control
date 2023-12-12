-- Deploy sead_change_control:20231129_DDL_MISSIN_UNIQUE_COMSTRAINTS to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2023-11-29
  Description   
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/


-- drop function sead_utility.constraint_exists(s_schema_name text, s_table_name text, variadic v_columns text[]);
create or replace function sead_utility.constraint_exists(s_schema_name text, s_table_name text, variadic v_columns text[])
returns text
language plpgsql
    as $function$
        declare v_constraint_name text;
    begin

    v_constraint_name = null;

    select tc.constraint_name into v_constraint_name
    from information_schema.table_constraints as tc 
    join information_schema.key_column_usage as kcu
      on tc.constraint_name = kcu.constraint_name
    join information_schema.constraint_column_usage as ccu
      on ccu.constraint_name = tc.constraint_name
    where tc.constraint_type = 'UNIQUE'
	  and tc.constraint_schema = s_schema_name
      and tc.table_name=s_table_name
      and kcu.column_name = any(v_columns)
    group by tc.constraint_name, tc.table_name, kcu.column_name
    having count(*) = array_length(v_columns, 1);

	return v_constraint_name;

end
$function$

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
                having count(*) > 1;
            ) loop
                raise notice 'deleted duplicate sample_alt_ref_id: %', v_duplicate_id;
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
                raise notice 'duplicate site_reference_id: %', v_duplicate_id;
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
