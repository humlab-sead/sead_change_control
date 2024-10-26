-- Deploy general: 20180601_DDL_SITE_ALTER_TYPE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2018-06-01
  Description   Increase length of varchar columns.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/173
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes         2024-10-23: Changes added to SEAD_DATA_BASE_MODEL change request (SEAD starting point)
*****************************************************************************************************************/

begin;
do $$
begin

    begin
        alter table tbl_dimensions alter column "dimension_abbrev" type character varying(40) collate "pg_catalog"."default";
        alter table tbl_sample_alt_refs alter column "alt_ref" type character varying(80) collate "pg_catalog"."default";
        alter table tbl_sites alter column "site_name" type character varying(60) collate "pg_catalog"."default";

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
