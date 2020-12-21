-- Deploy sead_api:20200507_DDL_RESULT_FIELD_UPDATE to pg

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

        /* Result fields must have a table_name */
        update facet.result_field
            set table_name = 'tbl_sites' where table_name is null
        from facet.result_field

        alter table facet.result_field
            alter column table_name
                set not null;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
