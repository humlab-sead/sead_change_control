-- Deploy sead_db_change_control:CS_SITE_20180601_ALTER_TYPE to pg

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

        alter table tbl_dimensions alter column "dimension_abbrev" type character varying(16) collate "pg_catalog"."default";
        alter table tbl_sample_alt_refs alter column "alt_ref" type character varying(60) collate "pg_catalog"."default";
        alter table tbl_sites alter column "site_name" type character varying(60) collate "pg_catalog"."default";

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
