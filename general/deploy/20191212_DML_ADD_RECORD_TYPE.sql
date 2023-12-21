-- Deploy general: 20191212_DML_ADD_RECORD_TYPE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-12-12
  Description   Add missing record types
  Issue         https://github.com/humlab-sead/sead_change_control/issues/193
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

        with new_record_types (record_type_id, record_type_name, record_type_description) as ( values
            (0, 'Undefined', 'Unspecified record type'),
            (20, 'Dendrochronology', 'Detemination of age through tree ring measurements'),
            (21, 'Ceramic thin sections', 'Ceramic thin sections')
        ) insert into tbl_record_types (record_type_id, record_type_name, record_type_description, date_updated)
        select a.record_type_id, a.record_type_name, a.record_type_description, '2019-12-20 13:45:51.80695+00'
        from new_record_types a
        left join tbl_record_types b
            on a.record_type_id = b.record_type_id
        where b.record_type_id is null;

        update tbl_methods
            set record_type_id = 20
        where method_id = 10
          and method_abbrev_or_alt_name = 'Dendro'
          and record_type_id <> 20;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
