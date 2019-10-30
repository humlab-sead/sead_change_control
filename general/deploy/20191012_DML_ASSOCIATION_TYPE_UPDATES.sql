-- Deploy sead_change_control:20191012_DML_ASSOCIATION_TYPE_UPDATES to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
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
        raise notice 'DEPRECATED: Moved to 20190503_DML_TAXA_ADD_SPECIES_ASSOC_TYPES';


    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;


end $$;
commit;
