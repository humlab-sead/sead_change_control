-- Deploy general: 20180607_DDL_SAMPLE_ALTER_TYPES

/****************************************************************************************************************
  Author
  Date          2018-06-07
  Description   Change type of tbl_sample_group_sampling_contexts.sampling_context
  Issue         https://github.com/humlab-sead/sead_change_control/issues/184
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
            where table_schema = 'public'
              and table_name = 'tbl_sample_group_sampling_contexts'
              and column_name = 'sampling_context'
              and character_maximum_length = 80) = 0
        then
            alter table tbl_sample_group_sampling_contexts alter column sampling_context type character varying(80);
        end if;


        -- alter table tbl_physical_samples alter column date_sampled type timestamp with time zone using date_sampled::timestamp with time zone;
        -- raise notice 'FLAGGED: alter type of tbl_physical_samples.date_sampled to timestamp disabled';

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
