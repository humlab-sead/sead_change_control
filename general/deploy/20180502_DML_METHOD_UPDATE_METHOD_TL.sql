-- Deploy general: 20180502_DML_METHOD_UPDATE_METHOD_TL

/****************************************************************************************************************
  Author
  Date          2019-05-02
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
    if not exists (select 1 from public.tbl_methods where method_id = 150) then
        raise exception 'Method 150 does not exist';
    end if;

    if not exists (select 1 from public.tbl_method_groups where method_group_id = 16) then
        raise exception 'Method group 16 does not exist';
    end if;

    update tbl_methods
        set "description" = 'Dating using the release of stored energy properties of (mainly sonte) material previously exposed to the sun.'
    where method_id = 150;

    update tbl_method_groups
        set "description" = 'Sample preparation method. Method used to extract identifiable elements/specimens/analysed sample from the physical sample (e.g. paraffin floatation, centrifugation).
In some parts of the database multiple preparation methods may be given for a sample, as separate entries (e.g. 1. HF treatment; 2. centrifugation; 3. Slide preparation)'
    where method_group_id = 16;

end $$;
commit;
