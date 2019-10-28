-- Deploy sead_change_control:20191012_DML_ASSOCIATION_TYPE_UPDATES to pg

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

        update tbl_species_association_types set association_type_name = 'has undefined association with' where association_type_name = 'undefined association with';
        update tbl_species_association_types set association_type_name = 'inquiline with' where association_type_name = 'inquiline';
        update tbl_species_association_types set association_type_name = 'found around nests of' where association_type_name = 'around nests of';
        update tbl_species_association_types set association_type_name = 'swarms with' where association_type_name = 'Swarming';
        update tbl_species_association_types set association_type_name = 'is cuckoo parasite in burrows of' where association_type_name = 'cuckoo parasite in burrows of';
        update tbl_species_association_types set association_type_name = 'is semi-parasitic with' where association_type_name = 'semi-parasitic with';
        update tbl_species_association_types set association_type_name = 'is parasite of' where association_type_name = 'parasite of';

        insert into tbl_species_association_types (association_type_name, association_description) values ('in same streams as', NULL);
        insert into tbl_species_association_types (association_type_name, association_description) values ('in same ponds as', NULL);
        insert into tbl_species_association_types (association_type_name, association_description) values ('is found with', NULL);
        insert into tbl_species_association_types (association_type_name, association_description) values ('is predated in nests by', NULL);
        insert into tbl_species_association_types (association_type_name, association_description) values ('in similar woodland pools as', NULL);
        insert into tbl_species_association_types (association_type_name, association_description) values ('in same upland habitat as', NULL);
        insert into tbl_species_association_types (association_type_name, association_description) values ('in same log as', NULL);
        insert into tbl_species_association_types (association_type_name, association_description) values ('pupae parasitized by?', NULL);
        insert into tbl_species_association_types (association_type_name, association_description) values ('inquiline with?', NULL);
        insert into tbl_species_association_types (association_type_name, association_description) values ('on burnt ground with', NULL);
        insert into tbl_species_association_types (association_type_name, association_description) values ('is endoparasite of pupae of', NULL);

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;


end $$;
commit;
