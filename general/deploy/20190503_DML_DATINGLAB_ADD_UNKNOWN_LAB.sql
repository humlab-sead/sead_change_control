-- Deploy sead_change_control:CS_DATINGLAB_20190503_ADD_UNKNOWN_LAB to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-05-03
  Description   New dating labs including "Unknown" to accomodate Bugs import
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
