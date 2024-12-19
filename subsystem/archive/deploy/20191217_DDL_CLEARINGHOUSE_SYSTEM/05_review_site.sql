/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_site
**	Who			Roger Mähler
**	When		2013-11-07
**	What		Returns site data used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Select * From clearing_house.tbl_sites
--Drop Function clearing_house.fn_clearinghouse_review_site(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_site(2, 27)
Create Or Replace Function clearing_house.fn_clearinghouse_review_site(int, int)
Returns Table (

	local_db_id int,
    latitude_dd numeric(18,10),
    longitude_dd numeric(18,10),
    altitude numeric(18,10),
	national_site_identifier character varying(255),
	site_name character varying(50),
	site_description text,
	preservation_status_or_threat character varying(255),
    site_location_accuracy character varying,

	public_db_id int,
	public_latitude_dd numeric(18,10),
	public_longitude_dd numeric(18,10),
	public_altitude  numeric(18,10),
	public_national_site_identifier character varying(255),
	public_site_name character varying(50),
	public_site_description text,
	public_preservation_status_or_threat character varying(255),
    public_site_location_accuracy character varying,

	entity_type_id int


) As $$

Declare
    site_entity_type_id int;

Begin

    site_entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sites');

	Return Query
		With site_data (submission_id, source_id, site_id, local_db_id, public_db_id, latitude_dd, longitude_dd, altitude, national_site_identifier, site_name, site_description, site_location_accuracy, preservation_status_or_threat) As (
			Select  s.submission_id,
					s.source_id,
					s.site_id,
					s.local_db_id,
					s.public_db_id,
					s.latitude_dd,
					s.longitude_dd,
					s.altitude,
					s.national_site_identifier,
					s.site_name,
					s.site_description,
                    s.site_location_accuracy,
					t.preservation_status_or_threat
			From clearing_house.view_sites s
			Left Join clearing_house.view_site_preservation_status t
			  On t.merged_db_id = s.site_preservation_status_id
		)
			Select

				LDB.local_db_id						As local_db_id,

				LDB.latitude_dd						As latitude_dd,
				LDB.longitude_dd					As longitude_dd,
				LDB.altitude						As altitude,
				LDB.national_site_identifier		As national_site_identifier,
				LDB.site_name						As site_name,
				LDB.site_description				As site_description,
				LDB.preservation_status_or_threat	As preservation_status_or_threat,
				LDB.site_location_accuracy	        As site_location_accuracy,

				LDB.public_db_id					As public_db_id,
				RDB.latitude_dd						As public_latitude_dd,
				RDB.longitude_dd					As public_longitude_dd,
				RDB.altitude						As public_altitude,
				RDB.national_site_identifier		As public_national_site_identifier,
				RDB.site_name						As public_site_name,
				RDB.site_description				As public_site_description,
				RDB.preservation_status_or_threat	As public_preservation_status_or_threat,
				RDB.site_location_accuracy	        As public_site_location_accuracy,

                site_entity_type_id


			From site_data LDB
			Left Join site_data RDB
			  On RDB.source_id = 2
			 And RDB.site_id = LDB.public_db_id
			Where LDB.source_id = 1
			  And LDB.submission_id = $1
			  And LDB.site_id = $2;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_site_locations
**	Who			Roger Mähler
**	When		2013-11-07
**	What		Returns site locations used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Select * From clearing_house.tbl_sites
-- Drop Function clearing_house.fn_clearinghouse_review_site_locations(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_site_locations(2, 27)
Create Or Replace Function clearing_house.fn_clearinghouse_review_site_locations(int, int)
Returns Table (

	local_db_id int,
    location_name character varying(255),
    location_type character varying(40),
	default_lat_dd numeric(18,10),
	default_long_dd numeric(18,10),

	public_db_id int,
    public_location_name character varying(255),
    public_location_type character varying(40),
	public_default_lat_dd numeric(18,10),
	public_default_long_dd numeric(18,10),

    date_updated text,

	entity_type_id int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_site_locations');

	Return Query

			Select

				LDB.site_location_id                    As local_db_id,

				LDB.location_name                       As location_name,
				LDB.location_type                       As location_type,
				LDB.default_lat_dd                  	As default_lat_dd,
				LDB.default_long_dd                 	As default_long_dd,

				LDB.public_db_id                        As public_db_id,

				RDB.location_name                   	As public_location_name,
				RDB.location_type               		As public_location_type,
				RDB.default_lat_dd              		As public_default_lat_dd,
				RDB.default_long_dd                     As public_default_long_dd,

				to_char(LDB.date_updated,'YYYY-MM-DD')	As date_updated,

				entity_type_id			As entity_type_id

			From (
				Select s.submission_id, sl.site_location_id, s.source_id, s.site_id, l.location_id, l.local_db_id, l.public_db_id, l.location_name, l.date_updated, t.location_type, l.default_lat_dd, l.default_long_dd
				From clearing_house.view_sites s
				Left Join clearing_house.view_site_locations sl
				  On sl.site_id = s.merged_db_id
				 And sl.submission_id In (0, $1)
				Left Join clearing_house.view_locations l
				  On l.merged_db_id = sl.location_id
				 And sl.submission_id In (0, $1)
				Join clearing_house.view_location_types t
				  On t.merged_db_id = l.location_type_id
				 And t.submission_id In (0, $1)
				Where 1 = 1
			) As LDB Left Join (
				Select l.location_id, l.location_name, l.date_updated, t.location_type, l.default_lat_dd, l.default_long_dd
				From public.tbl_locations l
				Join public.tbl_location_types t
				  On t.location_type_id = l.location_type_id
				Where 1 = 1
			) As RDB
			  On RDB.location_id = LDB.public_db_id
			Where LDB.source_id = 1
			  And LDB.submission_id = $1
			  And LDB.site_id = $2;

End $$ Language plpgsql;


/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_site_references
**	Who			Roger Mähler
**	When		2013-11-07
**	What		Returns site locations used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Select * From clearing_house.tbl_sites
-- Drop Function clearing_house.fn_clearinghouse_review_site_references(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_site_references(2, 27)
Create Or Replace Function clearing_house.fn_clearinghouse_review_site_references(int, int)
Returns Table (

	local_db_id int,
    reference text,

	public_db_id int,
    public_reference text,

    date_updated text,				-- display only if update

	entity_type_id int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_site_references');

	Return Query

		Select
			LDB.site_reference_id                       As local_db_id,
			LDB.full_reference                          As reference,
			LDB.public_db_id                            As public_db_id,
			RDB.full_reference                          As public_reference,
			to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
			entity_type_id              				As entity_type_id
		From (
			Select  s.source_id,
                    s.submission_id,
                    sr.site_reference_id,
                    s.site_id,
                    b.biblio_id as local_db_id,
                    b.public_db_id,
                    b.full_reference,
                    b.date_updated
			From clearing_house.view_sites s
			Join clearing_house.view_site_references sr
			  On sr.site_id = s.merged_db_id
			 And sr.submission_id In (0, $1)
			Join clearing_house.view_biblio b
			  On b.merged_db_id = sr.biblio_id
			 And b.submission_id In (0, $1)
		) As LDB Left Join (
			Select  b.biblio_id,
                    b.full_reference
			From public.tbl_biblio b
		) As RDB
		  On RDB.biblio_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		  And LDB.site_id = $2;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_site_natgridrefs
**	Who			Roger Mähler
**	When		2013-11-07
**	What		Returns site natgridrefs used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Select * From clearing_house.tbl_sites
-- Drop Function clearing_house.fn_clearinghouse_review_site_natgridrefs(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_site_natgridrefs(2, 27)
Create Or Replace Function clearing_house.fn_clearinghouse_review_site_natgridrefs(int, int)
Returns Table (

	local_db_id int,
    method_name character varying(50),
    natgridref character varying,

	public_db_id int,
    public_method_name character varying(50),
    public_natgridref character varying,				-- display only if update

	entity_type_id int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_site_natgridrefs');

	Return Query

		Select
			LDB.site_natgridref_id			As local_db_id,
			LDB.method_name					As method_name,
			LDB.natgridref					As natgridref,
			LDB.public_db_id				As public_db_id,
			RDB.method_name					As public_method_name,
			RDB.natgridref					As public_natgridref,
			entity_type_id          		As entity_type_id
		From (
			Select s.source_id, sg.site_natgridref_id, s.submission_id, s.site_id, sg.site_natgridref_id as local_db_id, sg.public_db_id, m.method_name, sg.natgridref
			From clearing_house.view_sites s
			Join clearing_house.view_site_natgridrefs sg
			  On sg.site_id = s.merged_db_id
			 And sg.submission_id In (0, $1)
			Join clearing_house.view_methods m
			  On m.merged_db_id = sg.method_id
			 And m.submission_id In (0, $1)
			Where 1 = 1
		) As LDB Left Join (
			Select sg.site_natgridref_id, m.method_name, sg.natgridref
			From public.tbl_site_natgridrefs sg
			Join public.tbl_methods m
			  On m.method_id = sg.method_id
			Where 1 = 1
		) As RDB
		  On RDB.site_natgridref_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		  And LDB.site_id = $2;

End $$ Language plpgsql;


create or replace function clearing_house.fn_clearinghouse_review_site_projects(p_submission_id integer, p_site_id integer)
  returns table(
    local_db_id integer,
    site_id integer,
    site_name character varying,
    project_name character varying,
    project_abbrev character varying,
    project_type character varying,
    description character varying,
    public_db_id integer,
    public_site_id integer,
    public_site_name character varying,
    public_project_name character varying,
    public_project_abbrev character varying,
    public_project_type character varying,
    public_description character varying,
    date_updated text,
    entity_type_id integer
) as
$body$
declare
    entity_type_id int;
begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_projects');

    return query

        select distinct
            ldb.local_db_id                                      as local_db_id,

            ldb.site_id                                          as site_id,
            ldb.site_name                                        as site_name,
            ldb.project_name                                     as project_name,
            ldb.project_abbrev                                   as project_abbrev,
            ldb.project_type::character varying                  as project_type,
            ldb.description::character varying                   as description,

            ldb.public_db_id                                     as public_db_id,

            rdb.site_id                                          as public_site_id,
            rdb.site_name                                        as public_site_name,
            rdb.project_name                                     as public_project_name,
            rdb.project_abbrev                                   as public_project_abbrev,
            ldb.project_type::character varying                  as public_project_type,
            rdb.description::character varying                   as public_description,

            to_char(ldb.date_updated,'yyyy-mm-dd')               as date_updated,
            entity_type_id                                       as entity_type_id

        from (
            select  p.source_id                                  as source_id,
                    p.submission_id                              as submission_id,
                    s.local_db_id                                as site_id,
                    p.local_db_id                                as local_db_id,
                    p.public_db_id                               as public_db_id,

                    s.site_name                                  as site_name,
                    p.project_name                               as project_name,
                    p.project_abbrev_name                        as project_abbrev,
                    p.description                                as description,
                    prs.stage_name ||', '|| pt.project_type_name as project_type,
                    p.date_updated                               as date_updated

            from clearing_house.view_projects p
            join clearing_house.view_project_types pt
              on pt.merged_db_id = p.project_type_id
             and pt.submission_id in (0, p.submission_id)
            join clearing_house.view_project_stages prs
              on prs.merged_db_id = p.project_stage_id
             and prs.submission_id in (0, p.submission_id)
            join clearing_house.view_datasets d
              on p.merged_db_id = d.project_id
             and d.submission_id in (0, p.submission_id)
            join clearing_house.view_analysis_entities ae
              on d.merged_db_id = ae.dataset_id
             and ae.submission_id in (0, p.submission_id)
            join clearing_house.view_physical_samples ps
              on ps.merged_db_id = ae.physical_sample_id
             and ps.submission_id in (0, p.submission_id)
            join clearing_house.view_sample_groups sg
              on sg.merged_db_id = ps.sample_group_id
             and sg.submission_id in (0, p.submission_id)
            join clearing_house.view_sites s
              on s.merged_db_id = sg.site_id
             and s.submission_id in (0, p.submission_id)

        ) as ldb left join (

            select
                    s.site_id                                     as site_id,
                    s.site_name                                   as site_name,
                    p.project_id                                  as project_id,
                    p.project_name                                as project_name,
                    p.project_abbrev_name                         as project_abbrev,
                    p.description                                 as description,
                    prs.stage_name ||', '|| pt.project_type_name  as project_type,
                    p.date_updated                                as date_updated


            from public.tbl_projects p
            join public.tbl_project_types pt
              on pt.project_type_id = p.project_type_id
            join public.tbl_project_stages prs
              on prs.project_stage_id = p.project_stage_id
            join public.tbl_datasets d
              on p.project_id = d.project_id
            join public.tbl_analysis_entities ae
              on d.dataset_id = ae.dataset_id
            join public.tbl_physical_samples ps
              on ps.physical_sample_id = ae.physical_sample_id
            join public.tbl_sample_groups sg
              on sg.sample_group_id = ps.sample_group_id
            join public.tbl_sites s
              on s.site_id = sg.site_id

          ) as rdb
          on rdb.project_id = ldb.public_db_id
        where ldb.source_id = 1
          and ldb.submission_id = p_submission_id
          and ldb.site_id = -p_site_id
        ;

end $body$
  language plpgsql volatile
  cost 100
  rows 1000;

alter function clearing_house.fn_clearinghouse_review_site_projects(integer, integer)
  owner to clearinghouse_worker;
