
/*****************************************************************************************************************************
**	Function	xml_transfer_bulk_upload
**	Who			Roger Mähler
**	When		2017-10-26
**	What
**	Uses
**	Used By     DEPRECATED NOT USED!
**	Revisions
******************************************************************************************************************************/
-- Select * from clearing_house.tbl_clearinghouse_submissions where not xml is null
-- Select clearing_house.xml_transfer_bulk_upload(1)
create or replace function clearing_house.xml_transfer_bulk_upload(p_submission_id int = null, p_xml_id int = null, p_upload_user_id int = 4)
Returns int As $$
Begin

  raise error "This function is deprecated and should not be used!";

  Return Null;

	-- p_xml_id = Coalesce(p_xml_id, (Select Max(ID) from clearing_house.tbl_clearinghouse_xml_temp));
	-- If p_submission_id Is Null Then

  --       Select Coalesce(Max(submission_id),0) + 1
  --       Into p_submission_id
  --       From clearing_house.tbl_clearinghouse_submissions;

  --       Insert Into clearing_house.tbl_clearinghouse_submissions(
  --           submission_id, submission_state_id, data_types, upload_user_id,
  --           upload_date, upload_content, xml, status_text, claim_user_id, claim_date_time
  --       )
  --           Select p_submission_id, 1, 'Undefined other', p_upload_user_id, now(), null, xmldata, 'New', null, null
  --           From clearing_house.tbl_clearinghouse_xml_temp
  --           Where id = p_xml_id;
  --   Else
	-- 	Update clearing_house.tbl_clearinghouse_submissions
  --       	Set XML = X.xmldata
  --       From clearing_house.tbl_clearinghouse_xml_temp X
  --       Where clearing_house.tbl_clearinghouse_submissions.submission_id = p_submission_id
  --         And X.id = p_xml_id;
  --   End If;
  --   Return p_submission_id;
End $$ Language plpgsql;
