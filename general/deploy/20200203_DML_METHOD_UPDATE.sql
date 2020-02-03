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

        if sead_utility.column_exists('public'::text, 'table_name'::text, 'column_name'::text) = TRUE then
            raise exception SQLSTATE 'GUARD';
        end if;

        update tbl_methods
        	set description = regexp_replace(description, 'use\.\w*(\n+)\w*See', 'use. See')
        where regexp_replace(description, 'use\.\w*(\n+)\w*See', 'use. See') ~* '.*use\.\w*(\n+)\w*See.*';

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
