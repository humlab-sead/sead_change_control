-- Deploy bugs: 20200316_DDL_BUGS_ECOCODE_GEOJSON

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2020-03-16
  Description   GeoJSON export for Bugs Ecocodes ecocode_system_id 2
  Issue         https://github.com/humlab-sead/sead_change_control/issues/64
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

        perform sead_utility.fn_generate_ecocode_crosstab_function(2, 2, FALSE);

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
