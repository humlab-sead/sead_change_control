
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_alternative_names(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_features(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_notes(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_dimensions(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_descriptions(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_horizons(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_colours(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_images(int, int)
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
Create Or Replace Function clearing_house.fn_clearinghouse_review_sample_locations(int, int)
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
  language plpgsql;