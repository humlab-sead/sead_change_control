-- Deploy general: 20231123_DDL_BIBLIO_UUID

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2023-11-23
  Issue         https://github.com/humlab-sead/sead_change_control/issues/144
  Description   Add UUID to bibliographic data.
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

/*
    select format('select * from %s', table_name)
    from sead_utility.foreign_key_columns
    where table_schema = 'public'
    and foreign_table_name = 'tbl_biblio'
    -- and column_name = 'biblio_id'

    -- relation with attributes
    select * from tbl_species_associations;

    -- relation
    select * from tbl_relative_age_refs				-- empty, rename to tbl_relative_age_references
    select * from tbl_site_references
    select * from tbl_sample_group_references
    select * from tbl_geochron_refs                 -- empty, rename to tbl_geochron_references
    select * from tbl_taxonomic_order_biblio        -- empty, rename to tbl_taxonomic_order_references?
    select * from tbl_tephra_refs
    -- ==> global entity relation table
    -- drop table

    -- entity tables with bibliographic reference (biblio_id)
    select * from tbl_ecocode_systems
    select * from tbl_dataset_masters
    select * from tbl_datasets
    select * from tbl_aggregate_datasets		-- empty
    select * from tbl_taxonomy_notes
    select * from tbl_methods
    select * from tbl_rdb_systems
    select * from tbl_text_biology
    select * from tbl_text_distribution         -- entity?
    select * from tbl_text_identification_keys	-- entity?
    -- ==> global entity relation table
    -- drop biblio_id

    -- biblio_id is null in all records
    select * from tbl_site_other_records where biblio_id is not null
    -- table is empty
    select * from tbl_taxa_synonyms
*/


begin;
do $$
declare
    v_table_name text;
    v_uuid_name text;
    v_relation_name text;
    v_id_name text;
    v_sql_add_uuid_template text;
    v_sql_add_fk_template text;
    v_sql_update_fk_template text;
    v_sql_insert_by_fk_template text;
    v_sql_insert_by_table_template text;
    v_sql text;
begin
    begin
	
        alter table tbl_biblio
            add column if not exists biblio_uuid UUID not null default uuid_generate_v4(),
            add constraint pk_tbl_biblio_uuid unique (biblio_uuid);

        -- create table if not exists bibliography_references (
        --     uuid UUID not null,
        --     biblio_uuid UUID not null,
        --     primary key (uuid, biblio_uuid),
		-- 	constraint fk_bibliography_references_tbl_biblio_uuid foreign key (biblio_uuid)
		-- 	  references public.tbl_biblio (biblio_uuid) match simple
		-- 		on update no action
		-- 		on delete no action
        -- );

        v_sql_add_uuid_template = '
            alter table %1$s
                add column if not exists %2$s_uuid UUID not null default uuid_generate_v4(),
                add constraint pk_%1$s_uuid unique (%2$s_uuid);
        ';
/*
        v_sql_add_fk_template = '
            alter table %1$s
                add column if not exists biblio_uuid UUID null,
                add constraint fk_%1$s_tbl_biblio_biblio_uuid foreign key (biblio_uuid)
                    references public.tbl_biblio (biblio_uuid) match simple
                    on update no action
                    on delete no action;
        ';

        v_sql_update_fk_template = '
            update %1$s
            set biblio_uuid = tbl_biblio.biblio_uuid
            from tbl_biblio
            where %1$s.biblio_id = tbl_biblio.biblio_id;
        ';

        v_sql_insert_by_fk_template = '
            insert into bibliography_references (%1$s.%2$s, biblio_uuid)
                select %1$s.biblio_uuid, tbl_biblio.biblio_uuid
                from %1$s
                join tbl_biblio using (biblio_id);
        ';

        v_sql_insert_by_table_template = '
            insert into bibliography_references (uuid, biblio_uuid)
                select %1$s.%4$s, tbl_biblio.biblio_uuid
                from %1$s
                join %2$s using (%3$s)
                join tbl_biblio using (biblio_id);
        ';
*/

        /*
            Entity tables that has a bibliographic reference (foreign key constrint to bibliography).

            NOTE: Bibliography ID will be dropped in the future!
            TODO: Add to bibliography_references

        */
        for v_table_name, v_uuid_name in (
            select *
            from (values 
                ('tbl_aggregate_datasets', 'aggregate_dataset_uuid'),
                ('tbl_dataset_masters', 'master_set_uuid'),
                ('tbl_datasets', 'dataset_uuid'),
                ('tbl_ecocode_systems', 'ecocode_system_uuid'),
                ('tbl_methods', 'method_uuid'),
                ('tbl_rdb_systems', 'rdb_system_uuid'),
                ('tbl_taxonomy_notes', 'taxonomy_notes_uuid'),
                ('tbl_text_biology', 'biology_uuid'),
                ('tbl_text_distribution', 'distribution_uuid'),
                ('tbl_text_identification_keys', 'key_uuid')
            ) as t (table_name, uuid_name)
        ) loop

            v_sql = format(v_sql_add_uuid_template, v_table_name, v_uuid_name);
            raise notice 'Executing: %', v_sql;
            execute v_sql;

            -- v_sql = format(v_sql_insert_by_fk_template, v_table_name, v_uuid_name);
            -- raise notice 'Executing: %', v_sql;
            -- execute v_sql;

        end loop;

        /*
            Tables that has a relation to bibliography via relation table.

            NOTE: Relation table will be dropped (or replaced by a view) in the future!
            TODO: Add to bibliography_references

        */
        for v_table_name, v_relation_name, v_id_name, v_uuid_name in (
            select *
            from (values 
                ('tbl_relative_ages', 'tbl_relative_age_refs', 'relative_age_id', 'relative_age_uuid'),			         -- empty, rename to tbl_relative_age_references
                ('tbl_sites', 'tbl_site_references', 'site_id', 'site_uuid'),                                            -- tbl_site_references
                ('tbl_sample_groups', 'tbl_sample_group_references', 'sample_group_id', 'sample_group_uuid'),                    --
                ('tbl_geochronology', 'tbl_geochron_refs', 'geochron_id', 'geochron_id'),                                  -- empty, rename to tbl_geochron_references
                ('tbl_taxonomic_order_systems', 'tbl_taxonomic_order_biblio', 'taxonomic_order_system_id', 'taxonomic_order_system_uuid'), -- empty, rename to tbl_taxonomic_order_references?
                ('tbl_tephras', 'tbl_tephra_refs', 'tephra_id', 'tephra_uuid')                                             -- empty
            ) as t (table_name, relation_name, id_name, uuid_name)
        ) loop

            v_sql = format(v_sql_add_uuid_template, v_table_name, v_uuid_name);
            raise notice 'Executing: %', v_sql;
            execute v_sql;

            -- v_sql = format(v_sql_insert_by_table_template, v_table_name, v_relation_name, v_id_name, v_uuid_name);
            -- raise notice 'Executing: %', v_sql;
            -- execute v_sql;

        end loop;

        /*
            Add forreign key references to bibliography (UUID)
            These tables are relation tables that also contains attributes and/or relations to other tables
        */

        for v_table_name, v_id_name, v_uuid_name in (
            select *
            from (values 
                ('tbl_site_other_records', 'site_other_records_id', 'site_other_records_uuid'),
                ('tbl_species_associations', 'species_association_id', 'species_association_uuid'),
                ('tbl_taxa_synonyms', 'synonym_id', 'synonym_uuid')
            ) as t (table_name, id_name, uuid_name)
        ) loop

            v_sql = format(v_sql_add_fk_template, v_table_name);
            raise notice 'Executing: %', v_sql;
            execute v_sql;

            -- v_sql = format(v_sql_update_fk_template, v_table_name);
            -- raise notice 'Executing: %', v_sql;
            -- execute v_sql;

            -- FIXME: Should we also add records to bibliography_references?

        end loop;
	end;
	
end $$
language plpgsql
