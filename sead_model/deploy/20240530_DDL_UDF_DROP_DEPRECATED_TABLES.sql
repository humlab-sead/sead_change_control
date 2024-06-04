-- Deploy sead_model: 20240530_DDL_UDF_DROP_DEPRECATED_TABLES

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-05-30
  Description   Drop deprecated dendro/ceramics tables
  Issue         https://github.com/humlab-sead/sead_change_control/issues/70
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
	declare v_drop_script text;
begin	
	
	v_drop_script = sead_utility.generate_drop_table_script('tbl_ceramic_measurements');

	if v_drop_script is not null then
		execute v_drop_script;
	end if;

	v_drop_script = sead_utility.generate_drop_table_script('tbl_dendro_measurements');

	if v_drop_script is not null then
		execute v_drop_script;
	end if;

end $$;

commit;
