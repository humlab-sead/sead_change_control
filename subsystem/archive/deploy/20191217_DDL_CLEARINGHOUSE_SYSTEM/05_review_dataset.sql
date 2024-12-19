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
Create Or Replace Function clearing_house.fn_clearinghouse_review_dataset_client_data(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_dataset_contacts_client_data(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_dataset_submissions_client_data(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_dataset_measured_values_client_data(int, int)
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
     And ae.submission_id In (0, d.submission_id)
	join clearing_house.view_physical_samples ps
	  on ps.merged_db_id = ae.physical_sample_id
     And ps.submission_id In (0, d.submission_id)
	join clearing_house.view_abundances a
	  on a.analysis_entity_id = ae.merged_db_id
     And a.submission_id In (0, d.submission_id)
	left join clearing_house.view_taxa_tree_master ttm
	  on ttm.merged_db_id = a.taxon_id
     And ttm.submission_id In (0, d.submission_id)
	left join clearing_house.view_taxa_tree_genera ttg
	  on ttg.merged_db_id =  ttm.genus_id
     And ttg.submission_id In (0, d.submission_id)
	left join clearing_house.view_taxa_tree_authors tta
	  on tta.merged_db_id =  ttm.author_id
     And tta.submission_id In (0, d.submission_id)
	left join clearing_house.view_clearinghouse_dataset_abundance_modification_types mt
	  on mt.abundance_id = a.merged_db_id
     And mt.submission_id In (0, d.submission_id)
	left join clearing_house.view_clearinghouse_dataset_abundance_ident_levels il
	  on il.abundance_id = a.merged_db_id
     And il.submission_id In (0, d.submission_id)
	left join clearing_house.view_clearinghouse_dataset_abundance_element_names ael
	  on ael.abundance_id = a.merged_db_id
     And ael.submission_id In (0, d.submission_id)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_dataset_abundance_values_client_data(int, int)
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


CREATE OR REPLACE FUNCTION clearing_house.fn_clearinghouse_review_dataset_references_client_data(
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
