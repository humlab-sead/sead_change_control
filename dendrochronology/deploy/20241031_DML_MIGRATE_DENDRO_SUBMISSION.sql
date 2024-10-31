-- Deploy dendrochronology: 20241031_DML_MIGRATE_DENDRO_SUBMISSION

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-10-31
  Description   Migrate old dendro data to new refactored model.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/326
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    begin
    
	with existing_dendro_data as (
		select vc.value_class_id, d.analysis_entity_id, measurement_value
		from tbl_dendro d
		join tbl_dendro_lookup dl using (dendro_lookup_id)
		join tbl_value_classes vc using (name)
	)
		insert into tbl_analysis_values (value_class_id, analysis_entity_id, analysis_value, flag_value, is_uncertain, is_flag, is_undefined, is_indeterminable, is_anomaly)
			select value_class_id, analysis_entity_id, measurement_value, null, null, null, null, null, null
			from existing_dendro_data;
                    
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
