/*****************************************************************************************************************************
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_group_client_data(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_group_lithology_client_data(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_group_references_client_data(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_group_notes_client_data(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_group_dimensions_client_data(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_group_descriptions_client_data(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_group_positions_client_data(int, int)
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
