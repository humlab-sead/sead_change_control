-- Deploy bugs: 20190503_DML_DATINGLAB_ADD_UNKNOWN_LAB

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-05-03
  Description   Add unknown dating lab to accomodate Bugs import
  Issue         https://github.com/humlab-sead/sead_change_control/issues/191
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


        with new_dating_labs (international_lab_id, lab_name, country_id) as (
            values
                ('Unknown', 'Unknown or unspecified', NULL),
                ('LUS', 'Lund University', 205),
                ('SacA', 'Gif sur Yvette (Saclay)', 74),
                ('SUERC', 'Scottish Universities Environmental Research Centre', 244),
                ('SWAN', 'University of Wales, Swansea', 245),
                ('UBA', 'Belfast', 243),
                ('VERA', 'Institut für Radiumforschung und Kernphysik', 14)
        )
        insert into tbl_dating_labs (international_lab_id, lab_name, country_id, date_updated)
            select international_lab_id, n.lab_name, n.country_id, '2019-12-20 13:45:51.591431+00'
            from new_dating_labs n
            left join tbl_dating_labs x using (international_lab_id)
            where x.lab_name is null;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
