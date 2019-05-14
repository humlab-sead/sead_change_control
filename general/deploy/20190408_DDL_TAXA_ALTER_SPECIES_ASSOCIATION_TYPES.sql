-- Deploy sead_db_change_control:CSR_20190408_REFACTOR_SPECIES_ASSOCIATION_TYPES to pg

begin;
do $$
begin

    begin
    
        IF NOT EXISTS (SELECT 1 FROM pg_class where relname = 'tbl_species_association_types_association_type_id_seq' )
        THEN
            CREATE SEQUENCE "tbl_species_association_types_association_type_id_seq";
        END IF;

        alter table tbl_species_association_types DROP CONSTRAINT if exists "tbl_association_types_pkey";
        
        ALTER TABLE tbl_species_association_types
            ALTER COLUMN "association_type_id"
                SET DEFAULT nextval('tbl_species_association_types_association_type_id_seq'::regclass);
                
        SELECT setval('tbl_species_association_types_association_type_id_seq', COALESCE((SELECT MAX(association_type_id)+1 FROM tbl_species_association_types), 1), false);

        ALTER TABLE tbl_species_association_types ADD CONSTRAINT "tbl_species_association_types_pkey" PRIMARY KEY (association_type_id);
        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
