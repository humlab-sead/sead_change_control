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

    drop view if exists encoded_dendro_analysis_values;
    create or replace view encoded_dendro_analysis_values as
        with raw_values as (
            select av.analysis_value_id,
                value_class_id,
                trim(analysis_value) as analysis_value,
				base_type,
                trim(analysis_value) ~* '^(<|>|=|<=|>=|~|≈|≠|≅|±|≈ but ≠)' as has_qualifier,
                case when trim(analysis_value) ~* '^(<|>|=|<=|>=|~|≈|≠|≅|±|≈ but ≠)'
                    then substring(trim(analysis_value) from '^(<|>|=|<=|>=|~|≈|≠|≅|±|≈ but ≠)')
                end as qualifier,
                trim(analysis_value) ~ '[\?]$' as has_uncertainty_indicator,
                case when trim(analysis_value) ~ '[\?]$' 
                    then trim(substring(trim(analysis_value) from '([\?])$'))
                end as uncertainty_indicator,
                trim(analysis_value) ~ '^\d{3,4}\-\d{3,4}$' or trim(analysis_value) ~ '^\d+±\d+$' as is_range,
                trim(analysis_value) ~ '^V ?\d{4}/\d{2,4}$' as is_winter,
                trim(analysis_value) ~ '^E \d{3,4}$' as is_estimated_year,
                trim(analysis_value) ~ '^[a-zA-ZåäöÅÄÖ]{2,} \d{4}$' as is_year_with_specifier,
                (LENGTH(analysis_value) > 50 or vt.base_type = 'text') as is_note
            from tbl_analysis_values av
            join tbl_value_classes vc using (value_class_id)
            join tbl_value_types vt using (value_type_id)
        ), stripped_values as (
            select analysis_value_id,
                case
                    when has_qualifier and not has_uncertainty_indicator
                        then regexp_replace(analysis_value, '^(<|>|=|<=|>=|~|≈|≠|≅|±|≈ but ≠)', '', 'i')
                    when not has_qualifier and has_uncertainty_indicator
                        then regexp_replace(analysis_value, '[\?]$', '', 'i')
                    when has_qualifier and has_uncertainty_indicator
                        then regexp_replace(regexp_replace(analysis_value, '^(<|>|=|<=|>=|~|≈|≠|≅|±|≈ but ≠)', '', 'i'), '[\?]$', '', 'i')
                    else analysis_value
                end as stripped_value
            from raw_values
        ), value_pattern as (
            select 
                analysis_value_id,
					case when is_estimated_year then 'E YYYY'
					when is_year_with_specifier then 'SPECIFIER YYYY'
					when is_winter then 'V YYYY/YY'
					when is_range then 'RANGE'
					when sead_utility.is_numeric(stripped_value) then 'INTEGER'
					when lower(analysis_value) = 'undefined' then 'UNDEFINED'
					when is_note then 'NOTE' else upper(stripped_value)
			end as "pattern"
			from raw_values
			join stripped_values using (analysis_value_id)
		), typed_values as (
			select analysis_value_id,
                case when base_type = 'integer'
                    and sead_utility.is_integer(stripped_value) then stripped_value::int else null
                end as integer_value,
                case when base_type = 'numeric'
                    and sead_utility.is_numeric(stripped_value) then stripped_value::decimal(20,10) else null
                end as decimal_value,
                case when base_type = 'boolean' then
                    case when lower(stripped_value) = 'yes' then true
                        when lower(stripped_value) = 'true' then true
                        when lower(stripped_value) = 'ja' then true
                        when lower(stripped_value) = 'no' then false
                        when lower(stripped_value) = 'false' then false
                        when lower(stripped_value) = 'nej' then false 
                        else null
                    end
                else null
                end as boolean_value
			from raw_values
			join stripped_values using (analysis_value_id)
		)
            select 
                analysis_value_id,
                value_class_id,
                vc.name as value_class_name,
                vt.name as value_type_name,
                vt.base_type,
                has_uncertainty_indicator,
                uncertainty_indicator,
                has_qualifier,
                qualifier,
                integer_value,
                decimal_value,
                boolean_value,
                pattern
            from raw_values
            join value_pattern p using (analysis_value_id)
            join stripped_values ss using (analysis_value_id)
			join typed_values tv using (analysis_value_id)
            join tbl_value_classes vc using (value_class_id)
            join tbl_value_types vt using (value_type_id);
			
		
	--where base_type = 'integer'
	--group by ss."name", "value_class_id", "has_uncertainty_indicator", "value", "qualifier"
	--order by vc.value_class_id



    /* all data */
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
