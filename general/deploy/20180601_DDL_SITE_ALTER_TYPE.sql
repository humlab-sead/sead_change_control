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
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    begin
        if (select count(*)
            from INFORMATION_SCHEMA.COLUMNS
            where table_schema='public'
              and table_name = 'tbl_dimensions'
              and column_name = 'dimension_abbrev'
              and character_maximum_length = 16) = 1
        then
            raise exception sqlstate 'GUARD';
        end if;

        alter table tbl_dimensions alter column "dimension_abbrev" type character varying(16) collate "pg_catalog"."default";
        alter table tbl_sample_alt_refs alter column "alt_ref" type character varying(60) collate "pg_catalog"."default";
        alter table tbl_sites alter column "site_name" type character varying(60) collate "pg_catalog"."default";

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
