-- Deploy adna: 20250402_DML_ADNA_EXPLODE_ANALYSIS_VALUES

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2025-04-02
  Description   Explodes untyped analysis values to typed tables
  Issue         https://github.com/humlab-sead/sead_change_control/issues/372
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes        
  
    * This script handles the explosion of untyped analysis values in aDNA pilot project into typed tables
    * The data only contains `decimal`, `integer`, and `category` values.
    * The following table shows unique values per value class and value type.
    * The data contains no anomalies, indeterminable values, uncertain values or qualified values.
    * The data is inserted into the following tables:
      * tbl_analysis_integer_values
      * tbl_analysis_categorical_values
      * tbl_analysis_decimal_values

  | value_class                            | value_type          | base_type | unique values                                                                                           |
  |----------------------------------------|---------------------|-----------|------------------------------------------------------------------------------------------------------|
  | 3’ damage                              | Measurement         | decimal   | 0.154847 , 0.162791 , 0.170301 , 0.177928 , 0.199754                                                 |
  | 5’ damage                              | Measurement         | decimal   | 0.154488 , 0.161888 , 0.170012 , 0.178941 , 0.198731                                                 |
  | Average depth of coverage - genome (x) | Measurement         | decimal   | 0.0403446 , 0.0868116 , 0.177701 , 0.258403 , 0.274718                                               |
  | Average depth of coverage - mtDNA (x)  | Measurement         | decimal   | 19.1721 , 27.9875 , 28.0706 , 58.4709 , 7.82244                                                      |
  | Average read length                    | Measurement         | decimal   | 106.195 , 114.067 , 123.915 , 127.328 , 96.1707                                                      |
  | Breadth of coverage - genome (%)       | Percentage          | decimal   | 15.8713 , 22.1253 , 23.353299999999997 , 3.9012199999999995 , 8.19519                                |
  | Damage treatment(s)                    | Damage treatment    | category  | NO                                                                                                   |
  | Duplicate reads (%)                    | Percentage          | decimal   | 14.207146202524 , 14.2512546507757 , 14.5979331997404 , 16.5306339884696 , 18.2986281718778          |
  | Endogenous reads (filtered)            | Count               | integer   | 1386588 , 2728159 , 6804780 , 7207754 , 7759404                                                      |
  | Endogenous reads (raw)                 | BigCount            | integer   | 1402786.9999999995 , 2810528.0000000005 , 7135441.9999999935 , 7687001.000000004 , 8123376.000000006 |
  | Library preparation(s)                 | Library preparation | category  | Blunt-end                                                                                            |
  | Merged reads                           | Count               | integer   | 22158349 , 25467576 , 25928410 , 28139489 , 29845873                                                 |
  | Molecular sex - Rx                     | Molecular sex       | category  |                                                                                                      |
  | Molecular sex - Ry                     | Molecular sex       | category  | XX , XY                                                                                              |
  | mtDNA reads                            | BigCount            | integer   | 14116 , 1640 , 3338 , 4939 , 5047                                                                    |
  | Raw endogenous content (%)             | Percentage          | decimal   | 27.519782354567802 , 30.1834811448094 , 36.660565279480004 , 4.70010376308979 , 9.98784306282179     |
  | Short reads (%)                        | Percentage          | decimal   | 0.157582266289287 , 0.429349716527722 , 0.430417345068258 , 0.64700134681913 , 0.815376817720723     |
  | SNP capture                            | SNP capture         | category  | NO                                                                                                   |
  | X chromosome reads                     | BigCount            | integer   | 191280 , 200416 , 37615 , 409379 , 75773                                                             |
  | Y chromosome reads                     | Count               | integer   | 10749 , 20613 , 4009 , 54157 , 58649                                                                 |

*****************************************************************************************************************/


set client_min_messages = warning;

begin transaction;

do $$
begin

	create or replace view adna_analysis_values as
       with
            datasets as (
                select dataset_id
                from tbl_datasets ds
                where TRUE
                and ds.method_id in (
                    select m.method_id
                    from tbl_methods m
                    join tbl_record_types r using (record_type_id)
                    where r.record_type_name = 'DNA'
                )
                and ds.project_id in (
                    select project_id
                    from tbl_projects
                    where project_name = 'SciLifeLab Ancient DNA Unit project 017'
                )
            ),
            analysis_entities as (
                select analysis_entity_id
                from tbl_analysis_entities ae
                join datasets using (dataset_id)
            ),
            analysis_values as (
				select av.analysis_value_id, av.analysis_entity_id, av.value_class_id, av.analysis_value, vt.base_type
				from tbl_analysis_values av
				join tbl_value_classes vs using (value_class_id)
				join tbl_value_types vt using (value_type_id)
				join analysis_entities using (analysis_entity_id)
            ),
            typed_values as (
				select analysis_value_id,
					case when base_type = 'integer' then
                        case when sead_utility.is_integer(analysis_value) then
                            analysis_value::int
                        when sead_utility.is_numeric(analysis_value) then
                            round(analysis_value::decimal(20,10))::int
                        else
                            null
                        end
						else null
					end as integer_value,
					case when base_type = 'integer' and not sead_utility.is_integer(analysis_value) and not sead_utility.is_numeric(analysis_value) then TRUE else null
					end as integer_is_anomaly,
					case when base_type = 'decimal'
						and sead_utility.is_numeric(analysis_value) then analysis_value::decimal(20,10) else null
					end as decimal_value,
					case when base_type = 'decimal' and not sead_utility.is_numeric(analysis_value) then TRUE else null
					end as decimal_is_anomaly
				from analysis_values
			)
            select 
				analysis_value_id,
				analysis_value,
				value_class_id,
				vc.name as value_class_name,
				vt.name as value_type_name,
				vt.base_type,
				decimal_value,
				decimal_is_anomaly,
				integer_value,
				integer_is_anomaly
            from analysis_values
			join typed_values tv using (analysis_value_id)
            join tbl_value_classes vc using (value_class_id)
            join tbl_value_types vt using (value_type_id);

    /* FLAGS */
    update tbl_analysis_values av
        set is_undefined = false,
            is_uncertain = false,
            is_indeterminable = false
    from adna_analysis_values x
    where x.analysis_value_id = av.analysis_value_id;

    /* INTEGER VALUES */
    delete from tbl_analysis_integer_values
        where analysis_value_id in (select analysis_value_id from adna_analysis_values);

    insert into tbl_analysis_integer_values ("analysis_value_id", "value")
        select analysis_value_id, integer_value
        from adna_analysis_values av
        where TRUE
          and base_type = 'integer'
          and integer_value is not null;

    /* DECIMAL VALUES */
    delete from tbl_analysis_numerical_values
        where analysis_value_id in (select analysis_value_id from adna_analysis_values);
		
    insert into tbl_analysis_numerical_values ("analysis_value_id", "value")
        select analysis_value_id, decimal_value
        from adna_analysis_values av
        where TRUE
          and base_type = 'decimal'
          and decimal_value is not null;

    /* IDENTIFIERS */
    delete from tbl_analysis_identifiers
        where analysis_value_id in (select analysis_value_id from adna_analysis_values);

    insert into tbl_analysis_identifiers ("analysis_value_id", "value")
        select analysis_value_id, analysis_value
        from adna_analysis_values av
		join tbl_value_classes vc using (value_class_id)
		join tbl_value_types vt using (value_type_id)
        where TRUE
          and value_type_name = 'Identifier'
          and analysis_value is not null;
		  
    /* CATEGORICAL VALUES */
    delete from tbl_analysis_categorical_values
        where analysis_value_id in (select analysis_value_id from adna_analysis_values);

    insert into tbl_analysis_categorical_values ("analysis_value_id", /*"qualifier",*/ "value_type_item_id")
        select analysis_value_id, /* qualifier, */ ti."value_type_item_id"
        from adna_analysis_values av
        join tbl_value_classes vc using (value_class_id)
        join tbl_value_types vt using (value_type_id)
        join tbl_value_type_items ti using (value_type_id)
        where TRUE
          and av."base_type" = 'category'
          and upper(av."analysis_value") = upper(ti."name");

    update tbl_analysis_values
        set is_anomaly = true
    from adna_analysis_values x
    where x.analysis_value_id = tbl_analysis_values.analysis_value_id
      and (x.decimal_is_anomaly = true or x.integer_is_anomaly = true);

end $$;

commit;

-- select *
-- from adna_analysis_values
-- left join typed_analysis_values using (analysis_value_id)
-- where typed_analysis_values.analysis_value_id is null
--   and analysis_value is not null
--   and not (value_type_name = 'Note')
