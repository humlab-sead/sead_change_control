-- Deploy sead_change_control:20200203_DML_METHOD_UPDATE to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
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
