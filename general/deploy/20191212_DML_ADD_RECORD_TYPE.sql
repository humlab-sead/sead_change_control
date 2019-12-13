-- Deploy sead_change_control:20191212_DML_ADD_RECORD_TYPE to pg

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

        /*
        ** Dendrochronlogy
        **
        ** This has also been added to 20180521_DML_DENDRO_ADD_LOOKUP_DATA (its rightful place)
        **/

        with new_record_types (record_type_id, record_type_name, record_type_description) as ( values
            (0, 'Undefined', 'Unspecified record type', '2019-12-10 10:29:17.789481+00'),
            (20, 'Dendrochronology', 'Detemination of age through tree ring measurements', '2019-12-10 10:29:17.789481+00'),
            (21, 'Ceramic thin sections', 'Ceramic thin sections', '2019-12-13 10:29:17.789481+00')
        ) insert into tbl_record_types (record_type_id, record_type_name, record_type_description)
        select a.record_type_id, a.record_type_name, a.record_type_description
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
