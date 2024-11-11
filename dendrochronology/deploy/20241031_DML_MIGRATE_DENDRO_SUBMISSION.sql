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

    -- create or replace function sead_utility.is_integer(text) returns boolean as $apa$
    -- begin
    --     perform $1::integer;
    --     return true;
    -- exception when others then
    --     return false;
    -- end;
    -- $apa$ language plpgsql immutable;
    
 	drop view if exists encoded_dendro_analysis_values;
    drop view if exists typed_analysis_values;

	create view typed_analysis_values as 
        select analysis_value_id, 'decimal' as base_type
        from "tbl_analysis_numerical_values"
        union
        select analysis_value_id, 'decimal_range' as key
        from "tbl_analysis_numerical_ranges"
        union
        select analysis_value_id, 'integer' as key
        from "tbl_analysis_integer_values"
        union
        select analysis_value_id, 'integer_range' as key
        from "tbl_analysis_integer_ranges"
        union
        select analysis_value_id, 'category' as key
        from "tbl_analysis_categorical_values"
        union
        select analysis_value_id, 'boolean' as key
        from "tbl_analysis_boolean_values"
        union
        select analysis_value_id, 'dating_range' as key
        from "tbl_analysis_dating_ranges"
        union
        select analysis_value_id, 'taxon_count' as key
        from "tbl_analysis_value_taxon_counts";

	create or replace view encoded_dendro_analysis_values as
        with
        -- anomaly_values("analysis_value_id", "analysis_value", "corrected_value", "is_variant") as (
        --     with anomalies("value_class_id", "analysis_value", "corrected_value") as (
        --         values
        --             (6, '35 eller 11', ARRAY['35', '11']),
        --             (15, '1745 eller 1748', ARRAY['1745', '1748']),
        --             (15, 'C14-datering visar på ålder efter 951', ARRAY['E 951']),
        --             (15, 'E 1260 1260-1320', ARRAY['1260-1320']),
        --             (8, 'W eller nära W', ARRAY['W', 'nära W']),
        --             (6, '71-72', ARRAY['71', '72']),
        --             (6, '2e', ARRAY['2']),
        --             (8, 'B', ARRAY['W']),
        --             (15, 'E 1709 1710-1723', ARRAY['1710-1723']),
        --             (6, '19/37', ARRAY['19', '37']),
        --             (14, '1647 eller 1647 eller 1648 eller 1648', ARRAY['1647', '1648']),
        --             (14, '1508 ? eller 1508 ?', ARRAY['1508?', '1509?']),
        --             (14, '1137 eller 1137', ARRAY['1137-1138'])
        --         )
        --             select  "analysis_value_id",
        --                     "analysis_value",
        --                     unnest("corrected_value"),
        --                     array_length("corrected_value", 1) > 1 as "is_variant"
        --             from anomalies
        --             join tbl_analysis_values a using (value_class_id, analysis_value)
        -- ), 
        regular_expressions as (
            select  '^\d{3,4}\s*\-\s*\d{3,4}$' as regex_is_year_range,
                    '^(\d{3,4})\s*-\s*(\d{3,4})$' as regex_year_range_extract,
                    '^(-?\d+)\s*±\s*(\d+)$' as regex_plus_minus_extract,
                    '^-?\d+\s*±\s*\d+$' as regex_is_plus_minus_range,
                    '^V\s*\d{4}/\d{2,4}$' as regex_is_winter_year,
                    '(\d{4})/(\d{2,4})$' as regex_winter_year_extract,
                    '^E\s*\d{3,4}$' as regex_is_after_year,
                    '^[a-zA-ZåäöÅÄÖ]{2,}\s+\d{4}$' as regex_is_year_with_specifier,
                    '^([a-zA-ZåäöÅÄÖ]{2,})\s*(\d{4})$' as regex_year_with_specifier_extract,
                    (   
                        select format('^(%s)', string_agg(
                                regexp_replace(symbol, '(\.|\^|\$|\||\(|\)|\{|\}|\*|\+|\?|\[|\]])', '\\\1', 'g'), '|')
                            ) as symbol
                        from tbl_value_qualifier_symbols
                    ) as regex_is_qualifier
         ), analysis_entities as (
			select distinct analysis_entity_id
			from (
				select analysis_entity_id from tbl_dendro
				union
				select distinct analysis_entity_id from tbl_dendro_dates
			) as x
		 ),
         analysis_values as (
            select  vc."analysis_value_id",
                    vc."analysis_entity_id",
                    vc."value_class_id",
                    vc."analysis_value"
                    -- trim(coalesce("corrected_value", vc."analysis_value")) as analysis_value
                    --, "is_variant"
            from tbl_analysis_values vc
            join analysis_entities using (analysis_entity_id)
            -- left join anomaly_values using (analysis_value_id)
        ), analysis_values_without_uncertanty as (
            select analysis_value_id,
                analysis_value ~* '^eventuellt|\?$' as has_uncertainty_indicator,
                substring(analysis_value from '(?i)^eventuellt|\?$') as uncertainty_indicator,
                trim(case
                    when analysis_value ~* '^eventuellt|\?$' then regexp_replace(analysis_value, '(?i)^eventuellt|\?$', '', 'i')
                    else analysis_value
                end) as value_without_uncertainty
            from analysis_values
        ), analysis_values_with_flags as (
            select
                analysis_value_id,
                value_class_id,
                analysis_value,
				base_type,
                value_without_uncertainty ~* "regex_is_qualifier" or
                    value_without_uncertainty ~* "regex_is_after_year" as has_qualifier,
                case when value_without_uncertainty ~* "regex_is_qualifier"
                    then substring(value_without_uncertainty from '(?i)' || "regex_is_qualifier")
                end as qualifier,
                has_uncertainty_indicator,
                uncertainty_indicator,
                value_without_uncertainty ~ "regex_is_year_range" or value_without_uncertainty ~ "regex_is_plus_minus_range" as is_range,
                value_without_uncertainty ~ "regex_is_year_range" as is_lower_upper_range,
                value_without_uncertainty ~ "regex_is_plus_minus_range" as is_plus_minus_range,
                value_without_uncertainty ~ "regex_is_winter_year" as is_winter_year,
                value_without_uncertainty ~ "regex_is_after_year" as is_after_year,
                value_without_uncertainty ~ "regex_is_year_with_specifier" as is_year_with_specifier,
                (LENGTH(value_without_uncertainty) > 50 or vt.base_type = 'text') as is_note
                --, is_variant
            from analysis_values
            join analysis_values_without_uncertanty using (analysis_value_id)
            join tbl_value_classes vc using (value_class_id)
            join tbl_value_types vt using (value_type_id)
            cross join regular_expressions
        ), stripped_values as (
            select analysis_value_id,
                trim(case
                    when is_after_year then regexp_replace(value_without_uncertainty, '^E\s*', '', 'i')
                    when is_winter_year then  regexp_replace(value_without_uncertainty, '^V\s*', '', 'i')
                    when has_qualifier then regexp_replace(value_without_uncertainty, "regex_is_qualifier", '', 'i')
                    else value_without_uncertainty
                end) as stripped_value
            from analysis_values_with_flags f
            join analysis_values_without_uncertanty using (analysis_value_id)
            cross join regular_expressions
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
			from analysis_values_with_flags
			join stripped_values using (analysis_value_id)
		), intermediate_typed_values as (
            select analysis_value_id, lower_range_value, upper_range_value,
					plus_minus_year_value, plus_minus_value, plus_minus_qualifier,
					after_year_value, after_qualifier,
					winter_value, year_with_season_value, season_specifier
            from analysis_values_with_flags
			join stripped_values using (analysis_value_id)
            cross join regular_expressions
            left join lateral (
                select 
                    (regexp_matches(stripped_value, "regex_year_range_extract"))[1]::integer as lower_range_value,
                    (regexp_matches(stripped_value, "regex_year_range_extract"))[2]::integer as upper_range_value
                where is_lower_upper_range
            ) as lower_upper_range_table on true
            left join lateral (
                select 
					(regexp_matches(stripped_value, "regex_plus_minus_extract"))[1]::integer as plus_minus_year_value,
					(regexp_matches(stripped_value, "regex_plus_minus_extract"))[2]::integer as plus_minus_value,
					'±' as plus_minus_qualifier
                where is_plus_minus_range
            ) as plus_minus_range_table on true
            left join lateral (
                select 
                    array[
                        (regexp_matches(stripped_value, "regex_winter_year_extract"))[1]::integer,
                        (regexp_matches(stripped_value, "regex_winter_year_extract"))[2]::integer
                    ] as winter_value
                where is_winter_year
            ) as winter_table on true
            left join lateral (
                select
                    (regexp_matches(stripped_value, '^(\d{3,4})$'))[1]::integer as after_year_value,
                    'efter' as after_qualifier
                where is_after_year
            ) as after_year_table on true
            left join lateral (
                select 
                    (regexp_matches(stripped_value,  "regex_year_with_specifier_extract"))[1] as season_specifier,
                    (regexp_matches(stripped_value,  "regex_year_with_specifier_extract"))[2]::integer as year_with_season_value
                where is_year_with_specifier
            ) as year_with_specifier_table on true
         ), typed_values as (
            select analysis_value_id,
                case
                    when base_type in ('integer', 'int4range') and sead_utility.is_integer(stripped_value) then stripped_value::int
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
            from analysis_values_with_flags
            join stripped_values using (analysis_value_id)
            join intermediate_typed_values using (analysis_value_id)
		)
            select 
                analysis_value_id,
				analysis_value,
                stripped_value,
                value_class_id,
                vc.name as value_class_name,
                vt.name as value_type_name,
                vt.base_type,
                uncertainty_indicator,
                lower(coalesce(qualifier, plus_minus_qualifier, after_qualifier)) as qualifier,
                case when is_winter_year then 'V' else season_specifier end as season_specifier,
                decimal_value,
                boolean_value,
                integer_value,
				lower_range_value,
				upper_range_value,
				plus_minus_year_value,
				plus_minus_value,
                pattern
                --, is_variant
            from analysis_values_with_flags
            join value_pattern p using (analysis_value_id)
            join stripped_values ss using (analysis_value_id)
			join typed_values tv using (analysis_value_id)
            join tbl_value_classes vc using (value_class_id)
            join tbl_value_types vt using (value_type_id)
            join intermediate_typed_values using (analysis_value_id);

    /* all data */
    with dendro_lookup as (
        select dendro_lookup_id, value_class_id
        from tbl_dendro_lookup dl
        join tbl_value_classes vc using (name)
    ), dendro_date_values as (
        select analysis_entity_id, trim(format('%s %s %s',
            case
                when uncertainty != '?' then uncertainty
            end,
            case
                when age_younger is not null and age_older is not null
                    then format('%s-%s', age_older, age_younger)
                when age_younger is not null 
                    then age_younger::text
                when age_older is not null 
                    then age_older::text
            end,
            case
                when uncertainty  = '?' then '?' else ''
            end)) as dendro_value
        from tbl_dendro_dates
        left join tbl_seasons using (season_id)
        left join tbl_dating_uncertainty using (dating_uncertainty_id)
    ), existing_dendro_dates as (
        select "value_class_id", "analysis_entity_id", string_agg(distinct "dendro_value", ' eller ') as "analysis_value"
        from tbl_dendro_dates dd
        join dendro_lookup using (dendro_lookup_id)
        join dendro_date_values using ("analysis_entity_id")
        group by "analysis_entity_id", "value_class_id"

    ), existing_dendro_data as (
        select vc."value_class_id", d."analysis_entity_id", "measurement_value" as "analysis_value"
        from tbl_dendro d
        join tbl_dendro_lookup dl using (dendro_lookup_id)
        join tbl_value_classes vc using (name)
    ) 
        insert into tbl_analysis_values (
            "value_class_id", "analysis_entity_id", "analysis_value"
        )
            select d."value_class_id", d."analysis_entity_id", d."analysis_value"
            from existing_dendro_data d
            left join tbl_analysis_values av using ("analysis_entity_id")
            where av."analysis_entity_id" is null
            union all            
            select d."value_class_id", d."analysis_entity_id", d."analysis_value"
            from existing_dendro_dates d
            left join tbl_analysis_values av using ("analysis_entity_id")
            where av."analysis_entity_id" is null
            ;


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
        select analysis_value_id, /* qualifier, */ ti."value_type_item_id"
        from encoded_dendro_analysis_values av
        join tbl_value_classes vc using (value_class_id)
        join tbl_value_types vt using (value_type_id)
        join tbl_value_type_items ti using (value_type_id)
        where TRUE
        and av."base_type" = 'category'
        and upper(av."stripped_value") = upper(ti."name");


	/* YEAR RANGES */
	insert into public.tbl_analysis_dating_ranges(
		analysis_value_id, low_value, high_value, low_is_uncertain, high_is_uncertain,
		low_qualifier, high_qualifier, age_type_id, season_id, dating_uncertainty_id
	)
  		with seasons_lookup(lookup_name, season_id) as (
			values 
				('V', 16),
				('Sommar', 14),
				('Juni', 6),
				('Våren', 13),
				('Sommaren', 14),
				('Sensommaren', 14)
		)
            select analysis_value_id, plus_minus_year_value - plus_minus_value, plus_minus_year_value + plus_minus_value, false, false,
                    null, qualifier, 1 as age_type_id, null as season_id, null::int as dating_uncertainty_id -- uncertainty????
            from encoded_dendro_analysis_values
            where value_class_id in (14, 15, 17)
              and plus_minus_year_value is not null
            
            union all
            
            select analysis_value_id, lower_range_value, upper_range_value, false, false,
                    qualifier, null, 1 as age_type_id, null::int as season_id, null as dating_uncertainty_id -- uncertainty????
            from encoded_dendro_analysis_values
            where value_class_id in (14, 15, 17)
              and coalesce(lower_range_value, upper_range_value) is not null

            union all

            select analysis_value_id, integer_value, null, false, false,
                    qualifier, null, 1 as age_type_id, sl.season_id::int, null --ul.uncertainty_id
            from encoded_dendro_analysis_values
            left join seasons_lookup sl on sl."lookup_name" = "season_specifier"
            -- left join uncertainty_lookup ul on ul."lookup_name" = "uncertainty_indicator"
            where value_class_id in (14, 15, 17)
              and integer_value is not null;

    /* SP/EJ SP - SUBCLASS OF NUMBER OF SAPWOOD RINGS IN A SAMPLE */
    update tbl_analysis_values av
        set value_class_id = 23,
            boolean_value = case when upper(x."analysis_value") = 'SP' then true else false end,
            is_boolean = true
    from encoded_dendro_analysis_values x
    where TRUE
      and x."analysis_value_id" = av."analysis_value_id"
      and av."value_class_id" = 6
      and x."stripped_value" ~* '^(SP|EJ SP)$';
    
    insert into tbl_analysis_boolean_values ("analysis_value_id", "qualifier", "value")
        select av."analysis_value_id", x."qualifier", av."boolean_value"
        from tbl_analysis_values av
        join encoded_dendro_analysis_values x using (analysis_value_id)
        where TRUE
          and av."value_class_id" = 23;

    /* SPECIAL CASE: NOT DATED (BOOLEAN VALUES) */
    insert into tbl_analysis_boolean_values ("analysis_value_id", "qualifier", "value")
        select "analysis_value_id", "qualifier", True
        from encoded_dendro_analysis_values av
        where TRUE
        and value_class_id = 18
        and analysis_value is not null;

	/* FINAL: UPDATE boolean_value BASED ON INSERTED VALUES */
	update tbl_analysis_values v
		set boolean_value = b."value", is_boolean = True
	from tbl_analysis_boolean_values b
	where v."analysis_value_id" = b."analysis_value_id";

    /* SET IS_ANOMALY FLAG FOR ALL VALUES NOT IN typed_analysis_values */
    update tbl_analysis_values av
        set is_anomaly = True
    where analysis_value_id in (
        select distinct analysis_value_id
        from tbl_analysis_values av
        join tbl_value_classes vc using (value_class_id)
        join tbl_value_types vt using (value_type_id)
        left join typed_analysis_values tv using (analysis_value_id)
        where tv.analysis_value_id is null
          and av.is_undefined is null
          and av.is_indeterminable is null
          and vt.base_type <> 'text'
    );

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;

/* HELPER SQL: FIND ALL UNHANDLED VALUES

        select vc.name, av.analysis_value, count(*)
        from tbl_analysis_values av
        join tbl_value_classes vc using (value_class_id)
        join tbl_value_types vt using (value_type_id)
        left join typed_analysis_values tv using (analysis_value_id)
        where tv.analysis_value_id is null
		  and av.is_undefined is null
		  and av.is_indeterminable is null
		  and vt.base_type <> 'text'
		group by 1, 2;
*/
