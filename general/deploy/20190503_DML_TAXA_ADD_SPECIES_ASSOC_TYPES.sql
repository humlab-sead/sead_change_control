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
                ('predated on by'),
		        ('in same streams as'),
		        ('in same ponds as'),
		        ('is found with'),
		        ('is predated in nests by'),
		        ('in similar woodland pools as'),
		        ('in same log as'),
		        ('pupae parasitized by?'),
		        ('inquiline with?'),
		        ('on burnt ground with'),
		        ('is endoparasite of pupae of')
        )
        insert into tbl_species_association_types (association_type_name, date_updated)
            select association_type_name, '2019-12-20 13:45:51.442946+00'
            from new_species_association_types n
            left join tbl_species_association_types x using (association_type_name)
            where x.association_type_id is null
            order by association_type_name;

        update tbl_species_association_types set association_type_name = 'has undefined association with' where association_type_name = 'undefined association with';
        update tbl_species_association_types set association_type_name = 'inquiline with' where association_type_name = 'inquiline';
        update tbl_species_association_types set association_type_name = 'found around nests of' where association_type_name = 'around nests of';
        update tbl_species_association_types set association_type_name = 'swarms with' where association_type_name = 'Swarming';
        update tbl_species_association_types set association_type_name = 'is cuckoo parasite in burrows of' where association_type_name = 'cuckoo parasite in burrows of';
        update tbl_species_association_types set association_type_name = 'is semi-parasitic with' where association_type_name = 'semi-parasitic with';
        update tbl_species_association_types set association_type_name = 'is parasite of' where association_type_name = 'parasite of';

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
