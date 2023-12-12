-- Deploy general: 20120921_DML_RECORD_TYPE_UPDATE_PLANTS_POLLEN

/****************************************************************************************************************
  Author
  Date          2012-09-21
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Revertable    No
  Notes
*****************************************************************************************************************/

begin;
do $$
begin
    if not exists (select 1 from public.tbl_record_types where record_type_id = 2) then
        raise exception 'Record type 2 does not exist';
    end if;

    update tbl_record_types
        set record_type_description = 'Plants taxa and their pollen. Also includes non-pollen palynomorphs commonly counted and included in pollen analyses.'
    where record_type_id = 2;
end $$;
commit;
