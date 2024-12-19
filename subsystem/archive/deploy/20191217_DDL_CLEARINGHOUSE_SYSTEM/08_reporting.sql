
/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_locations
**	Who			Roger Mähler
**	When		2013-10-14
**	What		Displays all locations found in the submissed data
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Select * From clearing_house.fn_clearinghouse_report_locations(2)
create or replace function clearing_house.fn_clearinghouse_report_locations(int)
Returns Table (

	local_db_id int,
	entity_type_id int,

	location_id int,
	location_name character varying(255),
	default_lat_dd numeric(18,10),
	default_long_dd numeric(18,10),
	date_updated text,
	location_type_id int,
	location_type character varying(40),
	description text,

	public_location_id int,
	public_location_name character varying(255),
	public_default_lat_dd numeric(18,10),
	public_default_long_dd numeric(18,10),
	public_location_type_id int,
	public_location_type character varying(40),
	public_description text

) As $$

Declare
    entity_type_id int;
Begin

	entity_type_id := clearing_house.fn_get_entity_type_for('tbl_locations');

	Return Query
		Select	l.local_db_id						                            as local_db_id,
				entity_type_id						                            as entity_type_id,
				l.local_db_id						                            as location_id,
				l.location_name						                            as location_name,
				l.default_lat_dd                                                as default_lat_dd,
				l.default_long_dd                                               as default_long_dd,
				to_char(l.date_updated,'YYYY-MM-DD')                            as date_updated,
				l.location_type_id                                              as location_type_id,
				Coalesce(t.location_type, p.location_type)						as location_type,
				t.description						                            as description,

				p.location_id						                            as public_location_id,
				p.location_name						                            as public_location_name,
				p.default_lat_dd					                            as public_default_lat_dd,
				p.default_long_dd					                            as public_default_long_dd,
				p.location_type_id					                            as public_location_type_id,
				p.location_type						                            as public_location_type,
				p.description						                            as public_description

		From clearing_house.view_locations l
		Join clearing_house.view_location_types t
		  On t.merged_db_id = l.location_type_id
		 And t.submission_id In (0, l.submission_id)
		Full Outer Join(
			Select l.location_id, l.location_name, l.default_lat_dd, l.default_long_dd, t.location_type_id, t.location_type, t.description
			From public.tbl_locations l
			Join public.tbl_location_types t
			  On t.location_type_id = l.location_type_id
		) as p
		  On p.location_id = l.public_db_id
		Where l.submission_id = $1;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_bibliographic_entries
**	Who			Roger Mähler
**	When		2013-10-14
**	What		Displays all bibliographic entries found in the submissed data
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function If Exists clearing_house.fn_clearinghouse_report_bibliographic_entries(int);
-- Select * From clearing_house.fn_clearinghouse_report_bibliographic_entries(32)
create or replace function clearing_house.fn_clearinghouse_report_bibliographic_entries(int)
Returns Table (

	local_db_id int,
    authors varchar,
    title varchar,
    full_reference text,
    url varchar,
    doi varchar,

	public_db_id int,

    public_authors varchar,
    public_title varchar,
    public_full_reference text,
    public_url varchar,
    public_doi varchar,

    date_updated text,				-- display only if update

	entity_type_id int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_biblio');

	Return Query

		Select
			LDB.local_db_id                            	As local_db_id,
			LDB.authors                                 As authors,
			LDB.title                                   As title,
			LDB.full_reference                          As full_reference,
			LDB.url                                     As url,
			LDB.doi                                     As doi,

			LDB.public_db_id                            As public_db_id,

			RDB.authors                                 As public_authors,
			RDB.title                                   As public_title,
			RDB.full_reference                          As public_full_reference,
			RDB.url                                     As public_url,
			RDB.doi                                     As doi,

			to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
			entity_type_id              				As entity_type_id
		From (

			Select	b.submission_id																			As submission_id,
					b.source_id																				As source_id,
					b.biblio_id																				As local_db_id,
					b.public_db_id																			As public_db_id,
					b.authors                    													        As authors,
					b.full_reference                    													As full_reference,
					b.title															                        As title,
					b.url															                        As url,
					b.doi															                        As doi,
					b.date_updated																			As date_updated

			From clearing_house.view_biblio b

		) As LDB Left Join (

			Select	b.biblio_id																				As biblio_id,
					b.authors                    													        As authors,
					b.full_reference                														As full_reference,
					b.title   														                        As title,
					b.url   														                        As url,
					b.doi   														                        As doi,
					b.date_updated																			As date_updated

			From public.tbl_biblio b

		) As RDB
		  On RDB.biblio_id = LDB.public_db_id

		Where LDB.source_id = 1
		  And LDB.submission_id = $1;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_taxonomic_order
**	Who			Roger Mähler
**	When		2013-11-19
**	What		Displays taxonomic order found in the submissed data
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_report_taxonomic_order(int)
-- Select * From clearing_house.fn_clearinghouse_report_taxonomic_order(2)
create or replace function clearing_house.fn_clearinghouse_report_taxonomic_order(int)
Returns Table (

	local_db_id int,

	species text,
	taxonomic_code numeric(18,10),
	system_name character varying,
	reference text,

	public_db_id int,

	public_species text,
	public_taxonomic_code numeric(18,10),
	public_system_name character varying,
	public_reference text,

    date_updated text,
	entity_type_id int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_taxonomic_order ');

	Return Query

		Select
			LDB.local_db_id                            	As local_db_id,

			LDB.species,
			LDB.taxonomic_code,
			LDB.system_name,
			LDB.reference,

  			LDB.public_db_id                            As public_db_id,

			RDB.public_species,
			RDB.public_taxonomic_code,
			RDB.public_system_name,
			RDB.public_reference,


			to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
			entity_type_id              				As entity_type_id

		From (

				select t.submission_id,
					   t.source_id,
					   t.taxon_id																As local_db_id,
					   t.public_db_id															As public_db_id,
					   g.genus_name || ' ' || t.species || ' ' || coalesce(a.author_name, '')	As species,
					   o.taxonomic_code,
					   s.system_name,
					   b.authors || '(' || b.year || ')' as reference,
					   t.date_updated

				from clearing_house.view_taxa_tree_master t
				join clearing_house.view_taxa_tree_genera g
				  on t.genus_id = g.merged_db_id
				 and g.submission_id in (0, t.submission_id)
				left join clearing_house.view_taxa_tree_authors a
				  on t.author_id = a.merged_db_id
				 and a.submission_id in (0, t.submission_id)
				Join clearing_house.view_taxonomic_order o
				  on o.taxon_id = t.merged_db_id
				 and o.submission_id in (0, t.submission_id)
				Join clearing_house.view_taxonomic_order_systems s
				  On o.taxonomic_order_system_id = s.merged_db_id
				 And s.submission_id in (0, o.submission_id)
				Join clearing_house.view_taxonomic_order_biblio bo
				  On bo.taxonomic_order_system_id = s.merged_db_id
				 And bo.submission_id in (0, o.submission_id)
				Join clearing_house.view_biblio b
				  On b.merged_db_id = bo.biblio_id
				 And b.submission_id in (0, o.submission_id)
				--Where o.submission_id = $1
				--Order by 4 /* species */

		) As LDB Left Join (

				select t.taxon_id As taxon_id,
					   g.genus_name || ' ' || t.species || ' ' || coalesce(a.author_name, '')	As public_species,
					   o.taxonomic_code															As public_taxonomic_code,
					   s.system_name															As public_system_name,
					   b.authors || '(' || b.year || ')'											as public_reference

				from public.tbl_taxa_tree_master t
				join public.tbl_taxa_tree_genera g
				  on t.genus_id = g.genus_id
				left join public.tbl_taxa_tree_authors a
				  on t.author_id = a.author_id
				Join public.tbl_taxonomic_order o
				  on o.taxon_id = t.taxon_id
				Join public.tbl_taxonomic_order_systems s
				  On o.taxonomic_order_system_id = s.taxonomic_order_system_id
				Join public.tbl_taxonomic_order_biblio bo
				  On bo.taxonomic_order_system_id = s.taxonomic_order_system_id
				Join public.tbl_biblio b
				  On b.biblio_id = bo.biblio_id
				--Where o.submission_id = $1
				--Order by 4 /* species */

		) As RDB
		  On RDB.taxon_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		Order By LDB.species;
End $$ Language plpgsql;
/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_taxa_rdb
**	Who			Erik Eriksson
**	When		2013-11-21
**	What		Displays RDB data for a taxa found in the (supplied) submission data
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_report_taxa_rdb(int)
-- Select * From clearing_house.fn_clearinghouse_report_taxa_rdb(2)
create or replace function clearing_house.fn_clearinghouse_report_taxa_rdb(int)
Returns Table (

	local_db_id int,

	species text,
    location_name character varying,
	rdb_category character varying,
    rdb_definition character varying,
	rdb_system character varying,
	reference text,

	public_db_id int,

	public_species text,
	public_location_name character varying,
	public_rdb_category character varying,
    public_rdb_definition character varying,
	public_rdb_system character varying,
    public_reference text,

    date_updated text,
	entity_type_id int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_rdb ');

	Return Query

		Select
			LDB.local_db_id                            	As local_db_id,

			LDB.species,
			LDB.location_name,
			LDB.rdb_category,
			LDB.rdb_definition,
			LDB.rdb_system,
			LDB.reference,

  			LDB.public_db_id                            As public_db_id,

			RDB.public_species,
			RDB.public_location_name,
			RDB.public_rdb_category,
			RDB.public_rdb_definition,
			RDB.public_rdb_system,
			RDB.public_reference,


			to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
			entity_type_id              				As entity_type_id

		From (

				select t.submission_id,
					t.source_id,
					t.taxon_id As local_db_id,
					t.public_db_id As public_db_id,
					g.genus_name || ' ' || t.species || ' ' || coalesce(a.author_name, '')	As species,
					l.location_name,
					c.rdb_category,
					c.rdb_definition,
					s.rdb_system,
					b.authors || '(' || b.year || ')' as reference,
					t.date_updated

				from clearing_house.view_taxa_tree_master t
				join clearing_house.view_taxa_tree_genera g
				  on t.genus_id = g.merged_db_id
				 and g.submission_id in (0, t.submission_id)
				left join clearing_house.view_taxa_tree_authors a
				  on t.author_id = a.merged_db_id
				 and a.submission_id in (0, t.submission_id)
				join clearing_house.view_rdb r
				  on r.taxon_id = t.merged_db_id
				 and r.submission_id in (0, t.submission_id)
				join clearing_house.view_rdb_codes c
				  on c.merged_db_id = r.rdb_code_id
				 and c.submission_id in (0, t.submission_id)
				join clearing_house.view_rdb_systems s
				  on s.merged_db_id = c.rdb_system_id
				 and s.submission_id in (0, t.submission_id)
				Join clearing_house.view_biblio b
				  On b.merged_db_id = s.biblio_id
				 And b.submission_id in (0, t.submission_id)
				join clearing_house.view_locations l
				  on l.merged_db_id = r.location_id
				 and l.submission_id in (0, t.submission_id)


		) As LDB Left Join (

				select
					t.taxon_id As taxon_id,
					g.genus_name || ' ' || t.species || ' ' || coalesce(a.author_name, '')	As public_species,
					l.location_name as public_location_name,
					c.rdb_category as public_rdb_category,
					c.rdb_definition as public_rdb_definition,
					s.rdb_system as public_rdb_system,
					b.authors || '(' || b.year || ')' as public_reference,
					t.date_updated

				from clearing_house.tbl_taxa_tree_master t
				join clearing_house.tbl_taxa_tree_genera g
				  on t.genus_id = g.genus_id
				left join public.tbl_taxa_tree_authors a
				  on t.author_id = a.author_id
				join public.tbl_rdb r
				  on r.taxon_id = t.taxon_id
				join public.tbl_rdb_codes c
				  on c.rdb_code_id = r.rdb_code_id
				join public.tbl_rdb_systems s
				  on s.rdb_system_id = c.rdb_system_id
				Join public.tbl_biblio b
				  On b.biblio_id = s.biblio_id
				join public.tbl_locations l
				  on l.location_id = r.location_id

		) As RDB
		  On RDB.taxon_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		Order By LDB.species;
End $$ Language plpgsql;
/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_taxa_ecocodes
**	Who			Erik Eriksson
**	When		2013-11-21
**	What		Displays ecocode data for a taxa found in the (supplied) submission data
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_report_taxa_ecocodes(int)
-- Select * From clearing_house.fn_clearinghouse_report_taxa_ecocodes(2)
create or replace function clearing_house.fn_clearinghouse_report_taxa_ecocodes(int)
Returns Table (

	local_db_id int,

	species text,
	abbreviation character varying,
	label character varying,
	definition text,
	notes text,
	group_label character varying,
	system_name character varying,
	reference text,

	public_db_id int,

	public_species text,
	public_abbreviation character varying,
	public_label character varying,
	public_definition text,
	public_notes text,
	public_group_label character varying,
	public_system_name character varying,
	public_reference text,

    date_updated text,
	entity_type_id int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_ecocodes ');

	Return Query

		Select
			LDB.local_db_id                            	As local_db_id,

			LDB.species,
			LDB.abbreviation,
			LDB.label,
			LDB.definition,
			LDB.notes,
			LDB.group_label,
			LDB.system_name,
			LDB.reference,

  			LDB.public_db_id                            As public_db_id,

			RDB.public_species,
			RDB.public_abbreviation,
			RDB.public_label,
			RDB.public_definition,
			RDB.public_notes,
			RDB.public_group_label,
			RDB.public_system_name,
			RDB.public_reference,

			to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
			entity_type_id              				As entity_type_id

		From (
				select t.submission_id,
					t.source_id,
					t.taxon_id As local_db_id,
					t.public_db_id As public_db_id,
					g.genus_name || ' ' || t.species || ' ' || coalesce(a.author_name, '')	As species,
					ed.abbreviation,
					ed.label,
					ed.definition,
					ed.notes,
					eg.label as group_label,
					es.name as system_name,
					b.authors || '(' || b.year || ')' as reference,
					t.date_updated

				from clearing_house.view_taxa_tree_master t
				join clearing_house.view_taxa_tree_genera g
				  on t.genus_id = g.merged_db_id
				 and g.submission_id in (0, t.submission_id)
				left join clearing_house.view_taxa_tree_authors a
				  on t.author_id = a.merged_db_id
				 and a.submission_id in (0, t.submission_id)
                                join clearing_house.view_ecocodes e
                                  on e.taxon_id = t.merged_db_id
                                 and e.submission_id in (0, t.submission_id)
                                join clearing_house.view_ecocode_definitions ed
                                  on ed.merged_db_id = e.ecocode_definition_id
                                 and ed.submission_id in (0, t.submission_id)
                                join clearing_house.view_ecocode_groups eg
                                  on eg.merged_db_id = ed.ecocode_group_id
                                 and eg.submission_id in (0, t.submission_id)
                                join clearing_house.view_ecocode_systems es
                                  on es.merged_db_id = eg.ecocode_system_id
                                 and es.submission_id in (0, t.submission_id)
				Join clearing_house.view_biblio b
				  On b.merged_db_id = es.biblio_id
				 And b.submission_id in (0, t.submission_id)

		) As LDB Left Join (

				select
					t.taxon_id As taxon_id,
					g.genus_name || ' ' || t.species || ' ' || coalesce(a.author_name, '')	As public_species,
					ed.abbreviation as public_abbreviation,
					ed.label as public_label,
					ed.definition as public_definition,
					ed.notes as public_notes,
					eg.label as public_group_label,
					es.name as public_system_name,
					b.authors || '(' || b.year || ')' as public_reference,
					t.date_updated

				from public.tbl_taxa_tree_master t
				join public.tbl_taxa_tree_genera g
				  on t.genus_id = g.genus_id
				left join public.tbl_taxa_tree_authors a
				  on t.author_id = a.author_id
				join public.tbl_ecocodes e
				  on e.taxon_id = t.taxon_id
				join public.tbl_ecocode_definitions ed
				  on ed.ecocode_definition_id = e.ecocode_definition_id
				join public.tbl_ecocode_groups eg
				  on eg.ecocode_group_id = ed.ecocode_group_id
				join public.tbl_ecocode_systems es
				  on es.ecocode_system_id = eg.ecocode_system_id
				Join public.tbl_biblio b
				  On b.biblio_id = es.biblio_id

		) As RDB
		  On RDB.taxon_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		Order By LDB.species;
End $$ Language plpgsql;
/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_taxa_tree_master
**	Who			Erik Eriksson
**	When		2013-11-21
**	What		Displays taxa data for uploaded species, together with associations and common names
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_report_taxa_tree_master(int)
-- Select * From clearing_house.fn_clearinghouse_report_taxa_tree_master(2)
create or replace function clearing_house.fn_clearinghouse_report_taxa_tree_master(int)
Returns Table (

	local_db_id int,

	order_name character varying,
	family character varying,
	species text,
	association_type_name character varying,
	association_species text,
	common_name character varying,
	language_name character varying,

	public_db_id int,

	public_order_name character varying,
	public_family character varying,
	public_species text,
	public_association_type_name character varying,
	public_association_species text,
	public_common_name character varying,
	public_language_name character varying,

    date_updated text,
	entity_type_id int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_taxa_tree_master ');

	Return Query

		Select
			LDB.local_db_id                            	As local_db_id,

			LDB.order_name,
			LDB.family,
			LDB.species,
			LDB.association_type_name,
			LDB.association_species,
			LDB.common_name,
			LDB.language_name,

  			LDB.public_db_id                            As public_db_id,

			RDB.public_order_name,
			RDB.public_family,
			RDB.public_species,
			RDB.public_association_type_name,
			RDB.public_association_species,
			RDB.public_common_name,
			RDB.public_language_name,

			to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
			entity_type_id              				As entity_type_id

		From (

			select t.submission_id,
				t.source_id,
				t.taxon_id As local_db_id,
				t.public_db_id As public_db_id,
				o.order_name as order_name,
				f.family_name as family,
				g.genus_name || ' ' || t.species || ' ' || coalesce(a.author_name, '')	As species,
				sat.association_type_name,
				sa_genera.genus_name || ' ' || sa_species.species || ' ' || coalesce(sa_authors.author_name, '') as association_species,
				cn.common_name,
				l.language_name_english as language_name,
				t.date_updated
			from clearing_house.view_taxa_tree_master t
			join clearing_house.view_taxa_tree_genera g
			 on t.genus_id = g.merged_db_id
			 and g.submission_id in (0, t.submission_id)
			join clearing_house.view_taxa_tree_families f
			 on g.family_id = f.merged_db_id
			 and f.submission_id in (0, t.submission_id)
			join clearing_house.view_taxa_tree_orders o
			 on o.order_id = f.merged_db_id
			 and o.submission_id in (0, t.submission_id)
			left join clearing_house.view_taxa_tree_authors a
			 on t.author_id = a.merged_db_id
			 and a.submission_id in (0, t.submission_id)
			-- associations
			left join clearing_house.view_species_associations sa
			 on t.taxon_id = sa.merged_db_id
			 and sa.submission_id in (0, t.submission_id)
			left join clearing_house.view_species_association_types sat
			 on sat.association_type_id = sa.merged_db_id
			 and sat.submission_id in (0, t.submission_id)
			left join clearing_house.view_taxa_tree_master sa_species
			 on sa.associated_taxon_id = sa_species.merged_db_id
			 and sa_species.submission_id in (0, t.submission_id)
			left join clearing_house.view_taxa_tree_genera sa_genera
			 on sa_species.genus_id = sa_genera.merged_db_id
			 and sa_genera.submission_id in (0, t.submission_id)
			left join clearing_house.view_taxa_tree_authors sa_authors
			 on sa_species.author_id = sa_authors.merged_db_id
			 and sa_authors.submission_id in (0, t.submission_id)
			-- // end associations
			--common names
			left join clearing_house.view_taxa_common_names cn
			 on cn.merged_db_id = t.taxon_id
			 and cn.submission_id in (0, t.submission_id)
			left join clearing_house.view_languages l
			 on cn.language_id = l.merged_db_id
			 and l.submission_id in (0, t.submission_id)
            -- // end common names

		) As LDB Left Join (
			select
				t.taxon_id As taxon_id,
				o.order_name as public_order_name,
				f.family_name as public_family,
				g.genus_name || ' ' || t.species || ' ' || coalesce(a.author_name, '') as public_species,
				sat.association_type_name as public_association_type_name,
				sa_genera.genus_name || ' ' || sa_species.species || ' ' || coalesce(sa_authors.author_name, '') as public_association_species,
				cn.common_name as public_common_name,
				l.language_name_english as public_language_name
			  from public.tbl_taxa_tree_master t
			  join public.tbl_taxa_tree_genera g
			   on t.genus_id = g.genus_id
			  join public.tbl_taxa_tree_families f
			   on g.family_id = f.family_id
			  join public.tbl_taxa_tree_orders o
			   on o.order_id = f.order_id
			  left join public.tbl_taxa_tree_authors a
			   on t.author_id = a.author_id
			  -- associations
			  left join public.tbl_species_associations sa
			   on t.taxon_id = sa.taxon_id
			  left join public.tbl_species_association_types sat
			   on sat.association_type_id = sa.association_type_id
			  left join public.tbl_taxa_tree_master sa_species
			   on sa.associated_taxon_id = sa_species.taxon_id
			  left join public.tbl_taxa_tree_genera sa_genera
			   on sa_species.genus_id = sa_genera.genus_id
			  left join public.tbl_taxa_tree_authors sa_authors
			   on sa_species.author_id = sa_authors.author_id
			  -- // end associations
			  --common names
			  left join public.tbl_taxa_common_names cn
			   on cn.taxon_id = t.taxon_id
			  left join public.tbl_languages l
			   on cn.language_id = l.language_id
			   -- // end common names

		) As RDB
		  On RDB.taxon_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		Order By LDB.species;
End $$ Language plpgsql;
/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_taxa_other_lists
**	Who			Erik Eriksson
**	When		2013-11-21
**	What		Displays taxa data for uploaded species, together with associations and common names
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_report_taxa_other_lists(int)
-- Select * From clearing_house.fn_clearinghouse_report_taxa_other_lists(2)
create or replace function clearing_house.fn_clearinghouse_report_taxa_other_lists(int)
Returns Table (

	local_db_id int,

	species text,
	distribution_text text,
	distribution_reference text,
	biology_text text,
	biology_reference text,
	taxonomy_note_text text,
	taxonomy_note_reference text,
	identification_key_text text,
	identification_key_reference text,

	public_db_id int,

    public_species text,
	public_distribution_text text,
	public_distribution_reference text,
	public_biology_text text,
	public_biology_reference text,
	public_taxonomy_note_text text,
	public_taxonomy_note_reference text,
	public_identification_key_text text,
	public_identification_key_reference text,

    date_updated text,
	entity_type_id int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_taxa_tree_master ');

	Return Query

		Select
			LDB.local_db_id                            	As local_db_id,
			LDB.species,
			LDB.distribution_text,
			LDB.distribution_reference,
			LDB.biology_text,
			LDB.biology_reference,
			LDB.taxonomy_note_text,
			LDB.taxonomy_note_reference,
			LDB.identification_key_text,
			LDB.identification_key_reference,

  			LDB.public_db_id                            As public_db_id,

            RDB.public_species,
			RDB.public_distribution_text,
			RDB.public_distribution_reference,
			RDB.public_biology_text,
			RDB.public_biology_reference,
			RDB.public_taxonomy_note_text,
			RDB.public_taxonomy_note_reference,
			RDB.public_identification_key_text,
			RDB.public_identification_key_reference,


			to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
			entity_type_id              				As entity_type_id

		From (

			select t.submission_id,
				t.source_id,
				t.taxon_id As local_db_id,
				t.public_db_id As public_db_id,
				g.genus_name || ' ' || t.species || ' ' || coalesce(a.author_name, '')	As species,
				d.distribution_text,
				db.authors || '(' || db.year || ')' as distribution_reference,
				b.biology_text,
				bb.authors || '(' || bb.year || ')' as biology_reference,
				n.taxonomy_notes as taxonomy_note_text,
				nb.authors || '(' || nb.year || ')' as taxonomy_note_reference,
				ik.key_text as identification_key_text,
				ikb.authors || '(' || ikb.year || ')' as identification_key_reference,
				t.date_updated
			  from clearing_house.view_taxa_tree_master t
			  join clearing_house.view_taxa_tree_genera g
			   on t.genus_id = g.merged_db_id
			   and g.submission_id in (0, t.submission_id)
			  left join clearing_house.view_taxa_tree_authors a
			   on t.author_id = a.merged_db_id
			   And a.submission_id in (0, t.submission_id)
			  --distribution
			  left join clearing_house.view_text_distribution d
			   on d.taxon_id = t.merged_db_id
			   And d.submission_id in (0, t.submission_id)
			  left Join clearing_house.view_biblio db
			   On db.merged_db_id = d.biblio_id
			   And db.submission_id in (0, t.submission_id)
			  --text biology
			  left join clearing_house.view_text_biology b
			   on b.taxon_id = t.merged_db_id
			   And b.submission_id in (0, t.submission_id)
			  left join clearing_house.view_biblio bb
			   on b.biblio_id = bb.merged_db_id
			   And bb.submission_id in (0, t.submission_id)
			  --taxonomy notes
			  left join clearing_house.view_taxonomy_notes n
			   on n.taxon_id = t.merged_db_id
			   And n.submission_id in (0, t.submission_id)
			  left join clearing_house.view_biblio nb
			   on n.biblio_id = nb.merged_db_id
			   And nb.submission_id in (0, t.submission_id)
			  --identification keys
			  left join clearing_house.view_text_identification_keys ik
			   on ik.taxon_id = t.merged_db_id
			   And ik.submission_id in (0, t.submission_id)
			  left join clearing_house.view_biblio ikb
			   on ik.biblio_id = ikb.merged_db_id
			   And ikb.submission_id in (0, t.submission_id)

		) As LDB Left Join (
				select
				t.taxon_id As taxon_id,
				g.genus_name || ' ' || t.species || ' ' || coalesce(a.author_name, '')	As public_species,
				d.distribution_text as public_distribution_text,
				db.authors || '(' || db.year || ')' as public_distribution_reference,
				b.biology_text as public_biology_text,
				bb.authors || '(' || bb.year || ')' as public_biology_reference,
				n.taxonomy_notes as public_taxonomy_note_text,
				nb.authors || '(' || nb.year || ')' as public_taxonomy_note_reference,
				ik.key_text as public_identification_key_text,
				ikb.authors || '(' || ikb.year || ')' as public_identification_key_reference,
				t.date_updated
			  from public.tbl_taxa_tree_master t
			  join public.tbl_taxa_tree_genera g
			   on t.genus_id = g.genus_id
			  left join public.tbl_taxa_tree_authors a
			   on t.author_id = a.author_id
			  --distribution
			  left join public.tbl_text_distribution d
			   on d.taxon_id = t.taxon_id
			  left Join public.tbl_biblio db
			   On db.biblio_id = d.biblio_id
			  --text biology
			  left join public.tbl_text_biology b
			   on b.taxon_id = t.taxon_id
			  left join public.tbl_biblio bb
			   on b.biblio_id = bb.biblio_id
			  --taxonomy notes
			  left join public.tbl_taxonomy_notes n
			   on n.taxon_id = t.taxon_id
			  left join public.tbl_biblio nb
			   on n.biblio_id = nb.biblio_id
			  --identification keys
			  left join public.tbl_text_identification_keys ik
			   on ik.taxon_id = t.taxon_id
			  left join public.tbl_biblio ikb
			   on ik.biblio_id = ikb.biblio_id

		) As RDB
		  On RDB.taxon_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		Order By LDB.species;
End $$ Language plpgsql;
/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_taxa_seasonality
**	Who			Erik Eriksson
**	When		2013-11-21
**	What		Displays taxa seasonality data
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_report_taxa_seasonality(int)
-- Select * From clearing_house.fn_clearinghouse_report_taxa_seasonality(2)
create or replace function clearing_house.fn_clearinghouse_report_taxa_seasonality(int)
Returns Table (

	local_db_id int,

	species text,
	season_name character varying,
	season_type character varying,
	location_name character varying,
	activity_type character varying,

	public_db_id int,

	public_species text,
	public_season_name character varying,
	public_season_type character varying,
	public_location_name character varying,
	public_activity_type character varying,

	date_updated text,
	entity_type_id int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_taxa_seasonality ');

	Return Query

		Select
			LDB.local_db_id                             As local_db_id,
			LDB.species                                 As species,
			LDB.season_name                             As season_name,
			LDB.season_type                             As season_type,
			LDB.location_name                           As location_name,
			LDB.activity_type                           As activity_type,

			LDB.public_db_id                            As public_db_id,

			RDB.public_species                          As public_species,
			RDB.public_season_name                      As public_season_name,
			RDB.public_season_type                      As public_season_type,
			RDB.public_location_name                    As public_location_name,
			RDB.public_activity_type                    As public_activity_type,

			to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
            entity_type_id                                  As entity_type_id

		From (
			select t.submission_id,
			   t.source_id,
			   t.taxon_id As local_db_id,
			   t.public_db_id As public_db_id,
			   g.genus_name || ' ' || t.species || ' ' || coalesce(a.author_name, '')	As species,
			   s.season_name,
			   st.season_type,
			   l.location_name,
			   at.activity_type,
			   t.date_updated
			 from clearing_house.view_taxa_tree_master t
			 join clearing_house.view_taxa_tree_genera g
			  on t.genus_id = g.merged_db_id
			  and g.submission_id in (0, t.submission_id)
			 left join clearing_house.view_taxa_tree_authors a
			  on t.author_id = a.merged_db_id
			  And a.submission_id in (0, t.submission_id)
			left join clearing_house.view_taxa_seasonality ts
			  on ts.merged_db_id = t.taxon_id
			  and ts.submission_id in (0, t.submission_id)
			join clearing_house.view_seasons s
			  on ts.season_id = s.merged_db_id
			  and s.submission_id in (0, t.submission_id)
			join clearing_house.view_season_types st
			  on s.season_type_id = st.merged_db_id
			  and st.submission_id in (0, t.submission_id)
			join clearing_house.view_activity_types at
			  on ts.activity_type_id = at.merged_db_id
			  and at.submission_id in (0, t.submission_id)
			join clearing_house.view_locations l
			  on ts.location_id = l.merged_db_id
			  and l.submission_id in (0, t.submission_id)

		) As LDB Left Join (
            select
               t.taxon_id As taxon_id,
               g.genus_name || ' ' || t.species || ' ' || coalesce(a.author_name, '')	As public_species,
               s.season_name as public_season_name,
               st.season_type as public_season_type,
               l.location_name as public_location_name,
               at.activity_type as public_activity_type,
               t.date_updated
            from public.tbl_taxa_tree_master t
            join public.tbl_taxa_tree_genera g
              on t.genus_id = g.genus_id
             left join public.tbl_taxa_tree_authors a
              on t.author_id = a.author_id
            left join public.tbl_taxa_seasonality ts
              on ts.taxon_id = t.taxon_id
            join public.tbl_seasons s
              on ts.season_id = s.season_id
            join public.tbl_season_types st
              on s.season_type_id = st.season_type_id
            join public.tbl_activity_types at
              on ts.activity_type_id = at.activity_type_id
            join public.tbl_locations l
              on ts.location_id = l.location_id
		) As RDB
		  On RDB.taxon_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		Order By LDB.species;
End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_relative_ages
**	Who			Roger Mähler
**	When		2013-11-21
**	What		Displays relative ages data
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_report_relative_ages(int);
-- Select count(*) From clearing_house.fn_clearinghouse_report_relative_ages(2);
create or replace function clearing_house.fn_clearinghouse_report_relative_ages(int)
Returns Table (

	local_db_id int,

    sample_name					character varying,
    abbreviation				character varying,
    location_name				character varying,
    uncertainty					character varying,
    method_name					character varying,
    C14_age_older				numeric(20,5),
    C14_age_younger				numeric(20,5),
    CAL_age_older				numeric(20,5),
    CAL_age_younger				numeric(20,5),
    relative_age_name			character varying,
    notes						text,
    date_notes                  text,
    reference					text,

	public_db_id				int,

    public_sample_name			character varying,
    public_abbreviation			character varying,
    public_location_name		character varying,
    public_uncertainty 			character varying,
    public_method_name 			character varying,
    public_C14_age_older 		numeric(20,5),
    public_C14_age_younger 		numeric(20,5),
    public_CAL_age_older 		numeric(20,5),
    public_CAL_age_younger 		numeric(20,5),
    public_relative_age_name	character varying,
    public_notes 				text,
    public_date_notes           text,
    public_reference 			text,

	date_updated				text,
	entity_type_id				int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_relative_ages ');

	Return Query

		Select

			LDB.local_db_id                             			As local_db_id,

            LDB.sample_name		                                 	As sample_name,
            LDB.abbreviation		                                As abbreviation,
            LDB.location_name		                                As location_name,
            LDB.uncertainty		                                 	As uncertainty,
            LDB.method_name		                                 	As method_name,
            LDB.C14_age_older		                                As C14_age_older,
            LDB.C14_age_younger		                                As C14_age_younger,
            LDB.CAL_age_older		                                As CAL_age_older,
            LDB.CAL_age_younger		                                As CAL_age_younger,
            LDB.relative_age_name		                            As relative_age_name,
            LDB.notes		                                 		As notes,
            LDB.date_notes	                                 		As date_notes,
            LDB.reference		                                 	As reference,

			LDB.public_db_id                            			As public_db_id,

            RDB.sample_name		                                 	As public_sample_name,
            RDB.abbreviation		                                As public_abbreviation,
            RDB.location_name		                                As public_location_name,
            RDB.uncertainty		                                 	As public_uncertainty,
            RDB.method_name		                                 	As public_method_name,
            RDB.C14_age_older		                                As public_C14_age_older,
            RDB.C14_age_younger		                                As public_C14_age_younger,
            RDB.CAL_age_older		                                As public_CAL_age_older,
            RDB.CAL_age_younger		                                As public_CAL_age_younger,
            RDB.relative_age_name		                            As public_relative_age_name,
            RDB.notes		                                 		As public_notes,
            RDB.date_notes	                                 		As public_date_notes,
            RDB.reference		                                 	As public_reference,

			to_char(LDB.date_updated,'YYYY-MM-DD')					As date_updated,
            entity_type_id                             				As entity_type_id

		From (

			select  ra.submission_id								As submission_id,
                    ra.source_id									As source_id,
                    ra.relative_age_id								As local_db_id,
                    ra.public_db_id									As public_db_id,

                    ps.sample_name                                 	As sample_name,
                    ''::character varying              				As abbreviation, /* NOTE! Missing in development schema */
                    l.location_name									As location_name,
                    du.uncertainty									As uncertainty,
                    m.method_name									As method_name,
                    ra.C14_age_older								As C14_age_older,
                    ra.C14_age_younger								As C14_age_younger,
                    ra.CAL_age_older								As CAL_age_older,
                    ra.CAL_age_younger								As CAL_age_younger,
                    ra.relative_age_name							As relative_age_name,
                    ra.notes										As notes,
                    rd.notes							            As date_notes,
                    b.full_reference                        		As reference,
                    rd.date_updated									As date_updated

            From clearing_house.view_relative_dates rd
            Join clearing_house.view_relative_ages ra
              On ra.merged_db_id = rd.relative_age_id
             And ra.submission_id In (0, rd.submission_id)
            Join clearing_house.view_relative_age_types rat
              On rat.merged_db_id = ra.relative_age_type_id
             And rat.submission_id In (0, rd.submission_id)
            Left Join clearing_house.view_dating_uncertainty du
              On du.merged_db_id = rd.dating_uncertainty_id
             And du.submission_id In (0, rd.submission_id)
            /* bibliographic entries */
            Left Join clearing_house.view_relative_age_refs raf
              On raf.relative_age_id = ra.merged_db_id
             And raf.submission_id In (0, rd.submission_id)
            Left Join clearing_house.view_biblio b
              On b.merged_db_id = raf.biblio_id
             And b.submission_id In (0, raf.submission_id)
            /* Locations */
            Left Join clearing_house.view_locations l
              On l.merged_db_id = ra.location_id
             And l.submission_id In (0, rd.submission_id)
            /* Physical sample & method */
            Join clearing_house.view_analysis_entities ae
              On ae.merged_db_id = rd.analysis_entity_id
             And ae.submission_id In (0, rd.submission_id)
            Join clearing_house.view_physical_samples ps
              On ps.merged_db_id = ae.physical_sample_id
             And ps.submission_id In (0, rd.submission_id)
            Join clearing_house.view_methods m
              On m.merged_db_id = rd.method_id
             And m.submission_id In (0, rd.submission_id)

		) As LDB
        Left Join (

           Select 	ra.relative_age_id								As relative_age_id,
					ps.sample_name									As sample_name,
                    ra.abbreviation          						As abbreviation,
                    l.location_name									As location_name,
                    du.uncertainty									As uncertainty,
                    m.method_name									As method_name,
                    ra.C14_age_older								As C14_age_older,
                    ra.C14_age_younger								As C14_age_younger,
                    ra.CAL_age_older								As CAL_age_older,
                    ra.CAL_age_younger								As CAL_age_younger,
                    ra.relative_age_name							As relative_age_name,
                    ra.notes										As notes,
                    rd.notes										As date_notes,
                    b.full_reference                        		As reference
            From public.tbl_relative_dates rd
            Join public.tbl_relative_ages ra
              On ra.relative_age_id = rd.relative_age_id
            Join public.tbl_relative_age_types rat
              On rat.relative_age_type_id = ra.relative_age_type_id
            Left Join public.tbl_dating_uncertainty du
              On du.dating_uncertainty_id = rd.dating_uncertainty_id
            /* bibliographic entries 1:0-n */
            Left Join public.tbl_relative_age_refs raf
              On raf.relative_age_id = ra.relative_age_id
            Left Join public.tbl_biblio b
              On b.biblio_id = raf.biblio_id
            /* Locations: 1:0-1 */
            Left Join public.tbl_locations l
              On l.location_id = ra.location_id
            /* Physical sample & method */
            Join public.tbl_analysis_entities ae
              On ae.analysis_entity_id  = rd.analysis_entity_id
            Join public.tbl_physical_samples ps
              On ps.physical_sample_id  = ae.physical_sample_id
            Join public.tbl_methods m
              On m.method_id = rd.method_id

		) As RDB
		  On RDB.relative_age_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		Order By LDB.sample_name;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_datasets
**	Who			Roger Mähler
**	When		2013-11-21
**	What		Displays submission datasets data
**	Uses
**	Used By
**	Revisions	2014-03-18 Bug fix in LDB data
**					rt.merged_db_id = rt.record_type_id changed to rt.merged_db_id = m.record_type_id
******************************************************************************************************************************/
-- Select * From clearing_house.fn_clearinghouse_report_datasets(32)
create or replace function clearing_house.fn_clearinghouse_report_datasets(int)
Returns Table (

	local_db_id int,

    dataset_name                        character varying,
    method_name                         character varying,
    method_abbrev_or_alt_name           character varying,
    description                         text,
    record_type_name                    character varying,

	public_db_id                        int,

    public_dataset_name                 character varying,
    public_method_name                  character varying,
    public_method_abbrev_or_alt_name	character varying,
    public_description					text,
    public_record_type_name             character varying,

	date_updated                        text,
	entity_type_id                      int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_datasets ');

	Return Query

		Select

			LDB.local_db_id                             			As local_db_id,

            LDB.dataset_name		                                As dataset_name,
            LDB.method_name                                         As method_name,
            LDB.method_abbrev_or_alt_name		                    As method_abbrev_or_alt_name,
            LDB.description		                                 	As description,
            LDB.record_type_name		                            As record_type_name,

			LDB.public_db_id                            			As public_db_id,

            RDB.dataset_name		                                As public_dataset_name,
            RDB.method_name                                         As public_method_name,
            RDB.method_abbrev_or_alt_name		                    As public_method_abbrev_or_alt_name,
            RDB.description		                                 	As public_description,
            RDB.record_type_name		                            As public_record_type_name,

			to_char(LDB.date_updated,'YYYY-MM-DD')					As date_updated,
            entity_type_id                             				As entity_type_id

		From (

			Select  d.submission_id                                 As submission_id,
                    d.source_id                                     As source_id,
                    d.local_db_id									As local_db_id,
                    d.public_db_id									As public_db_id,
                    d.dataset_name                                  As dataset_name,
                    m.method_name                                   As method_name,
                    m.method_abbrev_or_alt_name                     As method_abbrev_or_alt_name,
                    m.description                                   As description,
                    rt.record_type_name                             As record_type_name,
                    d.date_updated                                 As date_updated
            From clearing_house.view_datasets d
            Left Join clearing_house.view_methods m
              On m.merged_db_id = d.method_id
             And m.submission_id In (0, d.submission_id)
            Left Join clearing_house.view_record_types rt
              On rt.merged_db_id = m.record_type_id
             And rt.submission_id In (0, d.submission_id)

		) As LDB Left Join (

            select  d.dataset_id                                    As dataset_id,
                    d.dataset_name                                  As dataset_name,
                    m.method_name                                   As method_name,
                    m.method_abbrev_or_alt_name                     As method_abbrev_or_alt_name,
                    m.description                                   As description,
                    rt.record_type_name                             As record_type_name
            from public.tbl_datasets d
            left join public.tbl_methods m
              on d.method_id = m.method_id
            left join public.tbl_record_types rt
              on m.record_type_id = rt.record_type_id
            /*
            join ( -- Unique relation dataset -> sites (om sites data ska tas med)
                select distinct d.dataset_id, s.site_id
                from public.tbl_datasets d
                left join public.tbl_analysis_entities ae
                  on ae.dataset_id = d.dataset_id
                join public.tbl_physical_samples ps
                  on ae.physical_sample_id = ps.physical_sample_id
                left join public.tbl_sample_groups sg
                  on ps.sample_group_id = sg.sample_group_id
                join public.tbl_sites s
                  on sg.site_id = s.site_id
            ) as ds
              on ds.dataset_id =  d.dataset_id
            */

		) As RDB
		  On RDB.dataset_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		Order By LDB.dataset_name;

End $$ Language plpgsql;


/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_methods
**	Who			Roger Mähler
**	When		2013-11-21
**	What		Displays submission methods data
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Select * From clearing_house.fn_clearinghouse_report_methods(2)
create or replace function clearing_house.fn_clearinghouse_report_methods(int)
Returns Table (

	local_db_id int,

    method_name                         character varying,
    method_abbrev_or_alt_name           character varying,
    description                         text,
    record_type_name                    character varying,
	group_name                    		character varying,
    group_description                   text,
    unit_name                    		character varying,

	public_db_id                        int,

    public_method_name                  character varying,
    public_method_abbrev_or_alt_name    character varying,
    public_description                  text,
    public_record_type_name             character varying,
	public_group_name                   character varying,
    public_group_description            text,
    public_unit_name                    character varying,

	date_updated                        text,
	entity_type_id                      int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_datasets ');

	Return Query

		Select

			LDB.local_db_id                             			As local_db_id,

            LDB.method_name                                         As method_name,
            LDB.method_abbrev_or_alt_name		                    As method_abbrev_or_alt_name,
            LDB.description		                                 	As description,
            LDB.record_type_name		                            As record_type_name,
            LDB.group_name		                           			As group_name,
            LDB.group_description		                            As group_description,
            LDB.unit_name		                            		As unit_name,

			LDB.public_db_id                            			As public_db_id,

            RDB.method_name                                         As method_name,
            RDB.method_abbrev_or_alt_name		                    As method_abbrev_or_alt_name,
            RDB.description		                                 	As description,
            RDB.record_type_name		                            As record_type_name,
            RDB.group_name		                           			As group_name,
            RDB.group_description		                            As group_description,
            RDB.unit_name		                            		As unit_name,

			to_char(LDB.date_updated,'YYYY-MM-DD')					As date_updated,
            entity_type_id                             				As entity_type_id

		From (

			Select  m.submission_id                                 As submission_id,
                    m.source_id                                     As source_id,
                    m.local_db_id									As local_db_id,
                    m.public_db_id									As public_db_id,
					m.method_name                                   As method_name,
					m.method_abbrev_or_alt_name                     As method_abbrev_or_alt_name,
					m.description                                   As description,
					rt.record_type_name                             As record_type_name,
					mg.group_name									As group_name,
					mg.description									As group_description,
					u.unit_name										As unit_name,
					m.date_updated									As date_updated
			From clearing_house.view_methods m
			Left Join clearing_house.view_record_types rt
			  on rt.merged_db_id = m.record_type_id
			 And rt.submission_id In (0, m.submission_id)
			Left Join clearing_house.view_method_groups mg
			  on mg.merged_db_id = m.method_group_id
			 And mg.submission_id In (0, m.submission_id)
			Left Join clearing_house.view_units u
			  On u.merged_db_id = m.unit_id
			 And u.submission_id In (0, m.submission_id)


		) As LDB Left Join (

			select  m.method_id                                    	As method_id,
					m.method_name                                   As method_name,
					m.method_abbrev_or_alt_name                     As method_abbrev_or_alt_name,
					m.description                                   As description,
					rt.record_type_name                             As record_type_name,
					mg.group_name									As group_name,
					mg.description									As group_description,
					u.unit_name										As unit_name
			from public.tbl_methods m
			left join public.tbl_record_types rt
			  on m.record_type_id = rt.record_type_id
			left join public.tbl_method_groups mg
			  on mg.method_group_id = m.method_group_id
			left join public.tbl_units u
			  on u.unit_id = m.unit_id
		) As RDB
		  On RDB.method_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		Order By LDB.method_name;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_latest_accepted_sites
**	Who			Roger Mähler
**	When		2013-12-11
**	What
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Select * From clearing_house.fn_clearinghouse_latest_accepted_sites()
create or replace function clearing_house.fn_clearinghouse_latest_accepted_sites()
Returns Table (
    last_updated_sites text
) As $$
Begin
	Return Query
		Select site
		From (
			Select Distinct s.site_name || ', ' || d.dataset_name || ', ' || m.method_name as site, d.date_updated
			From public.tbl_datasets d
			Join public.tbl_analysis_entities ae
			  On ae.dataset_id = d.dataset_id
			Join public.tbl_physical_samples ps
			  On ps.physical_sample_id = ae.physical_sample_id
			Join public.tbl_sample_groups sg
			  On sg.sample_group_id = ps.sample_group_id
			Join public.tbl_sites s
			  On s.site_id = sg.site_id
			Join public.tbl_methods m
			  On m.method_id = d.method_id
			Order By d.date_updated Desc
			Limit 10
		) as x;

End $$ Language plpgsql;
/*****************************************************************************************************************************
**	Function	fn_clearinghouse_info_references
**	Who			Roger Mähler
**	When		2013-12-11
**	What
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_info_references()
-- Select * From clearing_house.fn_clearinghouse_info_references()
create or replace function clearing_house.fn_clearinghouse_info_references()
Returns Table (
    info_reference_id int,
    info_reference_type character varying,
    display_name  character varying,
    href  character varying
) As $$
Begin
	Return Query
		Select x.info_reference_id, x.info_reference_type, x.display_name, x.href
        From clearing_house.tbl_clearinghouse_info_references x
        Order By 1;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_feature_types
**	Who			Roger Mähler
**	When		2018-03-29
**	What		Displays feature types data
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_report_feature_types(int);
-- Select * From clearing_house.fn_clearinghouse_report_feature_types(1)
create or replace function clearing_house.fn_clearinghouse_report_feature_types(int)
Returns Table (
	local_db_id                         int,
    type_name                           character varying,
    description                         text,
	public_db_id                        int,
    public_type_name                    character varying,
    public_description                  text,
	date_updated                        text,
	entity_type_id                      int
) As $$

Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_feature_types');

	Return Query

        Select
            LDB.local_db_id                       	As local_db_id,
            LDB.type_name                           As type_name,
            LDB.description		                    As description,
            LDB.public_db_id                        As public_db_id,
            RDB.type_name                           As public_type_name,
            RDB.description		                    As public_description,
            to_char(LDB.date_updated,'YYYY-MM-DD')	As date_updated,
            entity_type_id                          As entity_type_id

        From (

            Select
                ft.submission_id                    As submission_id,
                ft.source_id                        As source_id,
                ft.local_db_id					    As local_db_id,
                ft.public_db_id					    As public_db_id,
                ft.feature_type_name                As type_name,
                ft.feature_type_description		    As description,
                ft.date_updated					    As date_updated

            From clearing_house.view_feature_types ft

        ) As LDB

        Left Join (

            Select
                ft.feature_type_id                  As feature_type_id,
                ft.feature_type_name                As type_name,
                ft.feature_type_description		    As description

            From public.tbl_feature_types ft

        ) As RDB
          On RDB.feature_type_id = LDB.public_db_id

        Where LDB.source_id = 1
          And LDB.submission_id = $1
        Order By LDB.type_name;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_sample_group_dimensions
**	Who			Roger Mähler
**	When		2018-03-29
**	What		Displays sample group dimensions
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Select * From clearing_house.fn_clearinghouse_report_sample_group_dimensions(1)
create or replace function clearing_house.fn_clearinghouse_report_sample_group_dimensions(int)
Returns Table (
	local_db_id                         int,
	sample_group_id                     int,
    sample_group_name                   character varying,
    dimension_name                      character varying,
    dimension_value                     numeric(20,5),

	public_db_id                        int,
	public_sample_group_id              int,
    public_sample_group_name            character varying,
    public_dimension_name               character varying,
    public_dimension_value              numeric(20,5),

	date_updated                        text,
	entity_type_id                      int
) As $$

Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_group_dimensions');

	Return Query


        Select
            LDB.local_db_id						            As local_db_id,
            LDB.sample_group_id					           	As sample_group_id,
            LDB.sample_group_name							As sample_group_name,
            LDB.dimension_name								As dimension_name,
            LDB.dimension_value								As dimension_value,

            LDB.public_db_id						        As public_db_id,
            RDB.sample_group_id						        As public_sample_group_id,
            RDB.sample_group_name							As public_sample_group_name,
            RDB.dimension_name								As public_dimension_name,
            RDB.dimension_value								As public_dimension_value,

            to_char(LDB.date_updated,'YYYY-MM-DD')			As date_updated,
            entity_type_id						            As entity_type_id

        From (

            Select	sgd.submission_id				        As submission_id,
                    sgd.source_id					        As source_id,
                    sgd.local_db_id				            As local_db_id,
                    sgd.public_db_id				        As public_db_id,
                    sgd.sample_group_id			            As sample_group_id,
                    sgd.dimension_value			            As dimension_value,
                    sgd.date_updated				        As date_updated,
                    sg.sample_group_name			        As sample_group_name,
                    d.dimension_name				        As dimension_name

            From clearing_house.view_sample_group_dimensions sgd
            Join clearing_house.view_dimensions d
              On d.merged_db_id = sgd.dimension_id
             And d.submission_id In (0, sgd.submission_id)
            Join clearing_house.view_sample_groups sg
              On sg.merged_db_id = sgd.sample_group_id
             And sg.submission_id In (0, sgd.submission_id)

        ) As LDB

        Left Join (

            Select 	sgd.sample_group_id				        As sample_group_id,
                    sgd.dimension_value				        As dimension_value,
                    sg.sample_group_name				    As sample_group_name,
                    d.dimension_name					    As dimension_name

            From public.tbl_sample_group_dimensions as sgd
            Join public.tbl_dimensions d
              On sgd.dimension_id = d.dimension_id
            Join public.tbl_sample_groups sg
              On sg.sample_group_id = sgd.sample_group_id

        ) as RDB
          On RDB.sample_group_id = LDB.public_db_id

        Where LDB.source_id = 1
          And LDB.submission_id = $1

        Order by LDB.sample_group_id;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_sample_dimensions
**	Who			Roger Mähler
**	When		2018-03-29
**	What		Displays sample dimensions
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_report_sample_dimensions(int);
-- Select * From clearing_house.fn_clearinghouse_report_sample_dimensions(1)
create or replace function clearing_house.fn_clearinghouse_report_sample_dimensions(int)
Returns Table (
	local_db_id                         int,
	physical_sample_id                  int,
    sample_name                         character varying,
    dimension_name                      character varying,
    dimension_value                     numeric(20,5),

	public_db_id                        int,
	public_physical_sample_id           int,
    public_sample_name                  character varying,
    public_dimension_name               character varying,
    public_dimension_value              numeric(20,5),

	date_updated                        text,
	entity_type_id                      int
) As $$

Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_dimensions');

	Return Query

        Select
            LDB.local_db_id						            As local_db_id,
            LDB.physical_sample_id					        As physical_sample_id,
            LDB.sample_name							        As sample_name,
            LDB.dimension_name								As dimension_name,
            LDB.dimension_value								As dimension_value,

            LDB.public_db_id						        As public_db_id,
            RDB.physical_sample_id						    As public_physical_sample_id,
            RDB.sample_name							        As public_sample_name,
            RDB.dimension_name								As public_dimension_name,
            RDB.dimension_value								As public_dimension_value,

            to_char(LDB.date_updated,'YYYY-MM-DD')			As date_updated,
            entity_type_id						            As entity_type_id

        From (

            Select	sd.submission_id				        As submission_id,
                    sd.source_id					        As source_id,
                    sd.local_db_id				            As local_db_id,
                    sd.public_db_id				            As public_db_id,
                    ps.physical_sample_id                   As physical_sample_id,
                    ps.sample_name			                As sample_name,
                    d.dimension_name				        As dimension_name,
                    sd.dimension_value			            As dimension_value,
                    sd.date_updated				            As date_updated

            From clearing_house.view_sample_dimensions sd
            Join clearing_house.view_dimensions d
              On d.merged_db_id = sd.dimension_id
             And d.submission_id In (0, sd.submission_id)
            Join clearing_house.view_physical_samples ps
              On ps.merged_db_id = sd.physical_sample_id
             And ps.submission_id In (0, sd.submission_id)

        ) As LDB

        Left Join (

            Select 	sd.sample_dimension_id                  As sample_dimension_id,
                    ps.physical_sample_id				    As physical_sample_id,
                    ps.sample_name				            As sample_name,
                    d.dimension_name					    As dimension_name,
                    sd.dimension_value				        As dimension_value
            From public.tbl_sample_dimensions sd
            Join public.tbl_dimensions d
              On d.dimension_id = sd.dimension_id
            Join public.tbl_physical_samples ps
              On ps.physical_sample_id = sd.physical_sample_id

        ) as RDB
          On RDB.sample_dimension_id = LDB.public_db_id

        Where LDB.source_id = 1
          And LDB.submission_id = $1

        Order by LDB.physical_sample_id;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_sample_descriptions
**	Who			Roger Mähler
**	When		2018-03-29
**	What		Displays sample descriptions
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_report_sample_descriptions(int);
-- Select * From clearing_house.fn_clearinghouse_report_sample_descriptions(1)
create or replace function clearing_house.fn_clearinghouse_report_sample_descriptions(
	integer)
RETURNS TABLE(local_db_id integer, physical_sample_id integer, sample_name character varying, type_name character varying, description character varying, public_db_id integer, public_physical_sample_id integer, public_sample_name character varying, public_type_name character varying, public_description character varying, date_updated text, entity_type_id integer)
    LANGUAGE 'plpgsql'
AS $BODY$

Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_descriptions');

	Return Query

        Select
            LDB.local_db_id						            As local_db_id,
            LDB.physical_sample_id					        As physical_sample_id,
            LDB.sample_name							        As sample_name,
            LDB.type_name								    As type_name,
            LDB.description								    As description,

            LDB.public_db_id						        As public_db_id,
            RDB.physical_sample_id						    As public_physical_sample_id,
            RDB.sample_name							        As public_sample_name,
            RDB.type_name								    As public_type_name,
            RDB.description								    As public_description,

            to_char(LDB.date_updated,'YYYY-MM-DD')			As date_updated,
            entity_type_id						            As entity_type_id

        From (

            Select	sd.submission_id				        As submission_id,
                    sd.source_id					        As source_id,
                    sd.local_db_id				            As local_db_id,
                    sd.public_db_id				            As public_db_id,

                    ps.physical_sample_id                   As physical_sample_id,
                    ps.sample_name			                As sample_name,
                    sdt.type_name				            As type_name,
                    sd.description			                As description,

                    sd.date_updated				            As date_updated

            From clearing_house.view_sample_descriptions sd
            Join clearing_house.view_sample_description_types sdt
              On sdt.merged_db_id = sd.sample_description_type_id
             And sdt.submission_id In (0, sd.submission_id)
            Join clearing_house.view_physical_samples ps
              On ps.merged_db_id = sd.physical_sample_id
             And ps.submission_id In (0, sd.submission_id)

        ) As LDB

        Left Join (

            Select sd.sample_description_id                 As sample_description_id,
                   ps.physical_sample_id				    As physical_sample_id,
                   ps.sample_name				            As sample_name,
                   sdt.type_name					        As type_name,
                   sd.description				            As description
            From public.tbl_sample_descriptions sd
            Join public.tbl_sample_description_types sdt
              On sdt.sample_description_type_id = sd.sample_description_type_id
            Join public.tbl_physical_samples ps
              On ps.physical_sample_id = sd.physical_sample_id

        ) as RDB
          On RDB.sample_description_id = LDB.public_db_id

        Where LDB.source_id = 1
          And LDB.submission_id = $1

        Order by LDB.physical_sample_id;

End
$BODY$;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_report_sample_group_descriptions
**	Who			Roger Mähler
**	When		2018-03-29
**	What		Displays sample group descriptions
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/

create or replace function clearing_house.fn_clearinghouse_report_sample_group_descriptions(integer)
RETURNS TABLE(
    local_db_id integer,
    physical_sample_id integer,
    sample_name character varying,
    type_name character varying,
    description character varying,
    public_db_id integer,
    public_physical_sample_id integer,
    public_sample_name character varying,
    public_type_name character varying,
    public_description character varying,
    date_updated text,
    entity_type_id integer
)
    LANGUAGE 'plpgsql'
AS $BODY$

Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_group_descriptions');

	Return Query

        Select
            LDB.local_db_id						            As local_db_id,
            LDB.sample_group_id					            As sample_group_id,
            LDB.sample_group_name							As sample_group_name,
            LDB.type_name								    As type_name,
            LDB.group_description						    As group_description,

            LDB.public_db_id						        As public_db_id,
            RDB.sample_group_id						        As public_sample_group_id,
            RDB.sample_group_name							As public_sample_group_name,
            RDB.type_name								    As public_type_name,
            RDB.group_description							As public_group_description,

            to_char(LDB.date_updated,'YYYY-MM-DD')			As date_updated,
            entity_type_id						            As entity_type_id

        From (

            Select	sd.submission_id				        As submission_id,
                    sd.source_id					        As source_id,
                    sd.local_db_id				            As local_db_id,
                    sd.public_db_id				            As public_db_id,

                    sg.sample_group_id                      As sample_group_id,
                    sg.sample_group_name			        As sample_group_name,
                    sdt.type_name				            As type_name,
                    sd.group_description			        As group_description,

                    sd.date_updated				            As date_updated

            From clearing_house.view_sample_group_descriptions sd
            Join clearing_house.view_sample_group_description_types sdt
              On sdt.merged_db_id = sd.sample_group_description_type_id
             And sdt.submission_id In (0, sd.submission_id)
            Join clearing_house.view_sample_groups sg
              On sg.merged_db_id = sd.sample_group_id
             And sg.submission_id In (0, sd.submission_id)

        ) As LDB

        Left Join (

       		Select  sgd.sample_group_description_id     As sample_group_description_id,
                    sg.sample_group_id					As sample_group_id,
					sg.sample_group_name 				As sample_group_name,
					sgdt.type_name						As type_name,
					sgd.group_description				As group_description

			From public.tbl_sample_groups sg
			Join public.tbl_sample_group_descriptions sgd
              On sgd.sample_group_id = sg.sample_group_id
            Join public.tbl_sample_group_description_types sgdt
              On sgdt.sample_group_description_type_id = sgd.sample_group_description_type_id

        ) As RDB
		  On RDB.sample_group_description_id = LDB.public_db_id

        Where LDB.source_id = 1
          And LDB.submission_id = $1

        Order by LDB.sample_group_id;

End
$BODY$;
-- select clearing_house.chown('clearing_house', 'clearinghouse_worker');
-- commit;
