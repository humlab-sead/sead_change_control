-- Deploy sead_change_control:CS_TAXA_20190503_ADD_SPECIES_ASSOC_TYPES to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description   New association type names needed for Bugs import
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
        with new_species_association_types(association_type_name) as (
            values
                ('dung in burrows parasitised by'),
                ('found in same log as'),
                ('found breeding in same log as'),
                ('in same habitat as?'),
                ('in same habitat, but not in burials, as'),
                ('in same pools as'),
                ('in same upland habitat as'),
                ('in same upland pools as'),
                ('in same wood as'),
                ('is kleptoparasitic in burrows of'),
                ('is kleptoparasitic in nests of'),
                ('is kleptoparasitic on'),
                ('is kleptoparasitised by'),
                ('is loosely associated with'),
                ('predated on by')
        )
        --insert into tbl_species_association_types (association_type_name)
            select association_type_name
            from new_species_association_types n
            left join tbl_species_association_types x using (association_type_name)
            where x.association_type_id is null
            order by association_type_name;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
