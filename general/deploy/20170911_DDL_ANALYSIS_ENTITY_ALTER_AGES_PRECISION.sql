-- Deploy general: 20170911_DDL_ANALYSIS_ENTITY_ALTER_AGES_PRECISION

/****************************************************************************************************************
  Author        Phil Buckland
  Date          2017-09.11
  Description   Changed numeric ranges of values to 20,5 to match tbl_relative_ages
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
              and table_name = 'tbl_analysis_entity_ages'
              and column_name = 'age'
              and numeric_precision = 20
              and numeric_scale = 5) > 0
        then
            raise exception sqlstate 'GUARD';
        end if;


        alter table tbl_analysis_entity_ages
            alter column "age" type numeric(20,5),
            alter column "age_older" type numeric(20,5),
            alter column "age_younger" type numeric(20,5);

        alter table tbl_analysis_entity_ages
            alter column age
                drop not null;

        comment on table "public"."tbl_analysis_entity_ages" is '20170911PIB: Changed numeric ranges of values to 20,5 to match tbl_relative_ages
            20120504PIB: Should this be connected to physical sample instead of analysis entities? Allowing multiple ages (from multiple dates) for a sample. At the moment it requires a lot of backtracing to find a sample''s age... but then again, it allows... what, exactly?';

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;


