-- Verify general:20260407_DML_ADD_PH_UNIT on pg

BEGIN;

do $$
declare
    v_ph_unit_id int;
    v_ph_unit_count int;
begin
    select max(unit_id), count(*)
    into v_ph_unit_id, v_ph_unit_count
    from tbl_units
    where unit_name = 'pH'
      and unit_abbrev = 'pH';

    if v_ph_unit_count <> 1 then
        raise exception 'Expected exactly one pH unit row, found %', v_ph_unit_count;
    end if;

    if (select count(*) from tbl_methods where method_id in (109, 110)) <> 2 then
        raise exception 'Expected both method_id 109 and 110 to exist in tbl_methods';
    end if;

    if exists (
        select 1
        from tbl_methods
        where method_id in (109, 110)
          and unit_id is distinct from v_ph_unit_id
    ) then
        raise exception 'method_id 109/110 are not both mapped to pH unit_id %', v_ph_unit_id;
    end if;
end $$;

ROLLBACK;
