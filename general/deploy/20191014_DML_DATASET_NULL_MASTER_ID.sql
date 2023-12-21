-- Deploy general: 20191014_DML_DATASET_NULL_MASTER_ID

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-10-14
  Description   Resolves #100 Updates NULL MAL master_set_id in tbl_datasets
  Issue         https://github.com/humlab-sead/sead_change_control/issues/16
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


	update public.tbl_datasets set master_set_id = 2
	where master_set_id is NULL;


    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
