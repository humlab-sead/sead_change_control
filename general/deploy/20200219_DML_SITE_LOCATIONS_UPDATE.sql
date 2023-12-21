-- Deploy general: 20200219_DML_SITE_LOCATIONS_UPDATE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2020-02-19
  Description   MAL QoS: Removed 2 site locations
  Issue         https://github.com/humlab-sead/sead_change_control/issues/54
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

        delete from public.tbl_site_locations where site_location_id in (1286, 1082);

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
