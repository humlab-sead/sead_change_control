-- Deploy sead_db_change_control:CSA_20180607_ALTER_SAMPLE_GROUP_SAMPLING_CONTEXT to pg

/****************************************************************************************************************
  Author
  Date
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

        alter table tbl_sample_group_sampling_contexts alter column sampling_context type character varying(80);

        -- alter table tbl_physical_samples alter column date_sampled type timestamp with time zone using date_sampled::timestamp with time zone;
        raise notice 'FLAGGED: alter type of tbl_physical_samples.date_sampled to timestamp disabled';

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;