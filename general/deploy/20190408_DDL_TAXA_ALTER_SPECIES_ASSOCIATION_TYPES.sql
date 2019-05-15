-- Deploy sead_db_change_control:CSR_20190408_REFACTOR_SPECIES_ASSOCIATION_TYPES to pg

do $$
begin
    perform sead_utility.set_as_serial('tbl_species_association_types', 'association_type_id');
end $$;