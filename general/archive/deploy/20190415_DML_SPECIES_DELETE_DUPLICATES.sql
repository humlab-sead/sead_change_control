-- Deploy general: 20190415_DML_SPECIES_DELETE_DUPLICATES

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-15
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
declare
    x_id int;
    y_id int;
    x_name varchar;
    y_name varchar;
begin
    raise exception 'PENDING CONFIRM: this CR is not confirmed';

    begin

        for x_id, y_id in
            with dupes(association_type_id, dupe_association_type_id) as (values
                (17, 85),
                (48, 87),
                (60, 88)
            ) select association_type_id, dupe_association_type_id
              from dupes
        loop
            select association_type_name into x_name from tbl_species_association_types where association_type_id = x_id;
            select association_type_name into y_name from tbl_species_association_types where association_type_id = y_id;

            raise notice 'UPDATE ONHOLD: %/"%" TO %/"%"', x_id, x_name, y_id, y_name;

            -- update tbl_species_associations set association_type_id = x_id where association_type_id = y_id;
            -- delete from tbl_species_association_types  where association_type_id = y_id;

        end loop;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;

commit;

