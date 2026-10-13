-- Deploy general: 20260407_DML_ADD_PH_UNIT

/****************************************************************************************************************
  Author        Johan von Boer
  Date          2026-04-07
  Description   Add pH unit and map pH methods to it
  Issue         https://github.com/humlab-sead/sead_change_control/issues/428
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

set client_encoding = 'UTF8';
set client_min_messages = error;

begin;

do $$
declare
    v_ph_unit_id int;
begin
    insert into tbl_units (unit_name, unit_abbrev, description, date_updated)
    values (
        'pH',
        'pH',
        'Potential of hydrogen (pH), dimensionless logarithmic acidity/alkalinity scale',
        now()
    )
    on conflict (unit_name) do update
        set unit_abbrev = excluded.unit_abbrev,
            description = excluded.description,
            date_updated = now();

    select unit_id
    into v_ph_unit_id
    from tbl_units
    where unit_name = 'pH';

    update tbl_methods
    set unit_id = v_ph_unit_id,
        date_updated = now()
    where method_id in (109, 110)
      and unit_id is distinct from v_ph_unit_id;
end $$;

commit;
