-- Deploy sead_change_control:CS_METHOD_20140417_ADD_METHOD_GEOLPER to pg

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
    begin

        update tbl_methods
            set "description" = 'Dating using the release of stored energy properties of (mainly sonte) material previously exposed to the sun.'
        where method_id = 150;

        update tbl_method_groups
            set "description" = 'Sample preparation method. Method used to extract identifiable elements/specimens/analysed sample from the physical sample (e.g. paraffin floatation, centrifugation).
In some parts of the database multiple preparation methods may be given for a sample, as separate entries (e.g. 1. HF treatment; 2. centrifugation; 3. Slide preparation)'
        where method_group_id = 16;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
end $$;
commit;
