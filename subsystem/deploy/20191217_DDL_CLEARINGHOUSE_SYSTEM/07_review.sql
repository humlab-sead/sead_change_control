
-- Drop Function clearing_house.fn_clearinghouse_review_dataset_ceramic_values_client_data(int, int);
-- Select * From clearing_house.fn_clearinghouse_review_dataset_ceramic_values_client_data(1, null)
create or replace function clearing_house.fn_clearinghouse_review_dataset_ceramic_values_client_data(int, int)
Returns Table (

    local_db_id					int,
    method_id					int,
    dataset_name				character varying,
    sample_name					character varying,
    method_name					character varying,
    lookup_name				    character varying,
    measurement_value			character varying,

    public_db_id 				int,
    public_method_id			int,
    public_sample_name			character varying,
    public_method_name			character varying,
    public_lookup_name		    character varying,
    public_measurement_value	character varying,

    entity_type_id				int
) As $$
Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_ceramics');

    Return Query
        With LDB As (
            Select	d.submission_id                         As submission_id,
                    d.source_id                             As source_id,
                    d.local_db_id 			                As local_dataset_id,
                    d.dataset_name 			                As local_dataset_name,
                    ps.local_db_id 			                As local_physical_sample_id,
                    m.local_db_id 			                As local_method_id,

                    d.public_db_id 			                As public_dataset_id,
                    ps.public_db_id 			            As public_physical_sample_id,
                    m.public_db_id 			                As public_method_id,

                    c.local_db_id                           As local_db_id,
                    c.public_db_id                          As public_db_id,

                    ps.sample_name                          As sample_name,
                    m.method_name                           As method_name,
                    cl.name                                 As lookup_name,
                    c.measurement_value                     As measurement_value,

                    cl.date_updated                     	As date_updated  -- Select count(*)

            From clearing_house.view_datasets d
            Join clearing_house.view_analysis_entities ae
              On ae.dataset_id = d.merged_db_id
             And ae.submission_id In (0, d.submission_id)
            Join clearing_house.view_ceramics c
              On c.analysis_entity_id = ae.merged_db_id
             And c.submission_id In (0, d.submission_id)
            Join clearing_house.view_ceramics_lookup cl
              On cl.merged_db_id = c.ceramics_lookup_id
             And cl.submission_id In (0, d.submission_id)
            Join clearing_house.view_physical_samples ps
              On ps.merged_db_id = ae.physical_sample_id
             And ps.submission_id In (0, d.submission_id)
            Join clearing_house.view_methods m
              On m.merged_db_id = d.method_id
             And m.submission_id In (0, d.submission_id)
           Where 1 = 1
              And d.submission_id = $1 -- perf
              And d.local_db_id = Coalesce(-$2, d.local_db_id) -- perf
        ), RDB As (
            Select	d.dataset_id 			                As dataset_id,
                    ps.physical_sample_id                   As physical_sample_id,
                    m.method_id                             As method_id,
                    c.ceramics_id                           As ceramics_id,
                    ps.sample_name                          As sample_name,
                    m.method_name                           As method_name,
                    cl.name                                 As lookup_name,
                    c.measurement_value                     As measurement_value
            From public.tbl_datasets d
            Join public.tbl_analysis_entities ae
              On ae.dataset_id = d.dataset_id
            Join public.tbl_ceramics c
              On c.analysis_entity_id = ae.analysis_entity_id
            Join public.tbl_ceramics_lookup cl
              On cl.ceramics_lookup_id = c.ceramics_lookup_id
            Join public.tbl_physical_samples ps
              On ps.physical_sample_id = ae.physical_sample_id
            Join public.tbl_methods m
              On m.method_id = d.method_id
            -- Where ae.dataset_id = public_ds_id -- perf
        )
            Select
                -- LDB.local_dataset_id 			                As dataset_id,
                -- LDB.local_physical_sample_id 			        As physical_sample_id,
                LDB.local_db_id                                 As local_db_id,
                LDB.local_method_id 			                As method_id,
                LDB.local_dataset_name							As dataset_name,
                LDB.sample_name									As sample_name,
                LDB.method_name									As method_name,
                LDB.lookup_name									As lookup_name,
                LDB.measurement_value							As measurement_value,

                -- LDB.public_dataset_id 			                As public_dataset_id,
                -- LDB.public_physical_sample_id 			        As public_physical_sample_id,
                LDB.public_db_id 			                    As public_db_id,
                LDB.public_method_id 			                As public_method_id,
                RDB.sample_name									As public_sample_name,
                RDB.method_name									As public_method_name,
                RDB.lookup_name									As public_lookup_name,
                RDB.measurement_value							As public_measurement_value,

                entity_type_id									As entity_type_id
            From LDB
            Left Join RDB
              On 1 = 1
             And RDB.ceramics_id = LDB.public_db_id
             --And RDB.dataset_id = LDB.public_dataset_id
             --And RDB.physical_sample_id = LDB.public_physical_sample_id
             --And RDB.method_id = LDB.public_method_id

            Where LDB.source_id = 1
              And LDB.submission_id = $1
              And LDB.local_dataset_id = Coalesce(-$2, LDB.local_dataset_id)
            Order by LDB.local_physical_sample_id;

End $$ Language plpgsql;


-- Drop Function clearing_house.fn_clearinghouse_review_ceramic_values_crosstab(p_submission_id int)
-- select * from clearing_house.fn_clearinghouse_review_ceramic_values_crosstab(1)
create or replace function clearing_house.fn_clearinghouse_review_ceramic_values_crosstab(p_submission_id int)
returns table (
    sample_name text,
    local_db_id int,
    public_db_id int,
    entity_type_id int,
    json_data_values json)
as $$
    declare
        v_category_sql text;
        v_source_sql text;
        v_typed_fields text;
        v_field_names text;
        v_column_names text;
        v_sql text;
begin
    v_category_sql = '
        select distinct name
        from clearing_house.view_ceramics_lookup
        order by name
    ';
    v_source_sql = format('
        select	sample_name,                                            -- row_name
                local_db_id, public_db_id, entity_type_id,              -- extra_columns
                lookup_name,                                            -- category
                ARRAY[lookup_name, ''text'', max(measurement_value), max(public_measurement_value)] as measurement_value
        from clearing_house.fn_clearinghouse_review_dataset_ceramic_values_client_data(%s, null) c
        where true
        group by sample_name, local_db_id, public_db_id, entity_type_id, lookup_name
        order by sample_name, lookup_name
    ', p_submission_id);

    select string_agg(format('%I text[]', name), ', ' order by name) as typed_fields,
           string_agg(format('ARRAY[%L, ''local'', ''public'']', name), ', ' order by name) AS column_names
    into v_typed_fields, v_field_names, v_column_names
    from clearing_house.view_ceramics_lookup;

    if v_column_names is null then

        return query
            select *
            from (values (null::text, null::int, null::int, null::int, null::json)) as v
            where false;

    else

        select format('
            select sample_name, local_db_id, public_db_id, entity_type_id, array_to_json(ARRAY[%s]) AS json_data_values
            from crosstab(%L, %L) AS ct(sample_name text, local_db_id int, public_db_id int, entity_type_id int, %s)',
                      v_column_names, v_source_sql, v_category_sql, v_typed_fields)
        into v_sql;

        return query execute v_sql;

    end if;

end
$$ language 'plpgsql';

/*****************************************************************************************************************************
**  Function    fn_clearinghouse_review_dataset_client_data
**	Who			Roger Mähler
**	When		2013-11-14
**	What		Returns dataset data used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_dataset_client_data(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_dataset_client_data(2, 100)
create or replace function clearing_house.fn_clearinghouse_review_dataset_client_data(int, int)
Returns Table (

	local_db_id                     int,
	dataset_name                    character varying,
	data_type_name                  character varying,
	master_name                     character varying,
	previous_dataset_name           character varying,
	method_name                     character varying,
    project_name                    character varying,
    project_stage_name              text,
	record_type_id                  int,

	public_db_id                    int,
	public_dataset_name             character varying,
	public_data_type_name           character varying,
	public_master_name              character varying,
	public_previous_dataset_name    character varying,
	public_method_name              character varying,
	public_project_name             character varying,
	public_project_stage_name       text,
	public_record_type_id           int,

	entity_type_id                  int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_datasets');

	Return Query

		With sample (submission_id, source_id, local_db_id, public_db_id, merged_db_id, dataset_name, data_type_name, master_name, previous_dataset_name, method_name, project_name, project_stage_name, record_type_id) As (
            Select  d.submission_id                                         As submission_id,
                    d.source_id                                             As source_id,
                    d.local_db_id                                           As local_db_id,
                    d.public_db_id                                          As public_db_id,
                    d.merged_db_id                                          As merged_db_id,
                    d.dataset_name                                          As dataset_name,
                    dt.data_type_name                                       As data_type_name,
                    dm.master_name                                          As master_name,
                    ud.dataset_name                                         As previous_dataset_name,
                    m.method_name                                           As method_name,
                    p.project_name                                          As project_name,
                    format('%s, %s', pt.project_type_name, ps.stage_name)   As project_stage_name,
                    m.record_type_id                                        As record_type_id
                    /* Används för att skilja proxy types: 1) measured value 2) abundance */
            From clearing_house.view_datasets d
            Join clearing_house.view_data_types dt
              On dt.data_type_id = d.data_type_id
             And dt.submission_id In (0, d.submission_id)
            Left Join clearing_house.view_dataset_masters dm
              On dm.merged_db_id = d.master_set_id
             And dm.submission_id In (0, d.submission_id)
            Left Join clearing_house.view_datasets ud
              On ud.merged_db_id = d.updated_dataset_id
             And ud.submission_id In (0, d.submission_id)
            Join clearing_house.view_methods m
              On m.merged_db_id = d.method_id
             And m.submission_id In (0, d.submission_id)
            Left Join clearing_house.view_projects p
              On p.merged_db_id = d.project_id
             And p.submission_id In (0, d.submission_id)
            Left Join clearing_house.view_project_types pt
              On pt.merged_db_id = p.project_type_id
             And pt.submission_id In (0, d.submission_id)
            Left Join clearing_house.view_project_stages ps
              On ps.merged_db_id = p.project_stage_id
             And ps.submission_id In (0, d.submission_id)
		)
			Select
				LDB.local_db_id						As local_db_id,
				LDB.dataset_name                    As dataset_name,
				LDB.data_type_name                  As data_type_name,
				LDB.master_name                     As master_name,
				LDB.previous_dataset_name           As previous_dataset_name,
				LDB.method_name                     As method_name,
				LDB.project_name                    As project_name,
				LDB.project_stage_name              As project_stage_name,
				LDB.record_type_id                  As record_type_id,

				LDB.public_db_id					As public_db_id,
				RDB.dataset_name                    As public_dataset_name,
				RDB.data_type_name                  As public_data_type_name,
				RDB.master_name                     As public_master_name,
				RDB.previous_dataset_name           As public_previous_dataset_name,
				RDB.method_name                     As public_method_name,
				RDB.project_name                    As public_project_name,
				RDB.project_stage_name              As public_project_stage_name,
				RDB.record_type_id                  As public_record_type_id,

                entity_type_id

			From sample LDB
			Left Join sample RDB
			  On RDB.source_id = 2
			 And RDB.public_db_id = LDB.public_db_id
			Where LDB.source_id = 1
			  And LDB.submission_id = $1
			  And LDB.local_db_id = -$2
			  ;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_dataset_contacts_client_data
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns dataset contacts review data used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_dataset_contacts_client_data(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_dataset_contacts_client_data(2, -40)
create or replace function clearing_house.fn_clearinghouse_review_dataset_contacts_client_data(int, int)
Returns Table (

	local_db_id					int,

    full_name					text,
    contact_type_name			character varying,

	public_db_id 				int,

    public_full_name			text,
    public_contact_type_name	character varying,

    date_updated				text,
	entity_type_id				int

) As $$
Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_dataset_contacts');

	Return Query

		Select
			LDB.local_db_id				               					As local_db_id,

			format('%s %s', LDB.first_name, LDB.last_name)				As full_name,
			LDB.contact_type_name										As contact_type_name,

			LDB.public_db_id				            				As public_db_id,

			format('%s %s', RDB.first_name, RDB.last_name)				As public_full_name,
			RDB.contact_type_name										As public_contact_type_name,

			to_char(LDB.date_updated,'YYYY-MM-DD')						As date_updated,
			entity_type_id												As entity_type_id

		From (
			Select	d.source_id                                         As source_id,
					d.submission_id                                     As submission_id,
					d.local_db_id										As dataset_id,

					dc.local_db_id										As local_db_id,
					dc.public_db_id										As public_db_id,
					dc.merged_db_id										As merged_db_id,

					c.first_name										As first_name,
					c.last_name											As last_name,
					t.contact_type_name									As contact_type_name,

					dc.date_updated										As date_updated
			From clearing_house.view_datasets d
			Join clearing_house.view_dataset_contacts dc
			  On dc.dataset_id = d.merged_db_id
			 And dc.submission_id In (0, d.submission_id)
			Join clearing_house.view_contacts c
			  On c.merged_db_id = dc.contact_id
			 And c.submission_id In (0, d.submission_id)
			Join clearing_house.view_contact_types t
			  On t.merged_db_id = dc.contact_type_id
			 And t.submission_id In (0, d.submission_id)

		) As LDB Left Join (

			Select	d.dataset_id										As dataset_id,

					dc.contact_id										As contact_id,

					c.first_name										As first_name,
					c.last_name											As last_name,
					t.contact_type_name									As contact_type_name

			From public.tbl_datasets d
			Join public.tbl_dataset_contacts dc
			  On dc.dataset_id = d.dataset_id
			Join public.tbl_contacts c
			  On c.contact_id = dc.contact_id
			Join public.tbl_contact_types t
			  On t.contact_type_id = dc.contact_type_id

		  ) As RDB
		  On
		  RDB.contact_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		  And LDB.dataset_id = -$2
		;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_dataset_submissions_client_data
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns dataset submissions review data used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_dataset_submissions_client_data(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_dataset_submissions_client_data(2, -40)
create or replace function clearing_house.fn_clearinghouse_review_dataset_submissions_client_data(int, int)
Returns Table (

	local_db_id					int,

    full_name					text,
    submission_type				character varying,
    notes						text,
    date_submitted				text,

	public_db_id 				int,

    public_full_name     		text,
    public_submission_type		character varying,
    public_notes				text,
    public_date_submitted		text,

    date_updated				text,
	entity_type_id				int

) As $$
Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_dataset_submissions');

	Return Query

		Select

			LDB.local_db_id				               					As local_db_id,

			format('%s %s', LDB.first_name, LDB.last_name)				As last_name,
			LDB.submission_type											As submission_type,
			LDB.notes													As notes,
			to_char(LDB.date_submitted,'YYYY-MM-DD')					As date_submitted,

			LDB.public_db_id				            				As public_db_id,

			format('%s %s', RDB.first_name, RDB.last_name)				As public_full_name,
			RDB.submission_type											As public_submission_type,
			RDB.notes													As public_notes,
			to_char(RDB.date_submitted,'YYYY-MM-DD')					As public_date_submitted,

			to_char(LDB.date_updated,'YYYY-MM-DD')						As date_updated,

			entity_type_id												As entity_type_id

		From (

			Select	d.source_id                                         As source_id,
					d.submission_id                                     As submission_id,
					d.local_db_id										As dataset_id,
					d.public_db_id										As public_dataset_id,

					ds.local_db_id										As local_db_id,
					ds.public_db_id										As public_db_id,
					ds.merged_db_id										As merged_db_id,

					c.first_name										As first_name,
					c.last_name											As last_name,
					dst.submission_type									As submission_type,
					ds.notes											As notes,
					ds.date_submitted									As date_submitted,

					ds.date_updated

			From clearing_house.view_datasets d
			Join clearing_house.view_dataset_submissions ds
			  On ds.dataset_id = d.merged_db_id
			 And ds.submission_id In (0, d.submission_id)
			Join clearing_house.view_contacts c
			  On c.merged_db_id = ds.contact_id
			 And c.submission_id In (0, d.submission_id)
			Join clearing_house.view_dataset_submission_types dst
			  On dst.merged_db_id = ds.submission_type_id
			 And dst.submission_id In (0, d.submission_id)

		) As LDB Left Join (

			Select	d.dataset_id										As dataset_id,

					ds.dataset_submission_id							As dataset_submission_id,

					c.first_name										As first_name,
					c.last_name											As last_name,
					dst.submission_type									As submission_type,
					ds.notes											As notes,
					ds.date_submitted									As date_submitted,

					ds.date_updated

			From public.tbl_datasets d
			Join public.tbl_dataset_submissions ds
			  On ds.dataset_id = d.dataset_id
			Join public.tbl_contacts c
			  On c.contact_id = ds.contact_id
			Join public.tbl_dataset_submission_types dst
			  On dst.submission_type_id = ds.submission_type_id

		  ) As RDB
		  On RDB.dataset_submission_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		  And LDB.dataset_id = -$2;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**  View        view_clearinghouse_dataset_measured_values
**	Who			Roger Mähler
**	When		2013-11-14
**	What
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop View clearing_house.view_clearinghouse_dataset_measured_values
Create Or Replace View clearing_house.view_clearinghouse_dataset_measured_values As

    Select d.submission_id              as submission_id,
           d.source_id                  as source_id,
           d.local_db_id                as local_dataset_id,
           d.merged_db_id               as merged_dataset_id,
           d.public_db_id               as public_dataset_id,
           ps.sample_group_id           as sample_group_id,
           ps.merged_db_id              as physical_sample_id,
           ps.local_db_id              	as local_physical_sample_id,
           ps.public_db_id              as public_physical_sample_id,
           ps.sample_name               as sample_name,
           m.method_id                  as method_id,
           m.public_db_id               as public_method_id,
           m.method_name                as method_name,
           aepmm.method_id              as prep_method_id,
           aepmm.public_db_id           as public_prep_method_id,
           aepmm.method_name            as prep_method_name,
           mv.measured_value            as measured_value
    From clearing_house.view_datasets d
    Join clearing_house.view_analysis_entities ae
      On ae.dataset_id = d.merged_db_id
     And ae.submission_id In (0, d.submission_id)
    Join clearing_house.view_measured_values mv
      On mv.analysis_entity_id = ae.merged_db_id
     And mv.submission_id In (0, d.submission_id)
    Join clearing_house.view_physical_samples ps
      On ps.merged_db_id = ae.physical_sample_id
     And ps.submission_id In (0, d.submission_id)
    Join clearing_house.view_methods m
      On m.merged_db_id = d.method_id
     And m.submission_id In (0, d.submission_id)
    Left Join clearing_house.view_measured_value_dimensions mvd
      On mvd.measured_value_id = mv.merged_db_id
     And mvd.submission_id In (0, d.submission_id)
    Left Join clearing_house.view_dimensions dd
      On dd.merged_db_id = mvd.dimension_id
     And dd.submission_id In (0, d.submission_id)
    Left Join clearing_house.view_analysis_entity_prep_methods aepm
      On aepm.analysis_entity_id = ae.merged_db_id
     And aepm.submission_id In (0, d.submission_id)
    Left Join clearing_house.view_methods aepmm
      On aepmm.merged_db_id = aepm.method_id
     And aepmm.submission_id In (0, d.submission_id)
;

/*****************************************************************************************************************************
**  View        view_dataset_measured_values
**	Who			Roger Mähler
**	When		2013-11-14
**	What
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop View clearing_house.view_dataset_measured_values
-- Select * From clearing_house.view_dataset_measured_values
Create Or Replace View clearing_house.view_dataset_measured_values As

    Select d.dataset_id                 as dataset_id,
           ps.physical_sample_id        as physical_sample_id,
           ps.sample_group_id           as sample_group_id,
           ps.sample_name               as sample_name,
           m.method_id                  as method_id,
           m.method_name                as method_name,
           aepmm.method_id              as prep_method_id,
           aepmm.method_name            as prep_method_name,
           mv.measured_value            as measured_value
    From public.tbl_datasets d
    Join public.tbl_analysis_entities ae
      On ae.dataset_id = d.dataset_id
    Join public.tbl_measured_values mv
      On mv.analysis_entity_id = ae.analysis_entity_id
    Join public.tbl_physical_samples ps
      On ps.physical_sample_id = ae.physical_sample_id
    Join public.tbl_methods m
      On m.method_id = d.method_id
    Left Join public.tbl_measured_value_dimensions mvd
      On mvd.measured_value_id = mv.measured_value_id
    Left Join public.tbl_dimensions dd
      On dd.dimension_id = mvd.dimension_id
    Left Join public.tbl_analysis_entity_prep_methods aepm
      On aepm.analysis_entity_id = ae.analysis_entity_id
    Left Join public.tbl_methods aepmm
      On aepmm.method_id = aepm.method_id
;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_dataset_measured_values_client_data
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns dataset measured value review data used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_dataset_measured_values_client_data(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_dataset_measured_values_client_data(2, 140)
create or replace function clearing_house.fn_clearinghouse_review_dataset_measured_values_client_data(int, int)
Returns Table (

	local_db_id					int,
	public_db_id 				int,

    sample_name					character varying,

    method_id					int,
    method_name					character varying,
    prep_method_id				int,
    prep_method_name			character varying,

    measured_value				numeric(20,10),
    public_measured_value		numeric(20,10),

	entity_type_id				int

) As $$
Declare
    entity_type_id int;
    public_ds_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_physical_samples');

	Select x.public_db_id Into public_ds_id
	From clearing_house.view_datasets x
	Where x.local_db_id = -$2;

	Return Query

		Select

			LDB.physical_sample_id				               			As local_db_id,
			RDB.physical_sample_id				               			As public_db_id,

			LDB.sample_name												As sample_name,

			LDB.method_id												As method_id,
			LDB.method_name												As method_name,
			LDB.prep_method_id											As prep_method_id,
			LDB.prep_method_name										As prep_method_name,

			LDB.measured_value											As measured_value,

			RDB.measured_value											As public_measured_value,

			entity_type_id												As entity_type_id

		From clearing_house.view_clearinghouse_dataset_measured_values LDB
		Left Join clearing_house.view_dataset_measured_values RDB
		  On RDB.dataset_id = public_ds_id
		 And RDB.physical_sample_id = LDB.public_physical_sample_id
		 And RDB.method_id = LDB.public_method_id
		 And RDB.prep_method_id = LDB.public_prep_method_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		  And LDB.local_dataset_id = -$2;

End $$ Language plpgsql;
 /*****************************************************************************************************************************
**  View        view_dataset_abundance_modification_types
**	Who			Roger Mähler
**	When		2013-12-09
**	What
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop View clearing_house.view_dataset_abundance_modification_types

Create Or Replace View clearing_house.view_dataset_abundance_modification_types As

     select	am.abundance_id														as abundance_id,
			array_to_string(array_agg(mt.modification_type_description), ',')	as modification_type_description,
			array_to_string(array_agg(mt.modification_type_name), ',')			as modification_type_name
	from public.tbl_abundance_modifications am
	left join public.tbl_modification_types mt
	  on mt.modification_type_id = am.modification_type_id
	group by am.abundance_id

	;

/*****************************************************************************************************************************
**  View        view_dataset_abundance_ident_levels
**	Who			Roger Mähler
**	When		2013-12-09
**	What
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop View clearing_house.view_dataset_abundances

Create Or Replace View clearing_house.view_dataset_abundance_ident_levels As

     select	al.abundance_id														as abundance_id,
			array_to_string(array_agg(l.identification_level_abbrev), ',')		as identification_level_abbrev,
			array_to_string(array_agg(l.identification_level_name), ',')		as identification_level_name
	from public.tbl_abundance_ident_levels al
	left join public.tbl_identification_levels l
	  on l.identification_level_id = al.identification_level_id
	group by al.abundance_id

	;

/*****************************************************************************************************************************
**  View        view_dataset_abundance_element_names
**	Who			Roger Mähler
**	When		2013-12-09
**	What
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop View clearing_house.view_dataset_abundance_element_names

Create Or Replace View clearing_house.view_dataset_abundance_element_names As

    select	a.abundance_id										as abundance_id,
			array_to_string(array_agg(ael.element_name), ',')	as element_name
	from public.tbl_abundances a
	join public.tbl_abundance_elements ael
	  on ael.abundance_element_id = a.abundance_element_id
	group by a.abundance_id

	;

/*****************************************************************************************************************************
**  View        view_dataset_abundances
**	Who			Roger Mähler
**	When		2013-12-09
**	What
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop View clearing_house.view_dataset_abundances
-- Select * From clearing_house.view_dataset_abundances
Create Or Replace View clearing_house.view_dataset_abundances As

     select	d.dataset_id								as dataset_id,

            ttm.taxon_id                                as taxon_id,
			ttg.genus_name								as genus_name,
			ttm.species									as species,

			ps.physical_sample_id						as physical_sample_id,
			ps.sample_name              				as sample_name,

            a.abundance_id                              as abundance_id,
			a.abundance									as abundance,

			Coalesce(ael.element_name, '')				as element_name,
			Coalesce(mt.modification_type_name, '')		as modification_type_name,
			Coalesce(il.identification_level_name, '')	as identification_level_name

	from public.tbl_datasets d
	left join public.tbl_analysis_entities ae
	  on d.dataset_id= ae.dataset_id
	left join public.tbl_physical_samples ps
	  on  ae.physical_sample_id = ps.physical_sample_id
	left join public.tbl_abundances a
	  on a.analysis_entity_id = ae.analysis_entity_id
	left join public.tbl_taxa_tree_master ttm
	  on ttm.taxon_id = a.taxon_id
	left join public.tbl_taxa_tree_genera ttg
	  on ttg.genus_id =  ttm.genus_id
	left join clearing_house.view_dataset_abundance_modification_types mt
	  on mt.abundance_id = a.abundance_id
	left join clearing_house.view_dataset_abundance_ident_levels il
	  on il.abundance_id = a.abundance_id
	left join clearing_house.view_dataset_abundance_element_names ael
	  on ael.abundance_id = a.abundance_id
	where 1 = 1
	;


/*****************************************************************************************************************************
**  View        view_clearinghouse_dataset_abundance_modification_types
**	Who			Roger Mähler
**	When		2013-12-09
**	What
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop View clearing_house.view_clearinghouse_dataset_abundance_modification_types

Create Or Replace View clearing_house.view_clearinghouse_dataset_abundance_modification_types As

     select	am.submission_id                                                    as submission_id,
            am.abundance_id														as abundance_id,
            am.merged_db_id														as merged_db_id,
            am.public_db_id														as public_db_id,
            am.local_db_id														as local_db_id,
			array_to_string(array_agg(mt.modification_type_description), ',')	as modification_type_description,
			array_to_string(array_agg(mt.modification_type_name), ',')			as modification_type_name
	from clearing_house.view_abundance_modifications am
	left join clearing_house.view_modification_types mt
	  on mt.merged_db_id = am.modification_type_id
	 and mt.submission_id In (0, am.submission_id)
	group by am.submission_id, am.abundance_id, am.merged_db_id, am.public_db_id, am.local_db_id

	;

/*****************************************************************************************************************************
**  View        view_clearinghouse_dataset_abundance_ident_levels
**	Who			Roger Mähler
**	When		2013-12-09
**	What
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop View clearing_house.view_clearinghouse_dataset_abundance_ident_levels

Create Or Replace View clearing_house.view_clearinghouse_dataset_abundance_ident_levels As

     select	al.submission_id                                                    as submission_id,
            al.abundance_id														as abundance_id,
            al.merged_db_id														as merged_db_id,
            al.public_db_id														as public_db_id,
            al.local_db_id														as local_db_id,
			array_to_string(array_agg(l.identification_level_abbrev), ',')		as identification_level_abbrev,
			array_to_string(array_agg(l.identification_level_name), ',')		as identification_level_name
	from clearing_house.view_abundance_ident_levels al
	left join clearing_house.view_identification_levels l
	  on l.identification_level_id = al.identification_level_id
	group by al.submission_id, al.abundance_id, al.merged_db_id, al.public_db_id, al.local_db_id

	;

/*****************************************************************************************************************************
**  View        view_clearinghouse_dataset_abundance_element_names
**	Who			Roger Mähler
**	When		2013-12-09
**	What
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop View clearing_house.view_clearinghouse_dataset_abundance_element_names

Create Or Replace View clearing_house.view_clearinghouse_dataset_abundance_element_names As

    select  a.submission_id                                     as submission_id,
            a.abundance_id										as abundance_id,
            a.merged_db_id										as merged_db_id,
            a.public_db_id										as public_db_id,
            a.local_db_id										as local_db_id,
			array_to_string(array_agg(ael.element_name), ',')	as element_name
	from clearing_house.view_abundances a
	join clearing_house.view_abundance_elements ael
	  on ael.abundance_element_id = a.abundance_element_id
	group by a.submission_id, a.abundance_id, a.merged_db_id, a.public_db_id, a.local_db_id

;

/*****************************************************************************************************************************
**  View        view_clearinghouse_dataset_abundances
**	Who			Roger Mähler
**	When		2013-12-09
**	What
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop View clearing_house.view_clearinghouse_dataset_abundances
-- Select * From clearing_house.view_clearinghouse_dataset_abundances
Create Or Replace View clearing_house.view_clearinghouse_dataset_abundances As

     select	d.submission_id								as submission_id,
			d.source_id 								as source_id,
			d.local_db_id								as local_dataset_id,
			d.public_db_id								as public_dataset_id,

			a.abundance_id								as abundance_id,
			a.local_db_id								as local_db_id,
			a.public_db_id								as public_db_id,
			a.abundance									as abundance,

			ttm.taxon_id								as taxon_id,
			ttm.public_db_id							as public_taxon_id,
			ttg.genus_name								as genus_name,
			ttm.species									as species,
			tta.author_name								as author_name,

			ps.physical_sample_id						as physical_sample_id,
			ps.public_db_id								as public_physical_sample_id,
			ps.sample_name              				as sample_name,

			Coalesce(ael.element_name, '')				as element_name,
			Coalesce(mt.modification_type_name, '')		as modification_type_name,
			Coalesce(il.identification_level_name, '')	as identification_level_name

	from clearing_house.view_datasets d
	join clearing_house.view_analysis_entities ae
	  on ae.dataset_id = d.merged_db_id
     and ae.submission_id in (0, d.submission_id)
	join clearing_house.view_physical_samples ps
	  on ps.merged_db_id = ae.physical_sample_id
     and ps.submission_id in (0, d.submission_id)
	join clearing_house.view_abundances a
	  on a.analysis_entity_id = ae.merged_db_id
     and a.submission_id in (0, d.submission_id)
	left join clearing_house.view_taxa_tree_master ttm
	  on ttm.merged_db_id = a.taxon_id
     and ttm.submission_id in (0, d.submission_id)
	left join clearing_house.view_taxa_tree_genera ttg
	  on ttg.merged_db_id =  ttm.genus_id
     and ttg.submission_id in (0, d.submission_id)
	left join clearing_house.view_taxa_tree_authors tta
	  on tta.merged_db_id =  ttm.author_id
     and tta.submission_id in (0, d.submission_id)
	left join clearing_house.view_clearinghouse_dataset_abundance_modification_types mt
	  on mt.abundance_id = a.merged_db_id
     and mt.submission_id in (0, d.submission_id)
	left join clearing_house.view_clearinghouse_dataset_abundance_ident_levels il
	  on il.abundance_id = a.merged_db_id
     and il.submission_id in (0, d.submission_id)
	left join clearing_house.view_clearinghouse_dataset_abundance_element_names ael
	  on ael.abundance_id = a.merged_db_id
     and ael.submission_id in (0, d.submission_id)
	where 1 = 1
	;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_dataset_abundance_values_client_data
**	Who			Roger Mähler
**	When		2013-12-09
**	What		Returns dataset abundance values review data used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_dataset_abundance_values_client_data(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_dataset_abundance_values_client_data(2, 140)
create or replace function clearing_house.fn_clearinghouse_review_dataset_abundance_values_client_data(int, int)
Returns Table (

	local_db_id					int,
	public_db_id 				int,

	abundance_id 				int,
	physical_sample_id 			int,
	taxon_id 					int,

    genus_name					character varying,
    species						character varying,
    sample_name					character varying,
    author_name					character varying,

    element_name				text,
    modification_type_name		text,
    identification_level_name	text,

    abundance					int,
    public_abundance			int,

	entity_type_id				int

) As $$
Declare
    entity_type_id int;
    public_ds_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_abundances');

	Select x.public_db_id Into public_ds_id
	From clearing_house.view_datasets x
	Where x.local_db_id = -$2;

	Return Query

		Select

			LDB.local_db_id						               			As local_db_id,
			LDB.public_db_id						               		As public_db_id,

			LDB.abundance_id					               			As abundance_id,
			LDB.physical_sample_id				               			As physical_sample_id,
			LDB.taxon_id						               			As taxon_id,

			LDB.genus_name												As genus_name,
			LDB.species													As species,
			LDB.sample_name												As sample_name,
			LDB.author_name												As author_name,
			LDB.element_name											As element_name,
			LDB.modification_type_name									As modification_type_name,
			LDB.identification_level_name								As identification_level_name,

			LDB.abundance												As abundance,

			RDB.abundance												As public_abundance,

			entity_type_id												As entity_type_id
		-- Select LDB.*
		From clearing_house.view_clearinghouse_dataset_abundances LDB

		Left Join clearing_house.view_dataset_abundances RDB
		  On RDB.dataset_id =  LDB.public_dataset_id
		 And RDB.taxon_id = LDB.public_taxon_id
		 And RDB.abundance_id = LDB.public_db_id
		 And RDB.physical_sample_id = LDB.public_physical_sample_id

		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		  And LDB.local_dataset_id = -$2;

End $$ Language plpgsql;


create or replace function clearing_house.fn_clearinghouse_review_dataset_references_client_data(
    IN integer,
    IN integer)
RETURNS TABLE(
      local_db_id integer,
      full_reference text,
      public_db_id integer,
      public_reference text,
      date_updated text,
      entity_type_id integer
) AS
$BODY$
Declare
    entity_type_id int;
Begin
    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_datasets');
	Return Query
        Select
                LDB.dataset_id                       		As local_db_id,
                LDB.reference                           	As reference,
                LDB.public_db_id                        	As public_db_id,
                RDB.reference                           	As public_reference,
                to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
                entity_type_id              			As entity_type_id
            From (
                Select
                    d.source_id				    As source_id,
                    d.submission_id				As submission_id,
                    d.dataset_id				As dataset_id,
                    b.biblio_id 				As local_db_id,
                    b.public_db_id				As public_db_id,
                    b.full_reference		 	As reference,
                    b.date_updated				As date_updated
                From clearing_house.view_datasets d
                Join clearing_house.view_biblio b
                  On b.merged_db_id = d.biblio_id
                 And b.submission_id In (0, d.submission_id)
            ) As LDB Left Join (
                Select b.biblio_id				As biblio_id,
                    b.full_reference			As reference
                From public.tbl_biblio b
            ) As RDB
              On RDB.biblio_id = LDB.public_db_id
            Where LDB.source_id = 1
              And LDB.submission_id = 1
              And LDB.dataset_id = $1;

End $BODY$
LANGUAGE plpgsql VOLATILE
;

/*****************************************************************************************************************************
**  Function    fn_clearinghouse_review_sample
**	Who			Roger Mähler
**	When		2013-11-14
**	What		Returns sample data used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_sample(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample(2, 2453)
create or replace function clearing_house.fn_clearinghouse_review_sample(int, int)
Returns Table (

    local_db_id					int,
    date_sampled                character varying(255),
    sample_name                 character varying(50),
    sample_name_type            character varying(50),
    type_name                   character varying(40),

    public_db_id				int,
    public_date_sampled         character varying(255),
    public_sample_name          character varying(50),
    public_sample_name_type     character varying(50),
    public_type_name            character varying(40),

    entity_type_id				int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_physical_samples');

    Return Query

        With sample (submission_id, source_id, local_db_id, public_db_id, merged_db_id, date_sampled, sample_name, sample_name_type, sample_type) As (
            Select  s.submission_id         As submission_id,
                    s.source_id             As source_id,
                    s.local_db_id           As local_db_id,
                    s.public_db_id          As public_db_id,
                    s.merged_db_id          As merged_db_id,
                    s.date_sampled          As date_sampled,
                    s.sample_name           As sample_name,
                    r.alt_ref_type          As sample_type_type,
                    n.type_name             As sample_type
            From clearing_house.view_physical_samples s
            Left Join clearing_house.view_alt_ref_types r
              On r.merged_db_id = s.alt_ref_type_id
             And r.submission_id In (0, s.submission_id)
            Join clearing_house.view_sample_types n
              On n.merged_db_id = s.sample_type_id
             And n.submission_id In (0, s.submission_id)
        )
            Select

                LDB.local_db_id						As local_db_id,
                LDB.date_sampled                    As date_sampled,
                LDB.sample_name                     As sample_name,
                LDB.sample_name_type				As sample_name_type,
                LDB.sample_type                     As sample_type,

                LDB.public_db_id					As public_db_id,
                RDB.date_sampled                    As public_date_sampled,
                RDB.sample_name                     As public_sample_name,
                RDB.sample_name_type				As public_sample_name_type,
                RDB.sample_type                     As public_sample_type,

                entity_type_id

            From sample LDB
            Left Join sample RDB
              On RDB.source_id = 2
             And RDB.public_db_id = LDB.public_db_id
            Where LDB.source_id = 1
              And LDB.submission_id = $1
              And LDB.local_db_id = -$2;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_alternative_names
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns sample group lithology review data used by client
**	Uses
**	Used By
**	Revisions

Select s.merged_db_id,
       a.alt_ref,
       t.alt_ref_type
From clearing_house.view_physical_samples s
Join clearing_house.view_sample_alt_refs a
  On a.physical_sample_id = s.merged_db_id
 And a.submission_id in (0, s.submission_id)
Join clearing_house.view_alt_ref_types t
  On t.merged_db_id = a.alt_ref_type_id
 And t.submission_id in (0, s.submission_id)

******************************************************************************************************************************/
-- Select * From clearing_house.tbl_sites
-- Drop Function clearing_house.fn_clearinghouse_review_sample_alternative_names(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_alternative_names(2,2220)
create or replace function clearing_house.fn_clearinghouse_review_sample_alternative_names(int, int)
Returns Table (

    local_db_id				int,
    alt_ref                 character varying(40),
    alt_ref_type			character varying(50),

    public_db_id			int,
    public_alt_ref          character varying(40),
    public_alt_ref_type		character varying(50),

    date_updated            text,
    entity_type_id			int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_alt_refs');

    Return Query

            Select

                LDB.local_db_id		                    As local_db_id,

                LDB.alt_ref                      		As alt_ref,
                LDB.alt_ref_type						As alt_ref_type,

                LDB.public_db_id                        As public_db_id,
                RDB.alt_ref                      		As public_alt_ref,
                RDB.alt_ref_type 						As public_alt_ref_type,

                to_char(LDB.date_updated,'YYYY-MM-DD')	As date_updated,
                entity_type_id                 			As entity_type_id

            From (
                Select s.submission_id					As submission_id,
                       s.source_id						As source_id,
                       s.merged_db_id					As physical_sample_id,
                       a.local_db_id					As local_db_id,
                       a.public_db_id					As public_db_id,
                       a.merged_db_id					As merged_db_id,
                       a.alt_ref                        As alt_ref,
                       t.alt_ref_type                   As alt_ref_type,
                       a.date_updated					As date_updated
                From clearing_house.view_physical_samples s
                Join clearing_house.view_sample_alt_refs a
                  On a.physical_sample_id = s.merged_db_id
                 And a.submission_id in (0, s.submission_id)
                Join clearing_house.view_alt_ref_types t
                  On t.merged_db_id = a.alt_ref_type_id
                 And t.submission_id in (0, s.submission_id)
            ) As LDB Left Join (
                Select a.alt_ref_type_id    			As alt_ref_type_id,
                       a.alt_ref                        As alt_ref,
                       t.alt_ref_type                   As alt_ref_type
                From public.tbl_sample_alt_refs a
                Join public.tbl_alt_ref_types t
                  On t.alt_ref_type_id = a.alt_ref_type_id
            ) As RDB
              On RDB.alt_ref_type_id = LDB.public_db_id
            Where LDB.source_id = 1
              And LDB.submission_id = $1
              And LDB.physical_sample_id = -$2;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_features
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns sample gourp reference review data used by client
**	Uses
**	Used By
**	Revisions

Select s.merged_db_id,
       f.feature_name,
       f.feature_description,
       t.feature_type_name
From clearing_house.view_physical_samples s
Join clearing_house.view_physical_sample_features fs
  On fs.physical_sample_id = s.merged_db_id
 And fs.submission_id in (0, s.submission_id)
Join clearing_house.view_features f
  On f.merged_db_id = fs.feature_id
 And f.submission_id in (0, s.submission_id)
Join clearing_house.view_feature_types t
  On t.merged_db_id = f.feature_type_id
 And t.submission_id in (0, s.submission_id)

******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_sample_features(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_features(2, 3931)
create or replace function clearing_house.fn_clearinghouse_review_sample_features(int, int)
Returns Table (

    local_db_id                 int,
    feature_name                character varying(255),
    feature_description         text,
    feature_type_name           character varying(128),

    public_db_id int,
    public_feature_name         character varying(255),
    public_feature_description  text,
    public_feature_type_name    character varying(128),

    date_updated text,
    entity_type_id int

) As $$
Declare
    sample_group_references_entity_type_id int;
Begin

    sample_group_references_entity_type_id := clearing_house.fn_get_entity_type_for('tbl_physical_sample_features');

    Return Query

        Select
            LDB.local_db_id                             As local_db_id,
            LDB.feature_name                            As feature_name,
            LDB.feature_description                     As feature_description,
            LDB.feature_type_name                       As feature_type_name,
            LDB.public_db_id                            As public_db_id,
            RDB.feature_name                            As public_feature_name,
            RDB.feature_description                     As public_feature_description,
            RDB.feature_type_name                       As public_feature_type_name,
            to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
            sample_group_references_entity_type_id		As entity_type_id
        From (
            Select	s.source_id                         As source_id,
                    s.submission_id                     As submission_id,
                    s.merged_db_id                      As physical_sample_id,
                    fs.local_db_id						As local_db_id,
                    fs.public_db_id						As public_db_id,
                    fs.merged_db_id						As merged_db_id,
                    f.feature_name						As feature_name,
                    f.feature_description				As feature_description,
                    t.feature_type_name					As feature_type_name,
                    fs.date_updated                     As date_updated
            From clearing_house.view_physical_samples s
            Join clearing_house.view_physical_sample_features fs
              On fs.physical_sample_id = s.merged_db_id
             And fs.submission_id in (0, s.submission_id)
            Join clearing_house.view_features f
              On f.merged_db_id = fs.feature_id
             And f.submission_id in (0, s.submission_id)
            Join clearing_house.view_feature_types t
              On t.merged_db_id = f.feature_type_id
             And t.submission_id in (0, s.submission_id)
        ) As LDB Left Join (
            Select	fs.feature_id						As feature_id,
                    f.feature_name						As feature_name,
                    f.feature_description				As feature_description,
                    t.feature_type_name					As feature_type_name
            From public.tbl_physical_sample_features fs
            Join public.tbl_features f
              On f.feature_id = fs.feature_id
            Join public.tbl_feature_types t
              On t.feature_type_id = f.feature_type_id
        ) As RDB
          On RDB.feature_id = LDB.public_db_id
        Where LDB.source_id = 1
          And LDB.submission_id = $1
          And LDB.physical_sample_id = -$2;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_notes
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns sample note review data used by client
**	Uses
**	Used By
**	Revisions

Select  n.merged_db_id,
        n.note_type                         As note_type,
        n.note                              As note,
        n.date_updated						As date_updated
From clearing_house.view_physical_samples s
Join clearing_house.view_sample_notes n
  On n.physical_sample_id = s.merged_db_id
 And n.submission_id in (0, s.submission_id)

******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_sample_notes(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_notes(2, 2626)
create or replace function clearing_house.fn_clearinghouse_review_sample_notes(int, int)
Returns Table (

    local_db_id			int,
    note				text,
    note_type			character varying,

    public_db_id		int,
    public_note			text,
    public_note_type	character varying,

    date_updated		text,
    entity_type_id		int

) As $$
Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_notes');

    Return Query

        Select
            LDB.local_db_id					            As local_db_id,
            LDB.note                              		As note,
            LDB.note_type                          		As note_type,
            LDB.public_db_id                            As public_db_id,
            RDB.note                               		As public_note,
            RDB.note_type                          		As note_type,
            to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
            entity_type_id                              As entity_type_id
        From (
            Select	s.source_id                         As source_id,
                    s.submission_id                     As submission_id,
                    s.local_db_id						As physical_sample_id,
                    n.local_db_id						As local_db_id,
                    n.public_db_id						As public_db_id,
                    n.merged_db_id						As merged_db_id,
                    n.note								As note,
                    n.note_type							As note_type,
                    n.date_updated						As date_updated
            From clearing_house.view_physical_samples s
            Join clearing_house.view_sample_notes n
              On n.physical_sample_id = s.merged_db_id
             And n.submission_id in (0, s.submission_id)
        ) As LDB Left Join (
            Select	n.sample_note_id                    As sample_note_id,
                    n.note								As note,
                    n.note_type							As note_type
            From public.tbl_sample_notes n
        ) As RDB
          On RDB.sample_note_id = LDB.public_db_id
        Where LDB.source_id = 1
          And LDB.submission_id = $1
          And LDB.physical_sample_id = -$2;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_dimensions
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns sample dimension review data used by client
**	Uses
**	Used By
**	Revisions

Select d.merged_db_id as sample_dimension_id,
       d.dimension_value,
       Coalesce(t.dimension_abbrev, t.dimension_name, '') as dimension_name,
       m.method_name
From clearing_house.view_physical_samples s
Join clearing_house.view_sample_dimensions d
  On d.physical_sample_id = s.merged_db_id
 And d.submission_id in (0, s.submission_id)
Join clearing_house.view_dimensions t
  On t.merged_db_id = d.dimension_id
 And d.submission_id in (0, s.submission_id)
Join clearing_house.view_methods m
  On m.merged_db_id = d.method_id
 And m.submission_id in (0, s.submission_id)

******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_sample_dimensions(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_dimensions(2, 2508)
create or replace function clearing_house.fn_clearinghouse_review_sample_dimensions(int, int)
Returns Table (

    local_db_id						int,
    dimension_value					numeric(20,10),
    dimension_name					character varying(50),
    method_name                     character varying(50),

    public_db_id					int,
    public_dimension_value			numeric(20,10),
    public_dimension_name			character varying(50),
    public_method_name              character varying(50),

    date_updated					text,
    entity_type_id					int

) As $$
Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_dimensions');

    Return Query

        Select
            LDB.local_db_id				               					As local_db_id,
            LDB.dimension_value                         				As dimension_value,
            LDB.dimension_name                         					As dimension_name,
            LDB.method_name                         					As method_name,
            LDB.public_db_id				            				As public_db_id,
            RDB.dimension_value                         				As public_dimension_value,
            RDB.dimension_name                         					As public_dimension_name,
            RDB.method_name                         					As public_method_name,
            to_char(LDB.date_updated,'YYYY-MM-DD')						As date_updated,
            entity_type_id												As entity_type_id
        From (
            Select	s.source_id                                         As source_id,
                    s.submission_id                                     As submission_id,
                    s.local_db_id										As physical_sample_id,
                    sd.local_db_id 										As local_db_id,
                    sd.public_db_id 									As public_db_id,
                    sd.merged_db_id 									As merged_db_id,
                    sd.dimension_value                                  As dimension_value,
                    Coalesce(t.dimension_abbrev, t.dimension_name, '')  As dimension_name,
                    m.method_name                                       As method_name,
                    sd.date_updated                                     As date_updated
            From clearing_house.view_physical_samples s
            Join clearing_house.view_sample_dimensions sd
              On sd.physical_sample_id = s.merged_db_id
             And sd.submission_id in (0, s.submission_id)
            Join clearing_house.view_dimensions t
              On t.merged_db_id = sd.dimension_id
             And t.submission_id in (0, s.submission_id)
            Join clearing_house.view_methods m
              On m.merged_db_id = sd.method_id
             And m.submission_id in (0, s.submission_id)
        ) As LDB Left Join (
            Select	sd.sample_dimension_id 								As sample_dimension_id,
                    sd.dimension_value                                  As dimension_value,
                    Coalesce(t.dimension_abbrev, t.dimension_name, '')  As dimension_name,
                    m.method_name                                       As method_name
            From public.tbl_sample_dimensions sd
            Join public.tbl_dimensions t
              On t.dimension_id = sd.dimension_id
            Join public.tbl_methods m
              On m.method_id = sd.method_id
          ) As RDB
          On RDB.sample_dimension_id = LDB.public_db_id
        Where LDB.source_id = 1
          And LDB.submission_id = $1
          And LDB.physical_sample_id = -$2;

End $$ Language plpgsql;


/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_descriptions
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns sample descriptions review data used by client
**	Uses
**	Used By
**	Revisions

Select s.merged_db_id,
       d.description,
       t.type_name,
       t.type_description
From clearing_house.view_physical_samples s
Join clearing_house.view_sample_descriptions d
  On d.sample_description_id = s.merged_db_id
 And d.submission_id in (0, s.submission_id)
Join clearing_house.view_sample_description_types t
  On t.merged_db_id = d.sample_description_type_id
 And t.submission_id in (0, s.submission_id)

******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_sample_descriptions(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_descriptions(2, -40)
create or replace function clearing_house.fn_clearinghouse_review_sample_descriptions(int, int)
Returns Table (

    local_db_id					int,
    type_name					character varying(255),
    type_description			text,

    public_db_id 				int,
    public_type_name			character varying(255),
    public_type_description		text,

    date_updated				text,
    entity_type_id				int

) As $$
Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_descriptions');

    Return Query

        Select
            LDB.local_db_id				               					As local_db_id,

            LDB.type_name                         						As type_name,
            LDB.type_description                       					As type_description,

            LDB.public_db_id				            				As public_db_id,

            RDB.type_name                         						As public_type_name,
            RDB.type_description                       					As public_type_description,

            to_char(LDB.date_updated,'YYYY-MM-DD')						As date_updated,
            entity_type_id												As entity_type_id

        From (
            Select	s.source_id                                         As source_id,
                    s.submission_id                                     As submission_id,
                    s.local_db_id										As physical_sample_id,
                    sd.local_db_id										As local_db_id,
                    sd.public_db_id										As public_db_id,
                    sd.merged_db_id										As merged_db_id,
                    sd.description                                      As description,
                    t.type_name                                         As type_name,
                    t.type_description                                  As type_description,
                    sd.date_updated                                     As date_updated
            From clearing_house.view_physical_samples s
            Join clearing_house.view_sample_descriptions sd
              On sd.sample_description_id = s.merged_db_id
             And sd.submission_id in (0, s.submission_id)
            Join clearing_house.view_sample_description_types t
              On t.merged_db_id = sd.sample_description_type_id
             And t.submission_id in (0, s.submission_id)
        ) As LDB Left Join (
            Select	sd.sample_description_id							As sample_description_id,
                    sd.description                                      As description,
                    t.type_name                                         As type_name,
                    t.type_description                                  As type_description
            From public.tbl_sample_descriptions sd
            Join public.tbl_sample_description_types t
              On t.sample_description_type_id = sd.sample_description_type_id
          ) As RDB
          On RDB.sample_description_id = LDB.public_db_id
        Where LDB.source_id = 1
          And LDB.submission_id = $1
          And LDB.physical_sample_id = -$2;

End $$ Language plpgsql;


/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_horizons
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns sample horizons review data used by client
**	Uses
**	Used By
**	Revisions


Select  sh.merged_db_id,
        h.merged_db_id,
        h.horizon_name,
        h.description,
        m.method_name
From clearing_house.view_physical_samples s
Join clearing_house.view_sample_horizons sh
  On sh.physical_sample_id = s.merged_db_id
 And sh.submission_id in (0, s.submission_id)
Join clearing_house.view_horizons h
  On h.merged_db_id = sh.horizon_id
 And h.submission_id in (0, s.submission_id)
Join clearing_house.view_methods m
  On m.merged_db_id = h.method_id
 And m.submission_id in (0, s.submission_id)


******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_sample_horizons(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_horizons(2, 2519)
create or replace function clearing_house.fn_clearinghouse_review_sample_horizons(int, int)
Returns Table (

    local_db_id						int,
    horizon_name                    character varying(15),
    description                     text,
    method_name                     character varying(50),

    public_db_id 					int,
    public_horizon_name             character varying(15),
    public_description              text,
    public_method_name              character varying(50),

    date_updated                    text,
    entity_type_id					int

) As $$
Declare
    entity_type_id int;
Begin
    -- Entity in focus should perhaps be tbl_samples instead. In such case return ids from h (and join LDB & RDB on horizon id)
    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_horizons');

    Return Query

        Select
            LDB.local_db_id				               	As local_db_id, --> use horizon_id instead?
            LDB.horizon_name                            As horizon_name,
            LDB.description                             As description,
            LDB.method_name                       		As method_name,
            LDB.public_db_id				            As public_db_id,
            RDB.horizon_name                            As public_horizon_name,
            RDB.description                             As public_description,
            RDB.method_name                       		As public_method_name,
            to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
            entity_type_id								As entity_type_id
        From (
            Select	s.source_id                         As source_id,
                    s.submission_id                     As submission_id,
                    s.local_db_id						As physical_sample_id,
                    sh.local_db_id						As local_db_id,
                    sh.public_db_id						As public_db_id,
                    sh.merged_db_id						As merged_db_id,
                    --h.merged_db_id                    As horizon_id,/* alternative review entity */
                    h.horizon_name                      As horizon_name,
                    h.description                       As description,
                    m.method_name                       As method_name,
                    sh.date_updated                     As date_updated
            From clearing_house.view_physical_samples s
            Join clearing_house.view_sample_horizons sh
              On sh.physical_sample_id = s.merged_db_id
             And sh.submission_id in (0, s.submission_id)
            Join clearing_house.view_horizons h
              On h.merged_db_id = sh.horizon_id
             And h.submission_id in (0, s.submission_id)
            Join clearing_house.view_methods m
              On m.merged_db_id = h.method_id
             And m.submission_id in (0, s.submission_id)
            Where 1 = 1
        ) As LDB Left Join (
            Select	sh.sample_horizon_id				As sample_horizon_id,
                    h.horizon_name                      As horizon_name,
                    h.description                       As description,
                    m.method_name                       As method_name
            From public.tbl_sample_horizons sh
            Join public.tbl_horizons h
              On h.horizon_id = sh.horizon_id
            Join public.tbl_methods m
              On m.method_id = h.method_id
        ) As RDB
          On RDB.sample_horizon_id = LDB.public_db_id
        Where LDB.source_id = 1
          And LDB.submission_id = $1
          And LDB.physical_sample_id = -$2;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_colours
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns sample colours review data used by client
**	Uses
**	Used By
**	Revisions


Select  sc.merged_db_id,
        c.merged_db_id,
        c.colour_name,
        c.rgb,          -- Bör visas i visas
        m.method_name
From clearing_house.view_physical_samples s
Join clearing_house.view_sample_colours sc
  On sc.physical_sample_id = s.merged_db_id
 And sc.submission_id in (0, s.submission_id)
Join clearing_house.view_colours c
  On c.merged_db_id = sc.colour_id
 And c.submission_id in (0, s.submission_id)
Join clearing_house.view_methods m
  On m.merged_db_id = c.method_id
 And m.submission_id in (0, s.submission_id)


******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_sample_colours(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_colours(2, -40)
create or replace function clearing_house.fn_clearinghouse_review_sample_colours(int, int)
Returns Table (

    local_db_id						int,
    colour_name                     character varying(30),
    rgb                             integer,
    method_name                     character varying(50),

    public_db_id 					int,
    public_colour_name              character varying(30),
    public_rgb                      integer,
    public_method_name              character varying(50),

    date_updated                    text,
    entity_type_id					int

) As $$
Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_colours');

    Return Query

        Select
            LDB.local_db_id				               	As local_db_id, /* Alt: Use colour_id instead */
            LDB.colour_name                             As colour_name,
            LDB.rgb                                     As rgb,
            LDB.method_name                       		As method_name,

            LDB.public_db_id				            As public_db_id,
            RDB.colour_name                             As public_colour_name,
            RDB.rgb                                     As public_rgb,
            RDB.method_name                       		As public_method_name,

            to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
            entity_type_id								As entity_type_id

        From (
            Select	s.source_id                         As source_id,
                    s.submission_id                     As submission_id,
                    s.local_db_id						As physical_sample_id,
                    sc.local_db_id						As local_db_id,
                    sc.public_db_id						As public_db_id,
                    sc.merged_db_id						As merged_db_id,
                    --c.merged_db_id                    As colour_id, /* alternative review entity */
                    c.colour_name                       As colour_name,
                    c.rgb                               As rgb,
                    m.method_name                       As method_name,
                    sc.date_updated                     As date_updated
            From clearing_house.view_physical_samples s
            Join clearing_house.view_sample_colours sc
              On sc.physical_sample_id = s.merged_db_id
             And sc.submission_id in (0, s.submission_id)
            Join clearing_house.view_colours c
              On c.merged_db_id = sc.colour_id
             And c.submission_id in (0, s.submission_id)
            Join clearing_house.view_methods m
              On m.merged_db_id = c.method_id
             And m.submission_id in (0, s.submission_id)
        ) As LDB Left Join (
            Select	sc.sample_colour_id					As sample_colour_id,
                    c.colour_id                         As colour_id, /* alternative review entity */
                    c.colour_name                       As colour_name,
                    c.rgb                               As rgb,
                    m.method_name                       As method_name
            From public.tbl_sample_colours sc
            Join public.tbl_colours c
              On c.colour_id = sc.colour_id
            Join public.tbl_methods m
              On m.method_id = c.method_id
        ) As RDB
          On RDB.sample_colour_id = LDB.public_db_id
        Where LDB.source_id = 1
          And LDB.submission_id = $1
          And LDB.physical_sample_id = -$2;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_images
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns sample images review data used by client
**	Uses
**	Used By
**	Revisions


Select  si.merged_db_id,
        si.image_name,
        si.description,
        it.image_type
From clearing_house.view_physical_samples s
Join clearing_house.view_sample_images si
  On si.physical_sample_id = s.merged_db_id
 And si.submission_id in (0, s.submission_id)
Join clearing_house.view_image_types it
  On it.merged_db_id = si.image_type_id
 And it.submission_id in (0, s.submission_id)


******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_sample_images(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_images(2, 2453)
create or replace function clearing_house.fn_clearinghouse_review_sample_images(int, int)
Returns Table (

    local_db_id						int,
    image_name                      character varying(80),
    description                     text,
    image_type						character varying(40),

    public_db_id 					int,
    public_image_name               character varying(80),
    public_description              text,
    public_image_type				character varying(40),

    date_updated                    text,
    entity_type_id					int

) As $$
Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_images');

    Return Query

        Select
            LDB.local_db_id				               	As local_db_id,

            LDB.image_name                              As image_name,
            LDB.description                             As description,
            LDB.image_type                       		As image_type,

            LDB.public_db_id				            As public_db_id,

            RDB.image_name                              As public_image_name,
            RDB.description                             As public_description,
            RDB.image_type                       		As public_image_type,

            to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
            entity_type_id								As entity_type_id

        From (
            Select	s.source_id                         As source_id,
                    s.submission_id                     As submission_id,
                    s.local_db_id						As physical_sample_id,
                    si.local_db_id						As local_db_id,
                    si.public_db_id						As public_db_id,
                    si.merged_db_id						As merged_db_id,
                    si.image_name                       As image_name,
                    si.description                      As description,
                    it.image_type                       As image_type,
                    si.date_updated                     As date_updated
            From clearing_house.view_physical_samples s
            Join clearing_house.view_sample_images si
              On si.physical_sample_id = s.merged_db_id
             And si.submission_id in (0, s.submission_id)
            Join clearing_house.view_image_types it
              On it.merged_db_id = si.image_type_id
             And it.submission_id in (0, s.submission_id)
        ) As LDB Left Join (
            Select	si.sample_image_id					As sample_image_id,
                    si.image_name                       As image_name,
                    si.description                      As description,
                    it.image_type                       As image_type
            From public.tbl_sample_images si
            Join public.tbl_image_types it
              On it.image_type_id = si.image_type_id
        ) As RDB
          On RDB.sample_image_id = LDB.public_db_id
        Where LDB.source_id = 1
          And LDB.submission_id = $1
          And LDB.physical_sample_id = -$2;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_locations
**	Who			Roger Mähler
**	When		2013-11-07
**	What		Returns site locations used by client
**	Uses
**	Used By
**	Revisions


Select sl.merged_db_id,
       sl.location,
       t.location_type,
       t.description
From clearing_house.view_physical_samples s
Join clearing_house.view_sample_locations sl
  On sl.physical_sample_id = s.merged_db_id
 And sl.submission_id in (0, s.submission_id)
Join clearing_house.view_location_types t
  On t.merged_db_id = sl.sample_location_type_id
 And t.submission_id in (0, s.submission_id)

******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_sample_locations(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_locations(2, 2453)
create or replace function clearing_house.fn_clearinghouse_review_sample_locations(int, int)
Returns Table (

    local_db_id                 int,
    location                    character varying(255),
    location_type               character varying(40),
    description                 text,

    public_db_id int,
    public_location             character varying(255),
    public_location_type        character varying(40),
    public_description          text,

    date_updated text,
    entity_type_id int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_locations');

    Return Query

            Select

                LDB.local_db_id                   		As local_db_id,

                LDB.location                            As location,
                LDB.location_type                       As location_type,
                LDB.description                         As description,

                LDB.public_db_id                        As public_db_id,

                RDB.location                            As public_location,
                RDB.location_type                       As public_location_type,
                RDB.description                         As public_description,

                to_char(LDB.date_updated,'YYYY-MM-DD')	As date_updated,
                entity_type_id              			As entity_type_id

            From (
                Select	s.source_id                         As source_id,
                        s.submission_id                     As submission_id,
                        s.local_db_id						As physical_sample_id,
                        sl.local_db_id						As local_db_id,
                        sl.public_db_id						As public_db_id,
                        sl.merged_db_id						As merged_db_id,
                        sl.location                         As location,
                        t.location_type                     As location_type,
                        t.location_type_description         As description,
                        sl.date_updated						As date_updated
                From clearing_house.view_physical_samples s
                Join clearing_house.view_sample_locations sl
                  On sl.physical_sample_id = s.merged_db_id
                 And sl.submission_id in (0, s.submission_id)
                Join clearing_house.view_sample_location_types t
                  On t.merged_db_id = sl.sample_location_type_id
                 And t.submission_id in (0, s.submission_id)
            ) As LDB Left Join (
                Select	sl.sample_location_id				As sample_location_id,
                        sl.location                         As location,
                        t.location_type                     As location_type,
                        t.location_type_description         As description
                From public.tbl_sample_locations sl
                Join public.tbl_sample_location_types t
                  On t.sample_location_type_id = sl.sample_location_type_id
            ) As RDB
              On RDB.sample_location_id = LDB.public_db_id
            Where LDB.source_id = 1
              And LDB.submission_id = $1
              And LDB.physical_sample_id = -$2;

End $$ Language plpgsql;


-- drop function clearing_house.fn_clearinghouse_review_dendro_date_notes(integer, integer);
create or replace function clearing_house.fn_clearinghouse_review_sample_dendro_date_notes(p_submission_id integer, p_physical_sample_id integer)
returns table(
    local_db_id    integer,
    dendro_date_id integer,
    note           text,
    public_db_id   integer,
    public_note    text,
    date_updated   text,
    entity_type_id integer
) language 'plpgsql'
as $body$
declare
    entity_type_id int;
begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_dendro_date_notes');

    return query
        with submission_notes as (
            select	dd.source_id						as source_id,
                    dd.submission_id					as submission_id,
                    ps.local_db_id						As physical_sample_id,
                    dd.local_db_id						as dendro_date_id,
                    ddn.local_db_id						as local_db_id,
                    ddn.public_db_id					as public_db_id,
                    ddn.merged_db_id					as merged_db_id,
                    ddn.note							as note,
                    ddn.date_updated					as date_updated
            from clearing_house.view_dendro_dates dd
            join clearing_house.view_dendro_date_notes ddn
              on ddn.dendro_date_id = dd.merged_db_id
             and ddn.submission_id in (0, dd.submission_id)
            join clearing_house.view_analysis_entities ae
              on ae.merged_db_id = dd.analysis_entity_id
             and ae.submission_id in (9, dd.submission_id)
            join clearing_house.view_physical_samples ps
              on ps.merged_db_id = ae.physical_sample_id
             and ps.submission_id in (0, dd.submission_id)
        )
            select ldb.local_db_id					        as local_db_id,
                   ldb.dendro_date_id                       as dendro_date_id,
                   ldb.note                              	as note,
                   ldb.public_db_id                         as public_db_id,
                   rdb.note                              	as public_note,
                   to_char(ldb.date_updated,'yyyy-mm-dd')	as date_updated,
                   entity_type_id                  			as entity_type_id
            from submission_notes as ldb
            left join public.tbl_dendro_date_notes as rdb
              on rdb.dendro_date_note_id = ldb.public_db_id
            where ldb.source_id = 1
              and ldb.submission_id = p_submission_id
              and ldb.physical_sample_id = -p_physical_sample_id;

end
$body$;

-- drop function clearing_house.fn_clearinghouse_review_sample_dendro_dates(integer, integer);
create or replace function clearing_house.fn_clearinghouse_review_sample_dendro_dates(p_submission_id integer, p_physical_sample_id integer)
returns table(

    local_db_id integer,
    sample_name character varying,
    dating_type character varying,
    season_type character varying,
    date text,
    error_years_minus text,
    error_years_plus text,

    public_db_id integer,
    public_sample_name character varying,
    public_dating_type character varying,
    public_season_type character varying,
    public_date text,
    public_error_years_minus text,
    public_error_years_plus text,

    entity_type_id integer
) as
$body$
declare
    entity_type_id int;
begin
    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_dendro_dates');

    return query

        select

            ldb.local_db_id				               						as dendro_date_id,
            ldb.sample_name                     							as sample_name,
            ldb.lookup_name													as dating_type,
            ldb.season_or_qualifier_type									as season_type,
            coalesce(ldb.uncertainty, '') ||
                coalesce(ldb.age_older || '-', '') ||
                coalesce(ldb.age_younger, '') ||' '|| ldb.age_type          as date,
            coalesce(ldb.error_uncertainty_type, '') || ' ' ||
                coalesce(ldb.error_minus, '') 	                            as error_years_minus,
            coalesce(ldb.error_uncertainty_type, '') || ' ' ||
                coalesce(ldb.error_plus, '') 	                            as error_years_plus,

            rdb.dendro_date_id												as public_db_id,
            rdb.sample_name                     							as public_sample_name,
            rdb.lookup_name													as public_dating_type,
            rdb.season_or_qualifier_type									as public_season_type,
            coalesce(rdb.uncertainty::text, '') ||
                coalesce(rdb.age_older || '-', '') ||
                coalesce(rdb.age_younger, '') ||' '|| rdb.age_type          as public_date,
            coalesce(rdb.error_uncertainty_type, '') || ' ' ||
                coalesce(rdb.error_minus, '')                               as public_error_years_minus,
            coalesce(rdb.error_uncertainty_type, '') || ' ' ||
                coalesce(rdb.error_plus, '') 	                            as public_error_years_plus,
            entity_type_id

        from (

            select	dd.source_id				 as source_id,
                    dd.submission_id			 as submission_id,
                    dd.local_db_id				 as local_db_id,
                    dd.public_db_id				 as public_db_id,
                    dd.merged_db_id				 as merged_db_id,
                    ps.local_db_id				 as physical_sample_id,
                    ps.sample_name				 as sample_name,
                    dl.name 					 as lookup_name,
                    soq.season_or_qualifier_type as season_or_qualifier_type,
                    du.uncertainty::text		 as uncertainty,
                    dd.age_older::text			 as age_older,
                    dd.age_younger::text		 as age_younger,
                    at.age_type					 as age_type,
                    eu.error_uncertainty_type	 as error_uncertainty_type,
                    dd.error_minus::text		 as error_minus,
                    dd.error_plus::text			 as error_plus,
                    dd.date_updated				 as date_updated

            from clearing_house.view_dendro_dates dd
            join clearing_house.view_analysis_entities ae
              on ae.merged_db_id = dd.analysis_entity_id
             and ae.submission_id in (0, dd.submission_id)
            left join clearing_house.view_age_types at
              on at.merged_db_id = dd.age_type_id
             and at.submission_id in (0, dd.submission_id)
            left join clearing_house.view_dating_uncertainty du
              on du.merged_db_id = dd.dating_uncertainty_id
             and du.submission_id in (0, dd.submission_id)
            left join clearing_house.view_error_uncertainties eu
              on eu.merged_db_id = dd.error_uncertainty_id
             and eu.submission_id in (0, dd.submission_id)
            left join clearing_house.view_season_or_qualifier soq
              on soq.merged_db_id = dd.season_or_qualifier_id
             and soq.submission_id in (0, dd.submission_id)
            left join clearing_house.view_dendro_lookup dl
              on dl.merged_db_id = dd.dendro_lookup_id
             and dl.submission_id in (0, dd.submission_id)
            join clearing_house.view_physical_samples ps
              on ps.merged_db_id = ae.physical_sample_id
             and ps.submission_id in (0, dd.submission_id)

        ) as ldb
        left join (
            select 	ps.physical_sample_id		 as physical_sample_id,
                    ps.sample_name				 as sample_name,
                    dd.dendro_date_id			 as dendro_date_id,
                    dl.name 					 as lookup_name,
                    soq.season_or_qualifier_type as season_or_qualifier_type,
                    du.uncertainty::text		 as uncertainty,
                    dd.age_older::text			 as age_older,
                    dd.age_younger::text		 as age_younger,
                    at.age_type				     as age_type,
                    eu.error_uncertainty_type	 as error_uncertainty_type,
                    dd.error_minus::text		 as error_minus,
                    dd.error_plus::text			 as error_plus,
                    dd.date_updated				 as date_updated

            from public.tbl_physical_samples ps
            join public.tbl_analysis_entities ae
                on ps.physical_sample_id = ae.physical_sample_id
            join public.tbl_dendro_dates dd
                on ae.analysis_entity_id = dd.analysis_entity_id
            join public.tbl_age_types at
                on at.age_type_id = dd.age_type_id
            left join public.tbl_dating_uncertainty du
                on du.dating_uncertainty_id = dd.dating_uncertainty_id
            left join public.tbl_error_uncertainties eu
                on eu.error_uncertainty_id = dd.error_uncertainty_id
            left join public.tbl_season_or_qualifier soq
                on soq.season_or_qualifier_id = dd.season_or_qualifier_id
            left join public.tbl_dendro_lookup dl
                on dl.dendro_lookup_id = dd.dendro_lookup_id
        ) as rdb
          on rdb.dendro_date_id = ldb.public_db_id

        where ldb.source_id = 1
          and ldb.submission_id = p_submission_id
          and ldb.physical_sample_id = -p_physical_sample_id;

end
$body$ language plpgsql;

-- drop function clearing_house.fn_clearinghouse_review_sample_positions_client_data(integer, integer);

create or replace function clearing_house.fn_clearinghouse_review_sample_positions(p_submission_id integer, p_physical_sample_id integer)
  returns table (

      local_db_id integer,
      sample_position text,
      position_accuracy numeric(20,10),
      method_name character varying,

      public_db_id integer,
      public_sample_position text,
      public_position_accuracy numeric(20,10),
      public_method_name character varying,

      entity_type_id integer
) as
$body$
declare
    entity_type_id int;
begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_coordinates');

    return query

        select
            ldb.local_db_id				               	as local_db_id,
            coalesce(ldb.dimension_name, '') || ' ' ||
                coalesce(ldb.measurement, '')           as sample_position,
            ldb.accuracy                       		    as position_accuracy,
            ldb.method_name                       		as method_name,

            ldb.public_db_id				            as public_db_id,
            coalesce(rdb.dimension_name, '') || ' '||
                coalesce(rdb.measurement, '')           as public_sample_position,
            rdb.accuracy                       		    as public_position_accuracy,
            rdb.method_name                       		as public_method_name,
            entity_type_id						        as entity_type_id
        from (

            select	ps.source_id						as source_id,
                    ps.submission_id					as submission_id,
                    ps.local_db_id						as physical_sample_id,
                    d.local_db_id						as local_db_id,
                    d.public_db_id						as public_db_id,
                    d.merged_db_id						as merged_db_id,
                    c.measurement::text 				as measurement,
                    c.accuracy						    as accuracy,
                    m.method_name						as method_name,
                    d.dimension_name::text				as dimension_name
            from clearing_house.view_physical_samples ps
            join clearing_house.view_sample_coordinates c
              on c.physical_sample_id = ps.merged_db_id
             and c.submission_id in (0, ps.submission_id)
            join clearing_house.view_coordinate_method_dimensions md
              on md.merged_db_id = c.coordinate_method_dimension_id
             and md.submission_id in (0, ps.submission_id)
            join clearing_house.view_methods m
              on m.merged_db_id = md.method_id
             and m.submission_id in (0, ps.submission_id)
            join clearing_house.view_dimensions d
              on d.merged_db_id = md.dimension_id
             and d.submission_id in (0, ps.submission_id)

        ) as ldb left join (

            select	c.sample_coordinate_id		as sample_coordinate_id,
                    c.measurement::text			as measurement,
                    c.accuracy					as accuracy,
                    m.method_name				as method_name,
                    d.dimension_name::text		as dimension_name
            from public.tbl_sample_coordinates c
            join public.tbl_coordinate_method_dimensions md
              on md.coordinate_method_dimension_id = c.coordinate_method_dimension_id
            join public.tbl_methods m
              on m.method_id = md.method_id
            join public.tbl_dimensions d
              on d.dimension_id = md.dimension_id

        ) as rdb
          on rdb.sample_coordinate_id = ldb.public_db_id
        where ldb.source_id = 1
          and ldb.submission_id = p_submission_id
          and ldb.physical_sample_id = -p_physical_sample_id;

end $body$
  language plpgsql;/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_group_client_data
**	Who			Roger Mähler
**	When		2013-11-07
**	What		Returns site data used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_sample_group_client_data(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_group_client_data(1, -2024)
create or replace function clearing_house.fn_clearinghouse_review_sample_group_client_data(int, int)
Returns Table (

	local_db_id					int,
	sample_group_name			character varying(100),
	sampling_method				character varying(50),
	sampling_context			character varying(40),

	public_db_id				int,
	public_sample_group_name	character varying(100),
	public_sampling_method		character varying(50),
	public_sampling_context		character varying(40),

	entity_type_id				int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_groups');

	Return Query

		With sample_group (submission_id, source_id, local_db_id, public_db_id, merged_db_id, sample_group_name, sampling_method, sampling_context) As (
            Select sg.submission_id                 As submission_id,
                   sg.source_id                     As source_id,
                   sg.local_db_id                   As local_db_id,
                   sg.public_db_id                  As public_db_id,
                   sg.merged_db_id                  As merged_db_id,
                   sg.sample_group_name             As sample_group_name,
                   m.method_name                    As sampling_method,
                   c.sampling_context				As sampling_context
            From clearing_house.view_sample_groups sg
            Join clearing_house.view_methods m
              On m.merged_db_id = sg.method_id
             And m.submission_id in (0, sg.submission_id)
            Join clearing_house.view_sample_group_sampling_contexts c
              On c.merged_db_id = sg.sampling_context_id
             And c.submission_id in (0, sg.submission_id)
		)
			Select

				LDB.local_db_id						As local_db_id,

				LDB.sample_group_name				As sample_group_name,
				LDB.sampling_method					As sampling_method,
				LDB.sampling_context				As sampling_context,

				LDB.public_db_id					As public_db_id,

				RDB.sample_group_name				As public_sample_group_name,
				RDB.sampling_method					As public_sampling_method,
				RDB.sampling_context				As public_sampling_context,

                entity_type_id

			From sample_group LDB
			Left Join sample_group RDB
			  On RDB.source_id = 2
			 And RDB.public_db_id = LDB.public_db_id
			Where LDB.source_id = 1
			  And LDB.submission_id = $1
			  And LDB.local_db_id = -$2;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_group_lithology_client_data
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns sample group lithology review data used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Select * From clearing_house.tbl_sites
-- Drop Function clearing_house.fn_clearinghouse_review_sample_group_lithology_client_data(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_group_lithology_client_data(2,-40)
create or replace function clearing_house.fn_clearinghouse_review_sample_group_lithology_client_data(int, int)
Returns Table (

	local_db_id				int,
    depth_top				numeric(20,5),
    depth_bottom			numeric(20,5),
	description				text,
	lower_boundary			character varying(255),

	public_db_id			int,
    public_depth_top		numeric(20,5),
    public_depth_bottom		numeric(20,5),
	public_description		text,
	public_lower_boundary	character varying(255),

	entity_type_id			int

) As $$

Declare
    entity_type_id int;

Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_lithology');

	Return Query

			Select

				LDB.local_db_id		                    As local_db_id,

				LDB.depth_top                      		As depth_top,
				LDB.depth_bottom						As depth_bottom,
				LDB.description                  		As description,
				LDB.lower_boundary                 		As lower_boundary,

				LDB.public_db_id                        As public_db_id,
				RDB.depth_top                      		As public_depth_top,
				RDB.depth_bottom						As public_depth_bottom,
				RDB.description                  		As public_description,
				RDB.lower_boundary                 		As public_lower_boundary,

				entity_type_id              			As entity_type_id

			From (
				Select sg.submission_id					As submission_id,
					   sg.source_id						As source_id,
					   sg.merged_db_id					As sample_group_id,
					   l.local_db_id					As local_db_id,
					   l.public_db_id					As public_db_id,
					   l.merged_db_id					As lithology_id,
					   l.depth_top						As depth_top,
					   l.depth_bottom					As depth_bottom,
					   l.description					As description,
					   l.lower_boundary					As lower_boundary
				From clearing_house.view_sample_groups sg
				Join clearing_house.view_lithology l
				  On l.sample_group_id = sg.merged_db_id
				 And l.submission_id in (0, sg.submission_id)
			) As LDB Left Join (
				Select sg.sample_group_id				As sample_group_id,
					   l.lithology_id					As lithology_id,
					   l.depth_top						As depth_top,
					   l.depth_bottom					As depth_bottom,
					   l.description					As description,
					   l.lower_boundary					As lower_boundary
				From public.tbl_sample_groups sg
				Join public.tbl_lithology l
				  On l.sample_group_id = sg.sample_group_id
			) As RDB
			  On RDB.lithology_id = LDB.public_db_id
			Where LDB.source_id = 1
			  And LDB.submission_id = $1
			  And LDB.sample_group_id = -$2;

End $$ Language plpgsql;


/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_group_references_client_data
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns sample gourp reference review data used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_sample_group_references_client_data(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_group_references_client_data(2, -40)
create or replace function clearing_house.fn_clearinghouse_review_sample_group_references_client_data(int, int)
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

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_group_references');

	Return Query

		Select
			LDB.sample_group_reference_id               As local_db_id,
			LDB.reference                               As reference,
			LDB.public_db_id                            As public_db_id,
			RDB.reference                               As public_reference,
			to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
			entity_type_id                      		As entity_type_id
		From (
			Select	sg.source_id						As source_id,
					sg.submission_id					As submission_id,
					sg.local_db_id						As sample_group_id,
					sr.local_db_id						As sample_group_reference_id,
					b.local_db_id						As local_db_id,
					b.public_db_id						As public_db_id,
					b.merged_db_id						As merged_db_id,
					b.authors || ' (' || b.year || ')'	As reference,
					sr.date_updated						As date_updated
			From clearing_house.view_sample_groups sg
			Join clearing_house.view_sample_group_references sr
			  On sr.sample_group_id = sg.merged_db_id
			 And sr.submission_id In (0, sg.submission_id)
			Join clearing_house.view_biblio b
			  On b.merged_db_id = sr.biblio_id
			 And b.submission_id In (0, sg.submission_id)
		) As LDB Left Join (
			Select	b.biblio_id							As biblio_id,
					b.authors || ' (' || b.year || ')'	As reference
			From public.tbl_biblio b
		) As RDB
		  On RDB.biblio_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		  And LDB.sample_group_id = -$2;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_group_notes_client_data
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns sample group note review data used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_sample_group_notes_client_data(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_group_notes_client_data(2, -40)
create or replace function clearing_house.fn_clearinghouse_review_sample_group_notes_client_data(int, int)
Returns Table (

	local_db_id			int,
    note				character varying(255),

	public_db_id		int,
    public_note			character varying(255),

    date_updated		text,
	entity_type_id		int

) As $$
Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_group_notes');

	Return Query

		Select
			LDB.local_db_id					            As local_db_id,
			LDB.note                              		As note,
			LDB.public_db_id                            As public_db_id,
			RDB.note                               		As public_note,
			to_char(LDB.date_updated,'YYYY-MM-DD')		As date_updated,
			entity_type_id                  			As entity_type_id
		From (
			Select	sg.source_id						As source_id,
					sg.submission_id					As submission_id,
					sg.local_db_id						As sample_group_id,
					n.local_db_id						As local_db_id,
					n.public_db_id						As public_db_id,
					n.merged_db_id						As merged_db_id,
					n.note								As note,
					n.date_updated						As date_updated
			From clearing_house.view_sample_groups sg
			Join clearing_house.view_sample_group_notes n
			  On n.sample_group_id = sg.merged_db_id
			 And n.submission_id in (0, sg.submission_id)
		) As LDB Left Join (
			Select	n.sample_group_note_id				As sample_group_note_id,
					n.note								As note
			From public.tbl_sample_group_notes n
		) As RDB
		  On RDB.sample_group_note_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		  And LDB.sample_group_id = -$2;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_group_dimensions_client_data
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns sample group dimension review data used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_sample_group_dimensions_client_data(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_group_dimensions_client_data(2, -40)
create or replace function clearing_house.fn_clearinghouse_review_sample_group_dimensions_client_data(int, int)
Returns Table (

	local_db_id						int,
    dimension_value					numeric(20,5),
    dimension_name					character varying(50),

	public_db_id					int,
    public_dimension_value			numeric(20,5),
    public_dimension_name			character varying(50),

    date_updated					text,
	entity_type_id					int

) As $$
Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_group_dimensions');

	Return Query

		Select
			LDB.local_db_id				               					As local_db_id,
			LDB.dimension_value                         				As dimension_value,
			LDB.dimension_name                         					As dimension_name,
			LDB.public_db_id				            				As public_db_id,
			RDB.dimension_value                         				As public_dimension_value,
			RDB.dimension_name                         					As public_dimension_name,
			to_char(LDB.date_updated,'YYYY-MM-DD')						As date_updated,
			entity_type_id												As entity_type_id
		From (
			Select	sg.source_id										As source_id,
					sg.submission_id									As submission_id,
					sg.local_db_id										As sample_group_id,
					d.local_db_id 										As local_db_id,
					d.public_db_id 										As public_db_id,
					d.merged_db_id 										As merged_db_id,
					d.dimension_value									As dimension_value,
					Coalesce(t.dimension_abbrev, t.dimension_name, '')	As dimension_name,
					d.date_updated										As date_updated
			From clearing_house.view_sample_groups sg
			Join clearing_house.view_sample_group_dimensions d
			  On d.sample_group_id = sg.merged_db_id
			 And d.submission_id in (0, sg.submission_id)
			Join clearing_house.view_dimensions t
			  On t.merged_db_id = d.dimension_id
			 And d.submission_id in (0, sg.submission_id)
		) As LDB Left Join (
			Select	d.sample_group_dimension_id 						As sample_group_dimension_id,
					d.dimension_value									As dimension_value,
					Coalesce(t.dimension_abbrev, t.dimension_name, '')	As dimension_name
			From public.tbl_sample_group_dimensions d
			Join public.tbl_dimensions t
			  On t.dimension_id = d.dimension_id
		  ) As RDB
		  On RDB.sample_group_dimension_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		  And LDB.sample_group_id = -$2;

End $$ Language plpgsql;


/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_group_descriptions_client_data
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns sample group descriptions review data used by client
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_sample_group_descriptions_client_data(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_group_descriptions_client_data(2, -40)
create or replace function clearing_house.fn_clearinghouse_review_sample_group_descriptions_client_data(int, int)
Returns Table (

	local_db_id					int,
    group_description			character varying(255),
    type_name					character varying(255),
    type_description			character varying(255),

	public_db_id 				int,
    public_group_description	character varying(255),
    public_type_name			character varying(255),
    public_type_description		character varying(255),

	entity_type_id				int

) As $$
Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_group_descriptions');

	Return Query

		Select
			LDB.local_db_id				               					As local_db_id,
			LDB.group_description                       				As group_description,
			LDB.type_name                         						As type_name,
			LDB.type_description                       					As type_description,
			LDB.public_db_id				            				As public_db_id,
			RDB.group_description                      					As public_group_description,
			RDB.type_name                         						As public_type_name,
			RDB.type_description                       					As public_type_description,
			entity_type_id												As entity_type_id
		From (
			Select	sg.source_id										As source_id,
					sg.submission_id									As submission_id,
					sg.local_db_id										As sample_group_id,
					d.local_db_id										As local_db_id,
					d.public_db_id										As public_db_id,
					d.merged_db_id										As merged_db_id,
					d.group_description									As group_description,
					t.type_name											As type_name,
					t.type_description									As type_description
			From clearing_house.view_sample_groups sg
			Join clearing_house.view_sample_group_descriptions d
			  On sg.merged_db_id = d.sample_group_id
			 And d.submission_id in (0, sg.submission_id)
			Join clearing_house.view_sample_group_description_types t
			  On t.merged_db_id = d.sample_group_description_type_id
			 And t.submission_id in (0, sg.submission_id)
		) As LDB Left Join (
			Select	d.sample_group_description_id						As sample_group_description_id,
					d.group_description									As group_description,
					t.type_name											As type_name,
					t.type_description									As type_description
			From public.tbl_sample_groups sg
			Join public.tbl_sample_group_descriptions d
			  On d.sample_group_id = sg.sample_group_id
			Join public.tbl_sample_group_description_types t
			  On t.sample_group_description_type_id = d.sample_group_description_type_id
		  ) As RDB
		  On RDB.sample_group_description_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		  And LDB.sample_group_id = -$2;

End $$ Language plpgsql;


/*****************************************************************************************************************************
**	Function	fn_clearinghouse_review_sample_group_positions_client_data
**	Who			Roger Mähler
**	When		2013-11-13
**	What		Returns sample group descriptions positions review data used by client
**	Uses
**	Used By
**	Revisions   20180702 Merged sample_group_position & dimension_name
******************************************************************************************************************************/
-- Drop Function clearing_house.fn_clearinghouse_review_sample_group_positions_client_data(int, int)
-- Select * From clearing_house.fn_clearinghouse_review_sample_group_positions_client_data(2, -40)
create or replace function clearing_house.fn_clearinghouse_review_sample_group_positions_client_data(int, int)
Returns Table (

	local_db_id						int,
    sample_group_position			text,
    position_accuracy				character varying(128),
    method_name						character varying(50),

	public_db_id 					int,
    public_sample_group_position	text,
    public_position_accuracy		character varying(128),
    public_method_name				character varying(50),

	entity_type_id					int

) As $$
Declare
    entity_type_id int;
Begin

    entity_type_id := clearing_house.fn_get_entity_type_for('tbl_sample_group_coordinates');

	Return Query

		Select
			LDB.local_db_id				               	As local_db_id,
			format('%s %s', LDB.dimension_name,
                LDB.sample_group_position)              As sample_group_position,
			LDB.position_accuracy                       As position_accuracy,
			LDB.method_name                       		As method_name,
			LDB.public_db_id				            As public_db_id,
			format('%s %s', RDB.dimension_name,
                RDB.sample_group_position)              As public_sample_group_position,
			RDB.position_accuracy                       As public_position_accuracy,
			RDB.method_name                       		As public_method_name,
			entity_type_id								As entity_type_id
		From (
			Select	sg.source_id						As source_id,
					sg.submission_id					As submission_id,
					sg.local_db_id						As sample_group_id,
					d.local_db_id						As local_db_id,
					d.public_db_id						As public_db_id,
					d.merged_db_id						As merged_db_id,
					c.sample_group_position				As sample_group_position,
					c.position_accuracy					As position_accuracy,
					m.method_name						As method_name,
					d.dimension_name					As dimension_name
			From clearing_house.view_sample_groups sg
			Join clearing_house.view_sample_group_coordinates c
			  On c.sample_group_id = sg.merged_db_id
			 And c.submission_id In (0, sg.submission_id)
			Join clearing_house.view_coordinate_method_dimensions md
			  On md.merged_db_id = c.coordinate_method_dimension_id
			 And md.submission_id In (0, sg.submission_id)
			Join clearing_house.view_methods m
			  On m.merged_db_id = md.method_id
			 And m.submission_id In (0, sg.submission_id)
			Join clearing_house.view_dimensions d
			  On d.merged_db_id = md.dimension_id
			 And d.submission_id In (0, sg.submission_id)
			Where 1 = 1
		) As LDB Left Join (
			Select	c.sample_group_position_id			As sample_group_position_id,
					c.sample_group_position				As sample_group_position,
					c.position_accuracy					As position_accuracy,
					m.method_name						As method_name,
					d.dimension_name					As dimension_name
			From public.tbl_sample_group_coordinates c
			Join public.tbl_coordinate_method_dimensions md
			  On md.coordinate_method_dimension_id = c.coordinate_method_dimension_id
			Join public.tbl_methods m
			  On m.method_id = md.method_id
			Join public.tbl_dimensions d
			  On d.dimension_id = md.dimension_id
		) As RDB
		  On RDB.sample_group_position_id = LDB.public_db_id
		Where LDB.source_id = 1
		  And LDB.submission_id = $1
		  And LDB.sample_group_id = -$2;

End $$ Language plpgsql;
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
create or replace function clearing_house.fn_clearinghouse_review_site(int, int)
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
create or replace function clearing_house.fn_clearinghouse_review_site_locations(int, int)
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
create or replace function clearing_house.fn_clearinghouse_review_site_references(int, int)
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
create or replace function clearing_house.fn_clearinghouse_review_site_natgridrefs(int, int)
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
