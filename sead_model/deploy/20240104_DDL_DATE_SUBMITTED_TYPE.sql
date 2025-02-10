-- Deploy sead_model: 20240104_DDL_DATE_SUBMITTED_TYPE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-01-04
  Description   Changed type of date_submitted to text
  Issue         https://github.com/humlab-sead/sead_change_control/issues/228
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin
	raise notice '20240104_DDL_DATE_SUBMITTED_TYPE has been backported to SEAD model and is now idempotent';

  -- if exists (
  --   select 1
  --   from information_schema.columns
  --   where table_schema = 'public'
  --     and table_name = 'tbl_dataset_submissions'
  --     and column_name = 'date_submitted'
  --     and data_type != 'text'
  -- ) then
  --     alter table tbl_dataset_submissions alter column "date_submitted" type text using "date_submitted"::text;
	-- 	  alter table tbl_dataset_submissions alter column "date_submitted" drop not null;
  -- end if;

end $$;
commit;
