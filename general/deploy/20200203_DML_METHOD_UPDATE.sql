-- Deploy general: 20200203_DML_METHOD_UPDATE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2020-02-03
  Description   //github.com/humlab-sead/sead_change_control/issues/38: Remove newline in description
  Issue         https://github.com/humlab-sead/sead_change_control/issues/38
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

        update tbl_methods
        	set description = regexp_replace(description, 'use\.\w*(\n+)\w*See', 'use. See')
        where regexp_replace(description, 'use\.\w*(\n+)\w*See', 'use. See') ~* '.*use\.\w*(\n+)\w*See.*';

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
