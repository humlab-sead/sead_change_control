-- Deploy sead_api: 20200507_DDL_RESULT_FIELD_UPDATE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2020-05-07
  Description   Add not null constraint on table_name
  Issue         https://github.com/humlab-sead/sead_change_control/issues/71
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

        /* Result fields must have a table_name */
        update facet.result_field
            set table_name = 'tbl_sites'
        where table_name is null;

        alter table facet.result_field
            alter column table_name
                set not null;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
