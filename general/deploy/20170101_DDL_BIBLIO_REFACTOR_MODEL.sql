-- Deploy general: 20170101_DDL_BIBLIO_REFACTOR_MODEL
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2017-01-01
  Description   Refactor bibliographic data to a less complex model.
  Prerequisites
  Issue         https://github.com/humlab-sead/sead_change_control/issues/18
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

set client_min_messages to warning;

begin;

    do $$
    begin

        begin

            if sead_utility.column_exists('public', 'tbl_biblio', 'full_reference') then
                raise exception sqlstate 'GUARD';
            end if;

            alter table public."tbl_biblio"
                add column "authors" character varying,
                add column "full_reference" text not null default(''),
                add column "url" character varying;

			/*
			SEAD: AUTHORS
			*/
			with biblio_authors as (
				select biblio_id, author as authors
				from tbl_biblio
				where TRUE
				  and coalesce(author, '') <> ''
				  and coalesce(bugs_author, '') <> ''
			) update tbl_biblio
				 set authors = y.authors
			  from biblio_authors y
			  where tbl_biblio.biblio_id = y.biblio_id;

			/*
			BUGS: AUTHORS
			*/
			with biblio_authors as (
				select biblio_id, bugs_author,
					coalesce(substring(bugs_author from '(.*) \(.*\)$'), bugs_author) as authors,
					substring(bugs_author from '.*\((.*)\)$') as "year"
				from tbl_biblio
				where TRUE
				  and coalesce(authors, '') = ''
				  and coalesce(bugs_author, '') <> ''
			) update tbl_biblio
				 set authors = y.authors,
				 	 "year" = y."year"
			  from biblio_authors y
			  where tbl_biblio.biblio_id = y.biblio_id;

			/*
			BUGS: FULL_REFERENCE
			*/

			with biblio_full_reference as (
				select biblio_id, bugs_author || coalesce('. ' || bugs_title, '') as full_reference
				from tbl_biblio
				where TRUE
				  and coalesce(authors, '') = ''
				  and coalesce(full_reference, '') <> ''
			) update tbl_biblio
				 set full_reference = y.full_reference
			  from biblio_full_reference y
			  where tbl_biblio.biblio_id = y.biblio_id;

			/*
			SEAD: FULL_REFERENCE
			MISSING
			*/



			/*
			SEAD: TITLE
			MISSING
  			*/

			/*
			BUGS: TITLE
			*/
			with biblio_titles as (
				select biblio_id, bugs_title as title
				from tbl_biblio
				where TRUE
				  and coalesce(title, '') = ''
				  and coalesce(bugs_title, '') <> ''
			) update tbl_biblio
				 set title = y.title
			  from biblio_titles y
			  where tbl_biblio.biblio_id = y.biblio_id;

            /*

            */

            alter table public."tbl_biblio"
                drop constraint if exists "fk_biblio_publisher_id",
                drop constraint if exists "fk_biblio_publication_type_id",
                drop constraint if exists "fk_biblio_collections_or_journals_id",
                drop column if exists "author",
                drop column if exists "biblio_keyword_id",
                drop column if exists "bugs_author" CASCADE,
                drop column if exists "bugs_biblio_id" CASCADE,
                drop column if exists "bugs_title",
                drop column if exists "collection_or_journal_id",
                drop column if exists "edition",
                drop column if exists "keywords",
                drop column if exists "number",
                drop column if exists "pages",
                drop column if exists "pdf_link",
                drop column if exists "publication_type_id",
                drop column if exists "publisher_id",
                drop column if exists "volume";

            if sead_utility.schema_exists('clearing_house') = TRUE then

                call sead_utility.drop_view('clearing_house.view_biblio_keywords');
                call sead_utility.drop_view('clearing_house.view_keywords');
                call sead_utility.drop_view('clearing_house.view_collections_or_journals');
                call sead_utility.drop_view('clearing_house.view_publication_types');
                call sead_utility.drop_view('clearing_house.view_publishers');

                drop table if exists clearing_house.tbl_biblio_keywords;
                drop table if exists clearing_house.tbl_keywords;
                drop table if exists clearing_house.tbl_collections_or_journals;
                drop table if exists clearing_house.tbl_publication_types;
                drop table if exists clearing_house.tbl_publishers;

            end if;

            drop table if exists public.tbl_biblio_keywords CASCADE;
            drop table if exists public.tbl_keywords CASCADE;
            drop table if exists public.tbl_publication_types CASCADE;
            drop table if exists public.tbl_publishers CASCADE;
            drop table if exists public.tbl_collections_or_journals CASCADE;

            --Select * From clearing_house.fn_create_local_union_public_entity_views('clearing_house', 'clearing_house', FALSE);
            --Select * From clearing_house.fn_dba_create_and_transfer_sead_public_db_schema();

        exception when sqlstate 'GUARD' then
            raise notice 'ALREADY EXECUTED';
        end;

    end $$ language plpgsql;

commit;
