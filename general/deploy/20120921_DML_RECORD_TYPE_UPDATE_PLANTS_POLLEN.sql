-- Deploy sead_change_control: to pg

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
    begin

        update tbl_record_types
            set record_type_description = 'Plants taxa and their pollen. Also includes non-pollen palynomorphs commonly counted and included in pollen analyses.'
        where record_type_id = 2;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
end $$;
commit;
