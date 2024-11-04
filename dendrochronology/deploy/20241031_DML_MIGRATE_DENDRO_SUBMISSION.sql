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
        with analysis_values as (
            select analysis_value_id, analysis_entity_id, value_class_id, trim(analysis_value) as analysis_value
            from tbl_analysis_values
            join (select distinct analysis_entity_id from tbl_dendro) using (analysis_entity_id)
        ), raw_values as (
            select
                analysis_value_id,
                value_class_id,
                analysis_value,
				base_type,
                analysis_value ~* '^(<|>|=|<=|>=|~|≈|≠|≅|±|≈ but ≠|nära|före|efter|max)' or
                    analysis_value ~* '^E\s*\d{3,4}$' as has_qualifier,
                case when analysis_value ~* '^(<|>|=|<=|>=|~|≈|≠|≅|±|≈ but ≠|nära|före|efter|max)'
                    then substring(analysis_value from '(?i)^(<|>|=|<=|>=|~|≈|≠|≅|±|≈ but ≠|nära|före|efter|max)')
                end as qualifier,
                analysis_value ~* '^eventuellt|\?$' as has_uncertainty_indicator,
                substring(analysis_value from '(?i)^eventuellt|\?$') as uncertainty_indicator,
                analysis_value ~ '^\d{3,4}\s*\-\s*\d{3,4}$' or analysis_value ~ '^-?\d+\s*±\s*\d+$' as is_range,
                analysis_value ~ '^\d{3,4}\s*\-\s*\d{3,4}$' as is_lower_upper_range,
                analysis_value ~ '^-?\d+\s*±\s*\d+$' as is_plus_minus_range,
                analysis_value ~ '^V\s*\d{4}/\d{2,4}$' as is_winter_year,
                analysis_value ~ '^E\s*\d{3,4}$' as is_after_year,
                analysis_value ~ '^[a-zA-ZåäöÅÄÖ]{2,}\s+\d{4}$' as is_year_with_specifier,
                (LENGTH(analysis_value) > 50 or vt.base_type = 'text') as is_note
            from analysis_values av
            join tbl_value_classes vc using (value_class_id)
            join tbl_value_types vt using (value_type_id)
        ), stripped_values as (
            select analysis_value_id,
                trim(case
                    when is_after_year then regexp_replace(analysis_value, '^E\s*', '', 'i')
                    when is_winter_year then  regexp_replace(analysis_value, '^V\s*', '', 'i')
                    when has_qualifier and not has_uncertainty_indicator
                        then regexp_replace(analysis_value, '^(<|>|=|<=|>=|~|≈|≠|≅|±|≈ but ≠|nära|före|efter|max)', '', 'i')
                    when not has_qualifier and has_uncertainty_indicator
                        then regexp_replace(analysis_value, '(?i)^eventuellt|\?$', '', 'i')
                    when has_qualifier and has_uncertainty_indicator
                        then regexp_replace(
                                regexp_replace(analysis_value, '^(<|>|=|<=|>=|~|≈|≠|≅|±|≈ but ≠|nära|före|efter|max)', '', 'i'),
                                '(?i)^eventuellt|\?$', '', 'i'
                            )
                else analysis_value
                end) as stripped_value
            from raw_values
        ), value_pattern as (
            select 
                analysis_value_id,
				case when is_after_year then 'E YYYY'
					when is_year_with_specifier then 'SPECIFIER YYYY'
					when is_winter_year then 'V YYYY/YY'
					when is_range then 'RANGE'
					when sead_utility.is_numeric(stripped_value) then 'INTEGER'
					when lower(analysis_value) = 'undefined' then 'UNDEFINED'
					when is_note then 'NOTE' else upper(stripped_value)
			    end as "pattern"
			from raw_values
			join stripped_values using (analysis_value_id)
		), intermediate_typed_values as (
            select analysis_value_id, lower_upper_range_value,
					plus_minus_year_value, plus_minus_value, plus_minus_qualifier,
					after_year_value, after_qualifier,
					winter_value, year_with_season_value, season_specifier
            from raw_values
			join stripped_values using (analysis_value_id)
            left join lateral (
                select 
                    int4range(
                        (regexp_matches(stripped_value, '^(\d{3,4})\s*-\s*(\d{3,4})$'))[1]::integer,
                        (regexp_matches(stripped_value, '^(\d{3,4})\s*-\s*(\d{3,4})$'))[2]::integer, '[]'
                    ) as lower_upper_range_value
                where is_lower_upper_range
            ) as lower_upper_range_table on true
            left join lateral (
                select 
					(regexp_matches(stripped_value, '^(-?\d+)\s*±\s*(\d+)$'))[1]::integer as plus_minus_year_value,
					(regexp_matches(stripped_value, '^(-?\d+)\s*±\s*(\d+)$'))[2]::integer as plus_minus_value,
					'±' as plus_minus_qualifier
                where is_plus_minus_range
            ) as plus_minus_range_table on true
            left join lateral (
                select 
                    array[
                        (regexp_matches(stripped_value, '(\d{4})/(\d{2,4})$'))[1]::integer,
                        (regexp_matches(stripped_value, '(\d{4})/(\d{2,4})$'))[2]::integer
                    ] as winter_value
                where is_winter_year
            ) as winter_table on true
            left join lateral (
                select
                    (regexp_matches(stripped_value, '^(\d{3,4})$'))[1]::integer as after_year_value,
                    'E' as after_qualifier
                where is_after_year
            ) as after_year_table on true
            left join lateral (
                select 
                    (regexp_matches(stripped_value, '^([a-zA-ZåäöÅÄÖ]{2,})\s*\d{4}$'))[1] as season_specifier,
                    (regexp_matches(stripped_value, '^[a-zA-ZåäöÅÄÖ]{2,}\s*(\d{4})$'))[1]::integer as year_with_season_value
                where is_year_with_specifier
            ) as year_with_specifier_table on true
        ), typed_values as (
            select analysis_value_id,
                case
                    when base_type = 'integer' and sead_utility.is_integer(stripped_value) then stripped_value::int
                    when is_year_with_specifier then year_with_season_value
                    when after_year_value is not null then after_year_value
                    when winter_value is not null then winter_value[1]
                    else null
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
            join intermediate_typed_values using (analysis_value_id)
		)
            select 
                analysis_value_id,
				analysis_value,
                value_class_id,
                vc.name as value_class_name,
                vt.name as value_type_name,
                vt.base_type,
                uncertainty_indicator,
                coalesce(qualifier, plus_minus_qualifier, after_qualifier) as qualifier,
                season_specifier,
                decimal_value,
                boolean_value,
                integer_value,
				lower_upper_range_value,
				plus_minus_year_value,
				plus_minus_value,
                pattern
            from raw_values
            join value_pattern p using (analysis_value_id)
            join stripped_values ss using (analysis_value_id)
			join typed_values tv using (analysis_value_id)
            join tbl_value_classes vc using (value_class_id)
            join tbl_value_types vt using (value_type_id)
            join intermediate_typed_values using (analysis_value_id);

    /* all data */
    with existing_dendro_data as (
        select vc."value_class_id", d."analysis_entity_id", "measurement_value"
        from tbl_dendro d
        join tbl_dendro_lookup dl using (dendro_lookup_id)
        join tbl_value_classes vc using (name)
    )
        insert into tbl_analysis_values ("value_class_id", "analysis_entity_id", "analysis_value", "flag_value", "is_uncertain", "is_flag", "is_undefined", "is_indeterminable", "is_anomaly")
            select d."value_class_id", d."analysis_entity_id", d."measurement_value", null, null, null, null, null, null
            from existing_dendro_data d
            left join tbl_analysis_values av using ("analysis_entity_id")
            where av."analysis_entity_id" is null;


    /* SET UNDEFINED FLAG */
    update tbl_analysis_values av
        set is_undefined = True
    from encoded_dendro_analysis_values x
    where x.analysis_value_id = av.analysis_value_id
    and x.pattern = 'UNDEFINED';
    
    /* SET UNCERTAINTY FLAG */
    update tbl_analysis_values av
        set is_uncertain = True
    from encoded_dendro_analysis_values x
    where x.analysis_value_id = av.analysis_value_id
    and uncertainty_indicator is not null
    and base_type != 'text';

    /* SET INDETERMINABLE FLAG */
    update tbl_analysis_values av
        set is_indeterminable = True
    from encoded_dendro_analysis_values x
    where x.analysis_value_id = av.analysis_value_id
    and pattern = 'INDETERMINABLE';

    /* SET QUALIFIER VALUES */
    /* Currently qualifier only exists in typed data:
    update tbl_analysis_values av
        set qualifier = qualifier
    from encoded_dendro_analysis_values x
    where x.analysis_value_id = av.analysis_value_id
    and qualifier is not NULL;
    */

    /* SET ALL BOOLEAN VALUES */
    insert into tbl_analysis_boolean_values ("analysis_value_id", "qualifier", "value")
        select "analysis_value_id", "qualifier", "boolean_value"
        from encoded_dendro_analysis_values av
        where TRUE
        and "base_type" = 'boolean'
        and "boolean_value" is not null;
        
    /* ALL INTEGER VALUES */
    insert into tbl_analysis_integer_values ("analysis_value_id", "qualifier", "value")
        select analysis_value_id, qualifier, integer_value
        from encoded_dendro_analysis_values av
        where TRUE
        and base_type = 'integer'
        and pattern = 'INTEGER'
        and integer_value is not null;

    /* ALL CATEGORICAL VALUES */
    insert into tbl_analysis_categorical_values ("analysis_value_id", /*"qualifier",*/ "value_type_item_id")
        select analysis_value_id, /* qualifier, */ ti.value_type_item_id
        from encoded_dendro_analysis_values av
        join tbl_value_classes vc using (value_class_id)
        join tbl_value_types vt using (value_type_id)
        join tbl_value_type_items ti using (value_type_id)
        where TRUE
        and av.base_type = 'category'
        and upper(av.analysis_value) = upper(ti.name);

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
