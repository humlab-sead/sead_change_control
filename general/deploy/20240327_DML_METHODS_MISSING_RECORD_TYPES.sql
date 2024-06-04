-- Deploy general: 20240327_DML_METHODS_MISSING_RECORD_TYPES

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-03-27
  Description   See https://github.com/humlab-sead/sead_query_api/issues/113
  Issue         https://github.com/humlab-sead/sead_change_control/issues/262
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    update tbl_methods
        set record_type_id = 13
    where TRUE
    and record_type_id is null
    and method_abbrev_or_alt_name in ('IRMS', 'AE');

    update tbl_methods
        set record_type_id = 19
    where TRUE
    and record_type_id is null
    and method_abbrev_or_alt_name in ('Cal' , 'CalAMS', 'GeolPer');


end $$;
commit;
