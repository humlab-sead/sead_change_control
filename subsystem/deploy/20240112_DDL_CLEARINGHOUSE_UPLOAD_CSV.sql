-- Deploy subsystem: 202401012_DDL_CLEARINGHOUSE_UPLOAD_CSV

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-01-01
  Description   Added alternative upload of XML using CSV. Related to https://github.com/humlab-sead/sead_clearinghouse_import/issues/27
  Issue         https://github.com/humlab-sead/sead_change_control/issues/230
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

create or replace procedure clearing_house.fn_extract_csv_upload_to_staging_tables(p_submission_id int) as $BODY$
begin

	if not exists (
		select 1 from clearing_house.tbl_clearinghouse_submissions where submission_id = p_submission_id
	) then
		raise exception 'Submission % does not exist', p_submission_id;
	end if;
	
	if exists (
		select 1
		from clearing_house.tbl_clearinghouse_submission_xml_content_values
		where submission_id = p_submission_id
		limit 1
	) then
		raise exception 'Submission % already exists in staging', p_submission_id;
	end if;
	
	/*
	
	This function transfers submission data uploaded as CSV files to the clearing house staging tables.
	
	The clearinghouse staging tables that are populated are:
	
	| table name                                          | note                                           | 
	| ----------------------------------------------------| ---------------------------------------------- |
	| tbl_clearinghouse_submission_tables                 | Lookup for all unique tables                   |
	| tbl_clearinghouse_submission_xml_content_tables     | Tables found in the uploaded data              |
	| tbl_clearinghouse_submission_xml_content_columns    | Unique column names and types in uploaded data |
	| tbl_clearinghouse_submission_xml_content_records    | Unique records (rows) in uploaded data         |
	| tbl_clearinghouse_submission_xml_content_values	  | Values in uploaded data                        |
	 
	
	The function is an alternative to the procedures that transfers data by parsing the raw XML file
	uploaded to the clearing house primary submission table tbl_clearinghouse_submissions:

	
		clearing_house.fn_extract_and_store_submission_tables()
		clearing_house.fn_extract_and_store_submission_columns()
		clearing_house.fn_extract_and_store_submission_records()
		clearing_house.fn_extract_and_store_submission_values()

	The reason for this alternative approach is that the XML parser is not able to handle large XML files.
	
	*/

	delete from clearing_house.tbl_clearinghouse_submission_xml_content_tables where submission_id  = p_submission_id;
	delete from clearing_house.tbl_clearinghouse_submission_xml_content_columns where submission_id  = p_submission_id;
	delete from clearing_house.tbl_clearinghouse_submission_xml_content_records where submission_id  = p_submission_id;
	delete from clearing_house.tbl_clearinghouse_submission_xml_content_values where submission_id  = p_submission_id;

	
	/* insert missing tables */
	insert into clearing_house.tbl_clearinghouse_submission_tables (table_name, table_name_underscored)
		select n.table_type, sead_utility.pascal_case_to_underscore(n.table_type)
		from clearing_house.temp_submission_upload_table n
		left join clearing_house.tbl_clearinghouse_submission_tables t
		  on t.table_name = n.table_type
		where t.table_name is null;

	/* insert table rows */
	insert into clearing_house.tbl_clearinghouse_submission_xml_content_tables (submission_id, table_id, record_count)
		select p_submission_id, t.table_id, n.record_count::int
		from clearing_house.temp_submission_upload_table n
		join clearing_house.tbl_clearinghouse_submission_tables t
		  on t.table_name = n.table_type;

    insert into clearing_house.tbl_clearinghouse_submission_xml_content_columns (submission_id, table_id, column_name, column_name_underscored, data_type, fk_flag, fk_table, fk_table_underscored)
        Select	p_submission_id                                             as submission_id,
                t.table_id                                                  as table_id,
                c.column_name											    as column_name,
                clearing_house.fn_pascal_case_to_underscore(c.column_name)  as column_name_underscored,
                c.column_type                                               as data_tyoe,
                left(c.column_type, 18) = 'com.sead.database.'              as fk_flag,
                Case When left(c.column_type, 18) = 'com.sead.database.'
					Then substring(c.column_type from 19) Else Null End     as fk_table,
                clearing_house.fn_pascal_case_to_underscore(
					Case When left(c.column_type, 18) = 'com.sead.database.'
					Then substring(c.column_type from 19) Else Null End)       as fk_table_underscored
        from clearing_house.temp_submission_upload_column c
        join clearing_house.tbl_clearinghouse_submission_tables t
          on t.table_name = c.table_type;

	insert into clearing_house.tbl_clearinghouse_submission_xml_content_records(submission_id, table_id, local_db_id, public_db_id)
		select 	p_submission_id,
				t.table_id,
			   	n.system_id::numeric::int,
			  	n.public_id::numeric::int
		from clearing_house.temp_submission_upload_record n
        join clearing_house.tbl_clearinghouse_submission_tables t
          on t.table_name = n.class_name;

	insert into clearing_house.tbl_clearinghouse_submission_xml_content_values(
		submission_id, table_id, local_db_id, column_id, fk_flag, fk_local_db_id, fk_public_db_id, value)
		
		select 	p_submission_id					as submission_id,
				t.table_id 						as table_id,
				v.system_id::int				as local_db_id,
				-- v.public_id 					as public_db_id,
				c.column_id						as column_id,
				--c.column_name					as column_name,
				v.fk_system_id is not null		as fk_flag,
				v.fk_system_id::int				as fk_local_db_id,
				v.fk_public_id::int				as fk_public_db_id,
				v.column_value					as "value"		
		from clearing_house.temp_submission_upload_recordvalue v
        join clearing_house.tbl_clearinghouse_submission_tables t
          on t.table_name = v.class_name
        Join clearing_house.tbl_clearinghouse_submission_xml_content_columns c
          On /* c.submission_id = v.submission_id
         And */ c.table_id = t.table_id
         And c.column_name = v.column_name;

End $BODY$ Language plpgsql;

    
end $$;
commit;
