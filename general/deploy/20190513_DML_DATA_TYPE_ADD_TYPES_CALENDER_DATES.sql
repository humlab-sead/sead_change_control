-- Deploy general: 20190513_DML_DATA_TYPE_ADD_TYPES_CALENDER_DATES

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

        with new_data_types (data_type_id, data_type_group_id, data_type_name, definition) as (values
            (16, 8, 'Calendar dates', 'sample ages calibrated to calendar dates')
        ) insert into tbl_data_types (data_type_id, data_type_group_id, data_type_name, definition, date_updated)
          select a.data_type_id, a.data_type_group_id, a.data_type_name, a.definition, '2019-12-20 13:45:51.664875+00'
          from new_data_types a
          left join tbl_data_types b
            on a.data_type_id = b.data_type_id
          where b.data_type_id is null;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
