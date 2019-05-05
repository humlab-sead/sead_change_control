#!/bin/bash

mkdir -p ~/.sqitch/templates/deploy
mkdir -p ~/.sqitch/templates/verify
mkdir -p ~/.sqitch/templates/revert

cat > ~/.sqitch/sqitch.conf <<'xyz'
[engine "pg"]
    client = /usr/bin/psql
[user]
    name = Roger Mähler
    email = roger.mahler@umu.se
xyz

cat > ~/.sqitch/templates/deploy/pg.tmpl <<'xyz'
-- Deploy [% project %]:[% change %] to [% engine %]
[% FOREACH item IN requires -%]
-- requires: [% item %]
[% END -%]
[% FOREACH item IN conflicts -%]
-- conflicts: [% item %]
[% END -%]

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
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

        -- insert your DDL code here

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;

xyz

cat > ~/.sqitch/templates/verify/pg.tmpl <<'xyz'
-- Deploy [% project %]:[% change %] to [% engine %]
[% FOREACH item IN requires -%]
-- requires: [% item %]
[% END -%]
[% FOREACH item IN conflicts -%]
-- conflicts: [% item %]
[% END -%]

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description   Verifies [% project %]:[% change %]
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin
    begin
        -- insert your DDL code here
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
end $$;
commit;
xyz

cat > ~/.sqitch/templates/revert/pg.tmpl <<'xyz'

xyz
