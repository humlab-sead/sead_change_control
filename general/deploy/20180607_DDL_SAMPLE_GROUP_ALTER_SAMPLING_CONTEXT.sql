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
        drop view postgrest_default_api.sample_group_sampling_context;
        alter table public.tbl_sample_group_sampling_contexts alter column sampling_context type character varying(60);
        select clearing_house.fn_create_local_union_public_entity_views('clearing_house', 'clearing_house', false, true);
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;