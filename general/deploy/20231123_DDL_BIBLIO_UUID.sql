-- Deploy general: 20231123_DDL_BIBLIO_UUID
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
	
		/*
        alter table tbl_biblio
            add column if not exists uuid UUID not null default uuid_generate_v4(),
            add constraint pk_tbl_biblio_uuid unique (uuid);
		*/
		
        create table if not exists bibliography_references (
            uuid UUID not null,
            biblio_uuid UUID not null,
            date_updated timestamp with time zone DEFAULT now(),
            primary key (uuid, biblio_uuid),
			constraint fk_bibliography_references_tbl_biblio_uuid foreign key (biblio_uuid)
			  references public.tbl_biblio (uuid) match simple
				on update no action
				on delete no action
        );

        v_sql_add_uuid_template = '
            alter table %1$s
                add column if not exists uuid UUID not null default uuid_generate_v4(),
                add constraint pk_%1$s_uuid unique (uuid);
        ';

        v_sql_add_fk_template = '
            alter table %1$s
                add column if not exists biblio_uuid UUID null,
                add constraint fk_%1$s_tbl_biblio_uuid foreign key (biblio_uuid)
                    references public.tbl_biblio (uuid) match simple
                    on update no action
                    on delete no action;
        ';

        v_sql_update_fk_template = '
            update %1$s
            set biblio_uuid = tbl_biblio.uuid
            from tbl_biblio
            where %1$s.biblio_id = tbl_biblio.biblio_id;
        ';

        v_sql_insert_by_fk_template = '
            insert into bibliography_references (uuid, biblio_uuid)
                select %1$s.uuid, tbl_biblio.uuid
                from %1$s
                join tbl_biblio using (biblio_id);
        ';

        v_sql_insert_by_table_template = '
            insert into bibliography_references (uuid, biblio_uuid, date_updated)
                select %1$s.uuid, tbl_biblio.uuid, %2$s.date_updated
                from %1$s
                join %2$s using (%3$s)
                join tbl_biblio using (biblio_id);
        ';

        /*
            Entity tables that has a bibliographic reference (foreign key constrint to bibliography).

            NOTE: Bibliography ID will be dropped in the future!
            TODO: Add to bibliography_references

        */
        for v_table_name in (
            select *
            from (values 
                ('tbl_ecocode_systems'),
                ('tbl_dataset_masters'),
                ('tbl_datasets'),
                ('tbl_aggregate_datasets'),
                ('tbl_taxonomy_notes'),
                ('tbl_methods'),
                ('tbl_rdb_systems'),
                ('tbl_text_biology'),
                ('tbl_text_distribution'),
                ('tbl_text_identification_keys')
            ) as t (table_name)
        ) loop

            v_sql = format(v_sql_add_uuid_template, v_table_name);
            raise notice 'Executing: %', v_sql;
            execute v_sql;

            v_sql = format(v_sql_insert_by_fk_template, v_table_name);
            raise notice 'Executing: %', v_sql;
            execute v_sql;

        end loop;

        /*
            Tables that has a relation to bibliography via relation table.

            NOTE: Relation table will be dropped (or replaced by a view) in the future!
            TODO: Add to bibliography_references

        */
        for v_table_name, v_relation_name, v_id_name in (
            select *
            from (values 
                ('tbl_relative_ages', 'tbl_relative_age_refs', 'relative_age_id'),			                -- empty, rename to tbl_relative_age_references
                ('tbl_sites', 'tbl_site_references', 'site_id'),                                            -- tbl_site_references
                ('tbl_sample_groups', 'tbl_sample_group_references', 'sample_group_id'),                    --
                ('tbl_geochronology', 'tbl_geochron_refs', 'geochron_id'),                                  -- empty, rename to tbl_geochron_references
                ('tbl_taxonomic_order_systems', 'tbl_taxonomic_order_biblio', 'taxonomic_order_system_id'), -- empty, rename to tbl_taxonomic_order_references?
                ('tbl_tephras', 'tbl_tephra_refs', 'tephra_id')                                             -- empty
            ) as t (table_name)
        ) loop

            v_sql = format(v_sql_add_uuid_template, v_table_name);
            raise notice 'Executing: %', v_sql;
            execute v_sql;

            v_sql = format(v_sql_insert_by_table_template, v_table_name, v_relation_name, v_id_name);
            raise notice 'Executing: %', v_sql;
            execute v_sql;

        end loop;

        /*
            Add forreign key references to bibliography (UUID)
            These tables contains attriibutes and relations to other tables
        */

        for v_table_name in (
            select *
            from (values 
                ('tbl_species_associations'),
                ('tbl_taxa_synonyms'),
                ('tbl_site_other_records')
            ) as t (table_name)
        ) loop

            v_sql = format(v_sql_add_fk_template, v_table_name);
            raise notice 'Executing: %', v_sql;
            execute v_sql;

            v_sql = format(v_sql_update_fk_template, v_table_name);
            raise notice 'Executing: %', v_sql;
            execute v_sql;

        end loop;
	end;
	
end $$
language plpgsql
