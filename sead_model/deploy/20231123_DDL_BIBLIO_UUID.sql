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

*****************************************************************************************************************/

create or replace view sead_utility._temp_view_cr_20231123_ddl_biblio_uuid as
		with table_data (table_name, id_name, uuid_name) as (
			values
				('tbl_biblio', 'biblio_id', 'biblio_uuid'),
				('tbl_aggregate_datasets', 'aggregate_dataset_id', 'aggregate_dataset_uuid'),
				('tbl_dataset_masters', 'master_set_id', 'master_set_uuid'),
				('tbl_datasets', 'dataset_id', 'dataset_uuid'),
				('tbl_ecocode_systems', 'ecocode_system_id', 'ecocode_system_uuid'),
				('tbl_methods', 'method_id', 'method_uuid'),
				('tbl_rdb_systems', 'rdb_system_id', 'rdb_system_uuid'),
				('tbl_taxonomy_notes', 'taxonomy_notes_id', 'taxonomy_notes_uuid'),
				('tbl_text_biology', 'biology_id', 'biology_uuid'),
				('tbl_text_distribution', 'distribution_id', 'distribution_uuid'),
				('tbl_text_identification_keys', 'key_id', 'key_uuid'),
				('tbl_relative_ages', 'relative_age_id', 'relative_age_uuid'),
				('tbl_sites', 'site_id', 'site_uuid'),
				('tbl_sample_groups', 'sample_group_id', 'sample_group_uuid'),
				('tbl_geochronology', 'geochron_id', 'geochron_uuid'),
				('tbl_taxonomic_order_systems', 'taxonomic_order_system_id', 'taxonomic_order_system_uuid'),
				('tbl_tephras', 'tephra_id', 'tephra_uuid'),
				('tbl_site_other_records', 'site_other_records_id', 'site_other_records_uuid'),
				('tbl_species_associations', 'species_association_id', 'species_association_uuid'),
				('tbl_taxa_synonyms', 'synonym_id', 'synonym_uuid')
		) select table_name, id_name, uuid_name
		  from table_data;

create or replace procedure sead_utility._temp_cr_20231123_ddl_biblio_uuid(p_schema_name text) as $$
declare 
    v_table_name text;
    v_uuid_name text;
    v_sql_stmt text;
begin
	/* Add UUID columns to the tables that explicitly or impliciltly references bibliographic references */
	for v_table_name, v_uuid_name in (
		select table_name, uuid_name
		from sead_utility._temp_view_cr_20231123_ddl_biblio_uuid
	) loop
		if not sead_utility.column_exists(p_schema_name, v_table_name, v_uuid_name) then
			v_sql_stmt := format(
				'alter table %1$I.%2$I 
					add column if not exists %3$I uuid not null default uuid_generate_v4(),
					add constraint unique_%2$I_%3$I unique (%3$I);',
				p_schema_name, v_table_name, v_uuid_name
			);
			execute v_sql_stmt;
		end if;
    end loop;
end $$ language plpgsql;


create or replace procedure sead_utility._temp_cr_20231123_ddl_biblio_uuid_update_clearinghouse_uuids() as $$
declare 
    v_table_name text;
    v_id_name text;
    v_uuid_name text;
    v_sql_stmt text;
begin
	/* Sync the clearing house tables with UUIDs that already exist in the public database */
	for v_table_name, v_id_name, v_uuid_name in (
		select table_name, id_name, uuid_name
		from sead_utility._temp_view_cr_20231123_ddl_biblio_uuid
	) loop
		v_sql_stmt := format(
			'update clearing_house.%1$I set %3$I = public.%1$I.%3$I
			 from public.%1$I
			 where clearing_house.%1$I.transport_id = public.%1$I.%2$I;',
			v_table_name, v_id_name, v_uuid_name 
		);
		-- raise notice '%', v_sql_stmt;
		execute v_sql_stmt;
    end loop;
end $$ language plpgsql;

set role sead_master;

begin;

do $$
begin
	call sead_utility._temp_cr_20231123_ddl_biblio_uuid('public');
end $$;


-- drop table if exists bibliography_references;

-- create table if not exists bibliography_references (
-- 	uuid UUID not null,
-- 	biblio_uuid UUID not null,
-- 	primary key (uuid, biblio_uuid),
-- 	constraint fk_bibliography_references_tbl_biblio_uuid foreign key (biblio_uuid)
-- 	  references public.tbl_biblio (biblio_uuid) match simple
-- 		on update no action
-- 		on delete no action
-- );

-- delete from bibliography_references;

-- insert into bibliography_references (uuid, biblio_uuid)
-- 	select uuid, biblio_uuid
-- 	from view_bibliography_references;

create or replace view view_bibliography_references as
	select e.dataset_uuid as uuid, b.biblio_uuid
	from tbl_datasets e
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.rdb_system_uuid as uuid, b.biblio_uuid
	from tbl_rdb_systems e
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.sample_group_uuid as uuid, b.biblio_uuid
	from tbl_sample_group_references r
	join tbl_sample_groups e using (sample_group_id)
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.relative_age_uuid as uuid, b.biblio_uuid
	from tbl_relative_age_refs r
	join tbl_relative_ages e using (relative_age_id)
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.taxonomy_notes_uuid as uuid, b.biblio_uuid
	from tbl_taxonomy_notes e
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.species_association_uuid as uuid, b.biblio_uuid
	from tbl_species_associations e
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.distribution_uuid as uuid, b.biblio_uuid
	from tbl_text_distribution e
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.tephra_uuid as uuid, b.biblio_uuid
	from tbl_tephra_refs r
	join tbl_tephras e using (tephra_id)
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.ecocode_system_uuid as uuid, b.biblio_uuid
	from tbl_ecocode_systems e
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.master_set_uuid as uuid, b.biblio_uuid
	from tbl_dataset_masters e
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.site_other_records_uuid as uuid, b.biblio_uuid
	from tbl_site_other_records e
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.key_uuid as uuid, b.biblio_uuid
	from tbl_text_identification_keys e
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.geochron_uuid as uuid, b.biblio_uuid
	from tbl_geochron_refs r
	join tbl_geochronology e using (geochron_id)
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.site_uuid as uuid, b.biblio_uuid
	from tbl_site_references r
	join tbl_sites e using (site_id)
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.synonym_uuid as uuid, b.biblio_uuid
	from tbl_taxa_synonyms e
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.biology_uuid as uuid, b.biblio_uuid
	from tbl_text_biology e
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.aggregate_dataset_uuid as uuid, b.biblio_uuid
	from tbl_aggregate_datasets e
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.taxonomic_order_system_uuid as uuid, b.biblio_uuid
	from tbl_taxonomic_order_biblio r
	join tbl_taxonomic_order_systems e using (taxonomic_order_system_id)
	join tbl_biblio b using (biblio_id)
	
	union
		
	select e.method_uuid as uuid, b.biblio_uuid
	from tbl_methods e
	join tbl_biblio b using (biblio_id);

commit;

reset role;

set role clearinghouse_worker;

do $$
begin
	/* We need to update the clearinghouse commit UDFs to include the new columns */
	/* FIXME: We should also update the clearinghouse schema to include the new columns */
	call sead_utility._temp_cr_20231123_ddl_biblio_uuid('clearing_house');
	call sead_utility._temp_cr_20231123_ddl_biblio_uuid_update_clearinghouse_uuids();

    perform clearing_house_commit.generate_sead_tables();
    perform clearing_house_commit.generate_resolve_functions('public', false);

end $$ language plpgsql;

reset role;

drop view sead_utility._temp_view_cr_20231123_ddl_biblio_uuid;
drop procedure sead_utility._temp_cr_20231123_ddl_biblio_uuid(p_schema_name text);
drop procedure sead_utility._temp_cr_20231123_ddl_biblio_uuid_update_clearinghouse_uuids();

/**********************************************************************************
** Generate ADD COLUMN SQL
***********************************************************************************/
/*
begin;
do $$
declare
    v_table_name text;
    v_uuid_name text;
    v_sql_add_uuid_template text;
    v_sql text;
begin

	v_sql_add_uuid_template = '
		alter table %1$s
			add column if not exists %2$s_uuid UUID not null default uuid_generate_v4(),
			add constraint pk_%1$s_uuid unique (%2$s);
	';

	for v_table_name, v_uuid_name in (
		select *
		from (values 

			-- Entity tables that has a bibliographic reference (foreign key constrint to bibliography).
			('tbl_aggregate_datasets', 'aggregate_dataset_uuid'),
			('tbl_dataset_masters', 'master_set_uuid'),
			('tbl_datasets', 'dataset_uuid'),
			('tbl_ecocode_systems', 'ecocode_system_uuid'),
			('tbl_methods', 'method_uuid'),
			('tbl_rdb_systems', 'rdb_system_uuid'),
			('tbl_taxonomy_notes', 'taxonomy_notes_uuid'),
			('tbl_text_biology', 'biology_uuid'),
			('tbl_text_distribution', 'distribution_uuid'),
			('tbl_text_identification_keys', 'key_uuid'),

			-- Tables that has a relation to bibliography via relation table.
			('tbl_relative_ages', 'relative_age_uuid'), --'tbl_relative_age_refs', empty
			('tbl_sites', 'site_uuid'), --'tbl_site_references
			('tbl_sample_groups', 'sample_group_uuid'), --'tbl_sample_group_references
			('tbl_geochronology', 'geochron_uuid'), --'tbl_geochron_refs'
			('tbl_taxonomic_order_systems', 'taxonomic_order_system_uuid'), --'tbl_taxonomic_order_biblio', empty, rename to tbl_taxonomic_order_references?
			('tbl_tephras', 'tephra_uuid'),  --'tbl_tephra_refs'

			-- These tables are relation tables that also contains attributes and/or relations to other tables

			('tbl_site_other_records', 'site_other_records_uuid'), -- , 'site_other_records_id'
			('tbl_species_associations', 'species_association_uuid'), -- , 'species_association_id'
			('tbl_taxa_synonyms', 'synonym_uuid') -- , 'synonym_id'

		) as t (table_name, uuid_name)
	) loop
		v_sql = format(v_sql_add_uuid_template, v_table_name, v_uuid_name);
		raise notice '%', v_sql;
		-- execute v_sql;
	end loop;
end $$ language plpgsql;
*/

/**********************************************************************************
** Generate CREATE VIEW SQL
***********************************************************************************/
/*
begin;
do $$
declare
    v_sql text;
begin

	with table_with_biblio_fk_key as (
		select table_name
		from (values 
			('tbl_aggregate_datasets'),
			('tbl_dataset_masters'),
			('tbl_datasets'),
			('tbl_ecocode_systems'),
			('tbl_methods'),
			('tbl_rdb_systems'),
			('tbl_taxonomy_notes'),
			('tbl_text_biology'),
			('tbl_text_distribution'),
			('tbl_text_identification_keys'),
			('tbl_site_other_records'),
			('tbl_species_associations'),
			('tbl_taxa_synonyms')
		) as v(table_name)
	),
	tables_with_relation_table as (
		select *
		from (values 
			('tbl_relative_ages', 'tbl_relative_age_refs', 'relative_age_id', 'relative_age_uuid'),			         -- empty, rename to tbl_relative_age_references
			('tbl_sites', 'tbl_site_references', 'site_id', 'site_uuid'),                                            -- tbl_site_references
			('tbl_sample_groups', 'tbl_sample_group_references', 'sample_group_id', 'sample_group_uuid'),                    --
			('tbl_geochronology', 'tbl_geochron_refs', 'geochron_id', 'geochron_uuid'),                                  -- empty, rename to tbl_geochron_references
			('tbl_taxonomic_order_systems', 'tbl_taxonomic_order_biblio', 'taxonomic_order_system_id', 'taxonomic_order_system_uuid'), -- empty, rename to tbl_taxonomic_order_references?
			('tbl_tephras', 'tbl_tephra_refs', 'tephra_id', 'tephra_uuid')                                             -- empty
		) as t (table_name, relation_name, id_name, uuid_name)
	),
	fk_sql as (
		
		select format('select e.%1$s as uuid, b.biblio_uuid
	from %2$s e
	join tbl_biblio b using (biblio_id)
	', column_name, table_name) as sql
		from sead_utility.table_columns
		join table_with_biblio_fk_key using (table_name)
		where table_schema = 'public'
		and column_name like '%_uuid'
	),
	relation_sql as (	
		select format('select e.%1$s as uuid, b.biblio_uuid
	from %2$s r
	join %3$s e using (%4$s)
	join tbl_biblio b using (biblio_id)
	', uuid_name, relation_name, table_name, id_name) as sql
		from tables_with_relation_table
	)
		select 'create or replace view view_bibliography_references as
	' || string_agg(sql, '
	union
		
	')
		into v_sql
		from (
			select sql
			from fk_sql
			union
			select sql
			from relation_sql
		) as sql
	;

	raise notice '%', v_sql;
	-- execute v_sql;
	
end $$ language plpgsql;
*/