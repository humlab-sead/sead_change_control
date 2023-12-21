-- Deploy general: 20190503_DDL_TAXA_ATTRIBUTE_TYPE_LENGTH

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-05-03
  Description   Increase length of field attribute_type to accomodate large values from Bugs
  Issue         https://github.com/humlab-sead/sead_change_control/issues/101
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
         if (select count(*)
            from INFORMATION_SCHEMA.COLUMNS
            where table_schema='public'
              and table_name = 'tbl_taxa_measured_attributes'
              and column_name = 'attribute_type'
              and character_maximum_length = 255) = 1
        then
            raise exception sqlstate 'GUARD';
        end if;

        alter table tbl_taxa_measured_attributes
           alter column attribute_type type character varying(255);

        alter table tbl_taxa_measured_attributes
           alter column attribute_measure type character varying(255);

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
