with analysis_values(analysis_value, value_class_id) as (values
	('Human', 1),
	('Human', 1),
	('Human', 1),
	('Human', 1),
	('Human', 1),
	('Human', 1),
	('Human', 1),
	('Human', 1),
	('Human', 1),
	('Human', 1),
	('hs37d5', 2),
	('hs37d5', 2),
	('hs37d5', 2),
	('hs37d5', 2),
	('hs37d5', 2),
	('hs37d5', 2),
	('hs37d5', 2),
	('hs37d5', 2),
	('hs37d5', 2),
	('hs37d5', 2),
	('1386588', 3),
	('7759404', 3),
	('6804780', 3),
	('7207754', 3),
	('2728159', 3),
	('1386588', 3),
	('7759404', 3),
	('6804780', 3),
	('7207754', 3),
	('2728159', 3),
	('106,195', 4),
	('123,915', 4),
	('96,1707', 4),
	('127,328', 4),
	('114,067', 4),
	('106,195', 4),
	('123,915', 4),
	('96,1707', 4),
	('127,328', 4),
	('114,067', 4),
	('0,0403446', 5),
	('0,274718', 5),
	('0,177701', 5),
	('0,258403', 5),
	('0,0868116', 5),
	('0,0403446', 5),
	('0,274718', 5),
	('0,177701', 5),
	('0,258403', 5),
	('0,0868116', 5),
	('3,90122', 6),
	('23,3533', 6),
	('15,8713', 6),
	('22,1253', 6),
	('8,19519', 6),
	('28,0706', 7),
	('19,1721', 7),
	('58,4709', 7),
	('27,9875', 7),
	('7,82244', 7),
	('28,0706', 7),
	('19,1721', 7),
	('58,4709', 7),
	('27,9875', 7),
	('7,82244', 7),
	('5047', 8),
	('3338', 8),
	('14116', 8),
	('4939', 8),
	('1640', 8),
	('5047', 8),
	('3338', 8),
	('14116', 8),
	('4939', 8),
	('1640', 8),
	('37615', 9),
	('409379', 9),
	('191280', 9),
	('200416', 9),
	('75773', 9),
	('37615', 9),
	('409379', 9),
	('191280', 9),
	('200416', 9),
	('75773', 9),
	('10749', 10),
	('4009', 10),
	('58649', 10),
	('54157', 10),
	('20613', 10),
	('10749', 10),
	('4009', 10),
	('58649', 10),
	('54157', 10),
	('20613', 10),
	('XY', 11),
	('XX', 11),
	('XY', 11),
	('XY', 11),
	('XY', 11),
	('XY', 11),
	('XX', 11),
	('XY', 11),
	('XY', 11),
	('XY', 11),
	('NA', 12),
	('NA', 12),
	('NA', 12),
	('NA', 12),
	('NA', 12),
	('NA', 12),
	('NA', 12),
	('NA', 12),
	('NA', 12),
	('NA', 12),
	('H46', 13),
	('H46', 13),
	('U5a1a2a', 13),
	('H3h', 13),
	('V18a', 13),
	('H46', 13),
	('H46', 13),
	('U5a1a2a', 13),
	('H3h', 13),
	('V18a', 13),
	('NA', 14),
	('NA', 14),
	('NA', 14),
	('NA', 14),
	('NA', 14),
	('NA', 14),
	('NA', 14),
	('NA', 14),
	('NA', 14),
	('NA', 14),
	('A017-002; A017-005', 15),
	('A017-001', 15),
	('NA', 15),
	('NA', 15),
	('A017-001', 15),
	('A017-002; A017-005', 15),
	('A017-001', 15),
	('NA', 15),
	('NA', 15),
	('A017-001', 15),
	('NA', 16),
	('NA', 16),
	('NA', 16),
	('NA', 16),
	('NA', 16),
	('NA', 16),
	('NA', 16),
	('NA', 16),
	('NA', 16),
	('NA', 16),
	('NA', 17),
	('NA', 17),
	('NA', 17),
	('NA', 17),
	('NA', 17),
	('NA', 17),
	('NA', 17),
	('NA', 17),
	('NA', 17),
	('NA', 17),
	('Blunt-end', 18),
	('Blunt-end', 18),
	('Blunt-end', 18),
	('Blunt-end', 18),
	('Blunt-end', 18),
	('NO', 19),
	('NO', 19),
	('NO', 19),
	('NO', 19),
	('NO', 19),
	('NO', 20),
	('NO', 20),
	('NO', 20),
	('NO', 20),
	('NO', 20),
	('NO', 21),
	('NO', 21),
	('NO', 21),
	('NO', 21),
	('NO', 21),
	('A017-001-S1L1_TAATGCG_S16_L001_merged-nova_wkflw.200124_A00181_0140_BHJL32DRXX.all', 22),
	('A017-002-S1L1_AGGTACC_S17_L001_merged-nova_wkflw.200124_A00181_0140_BHJL32DRXX.all', 22),
	('A017-003-S1L1_TGCGTCC_S18_L001_merged-nova_wkflw.200124_A00181_0140_BHJL32DRXX.all', 22),
	('A017-004-S1L1_GAATCTC_S19_L001_merged-nova_wkflw.200124_A00181_0140_BHJL32DRXX.all', 22),
	('A017-005-S1L1_CATGCTC_S20_L001_merged-nova_wkflw.200124_A00181_0140_BHJL32DRXX.all', 22),
	('29845873', 23),
	('22158349', 23),
	('25928410', 23),
	('25467576', 23),
	('28139489', 23),
	('1402787', 24),
	('8123376,00000001', 24),
	('7135441,99999999', 24),
	('7687001', 24),
	('2810528', 24),
	('4,70010376308979', 25),
	('36,66056527948', 25),
	('27,5197823545678', 25),
	('30,1834811448094', 25),
	('9,98784306282179', 25),
	('14,207146202524', 26),
	('14,2512546507757', 26),
	('18,2986281718778', 26),
	('16,5306339884696', 26),
	('14,5979331997404', 26),
	('0,815376817720723', 27),
	('0,157582266289287', 27),
	('0,429349716527722', 27),
	('0,64700134681913', 27),
	('0,430417345068258', 27),
	('0,198731', 28),
	('0,178941', 28),
	('0,170012', 28),
	('0,161888', 28),
	('0,154488', 28),
	('0,199754', 29),
	('0,177928', 29),
	('0,170301', 29),
	('0,162791', 29),
	('0,154847', 29)
) select value_class_id, string_agg(distinct 
		case
			when sead_utility.is_integer(analysis_value) then 'INTEGER'
			when sead_utility.is_numeric(replace(analysis_value, ',', '.')) then 'DECIMAL'
			else analysis_value end
		, ', ')  as patterns
  from analysis_values
  group by value_class_id

select *
from tbl_sample_alt_refs



select sead_utility.import_pending_results_chronologies('20241111_DDL_RESULTS_CHRONOLOGY');


select is_ok, count(*)
from bugs_import.results_chronology_import
where change_request = '20220916_DDL_RESULTS_CHRONOLOGY'
group by is_ok


select is_ok, count(*)
from bugs_import.results_chronology_import
where change_request = '20220916_DDL_RESULTS_CHRONOLOGY'
group by is_ok

select "AgeFrom", "AgeTo", count(*)
from bugs_import.results_chronology_import
where change_request = '20241111_DDL_RESULTS_CHRONOLOGY'
group by "AgeFrom", "AgeTo"

select change_request, case when analysis_entity_id > 0 then 'inserted' else '' end as status,  case
	when "AgeFrom" is not null and "AgeTo" is null then 'AgeFrom'
	when "AgeTo" is not null and "AgeFrom" is null then 'AgeTo'
	when "AgeTo" is null and "AgeFrom" is null then '-'
	when "AgeFrom" < "AgeTo" then 'AgeFrom < AgeTo'
	when "AgeFrom" = "AgeTo" then 'AgeFrom = AgeTo'
	when "AgeFrom" > "AgeTo" then 'AgeFrom > AgeTo'
	else 'null' end as range_type, count(*), max(error)
from bugs_import.results_chronology_import
--where not is_ok
group by 1, 2, 3
order by 1, 2, 3

select "change_request", "AgeFrom", "AgeTo",
		coalesce("AgeTo"::int, "AgeFrom"::int),
		coalesce("AgeFrom"::int, "AgeTo"::int)
		--, int4range(coalesce("AgeTo"::int, "AgeFrom"::int),coalesce("AgeFrom"::int, "AgeTo"::int) + 1)
from bugs_import.results_chronology_import
where "AgeFrom" is not null
  and "AgeTo" is not null
  and coalesce("AgeTo"::int, "AgeFrom"::int) > coalesce("AgeFrom"::int, "AgeTo"::int)

select error, count(*)
from  bugs_import.results_chronology_import
group by error

select *
from tbl_analysis_entity_ages
where age_older < age_younger


with apa as (
	select 	table_name,
        column_name,
        sead_utility.underscore_to_pascal_case(column_name, TRUE) as xml_column_name,
        ordinal_position as position,
        data_type,
        coalesce(numeric_precision, 0) as numeric_precision,
        coalesce(numeric_scale, 0) as numeric_scale,
        coalesce(character_maximum_length, 0) as character_maximum_length,
        case when is_nullable = 'YES' then true else false end as is_nullable,
        case when is_pk = 'YES' then true else false end as is_pk,
        case when is_fk = 'YES' then true else false end as is_fk,
        coalesce(t.fk_table_name, '') as fk_table_name,
        coalesce(t.fk_column_name, '') as fk_column_name,
        case
            when is_fk = 'YES' then sead_utility.underscore_to_pascal_case(t.fk_table_name)
            when data_type = 'integer' then 'java.lang.Integer'
            when data_type = 'bigint' then 'java.lang.Integer'
            when data_type = 'smallint' then 'java.lang.Short'
            when data_type = 'boolean' then	'java.lang.Boolean'
            when data_type = 'character varying' then 'java.lang.String'
            when data_type = 'text' then 'java.lang.String'
            when data_type like 'timestamp%' then 'java.util.Date'
            when data_type = 'date' then 'java.util.Date'
            when data_type = 'numeric' then 'java.math.BigDecimal'
            when data_type = 'uuid' then 'java.util.UUID'
            when data_type = 'int4range' then 'java.util.IntRange'
            when data_type = 'numrange' then 'java.util.NumRange'
            else 'error[' || data_type || ']' end as class_name
from sead_utility.table_columns t
where t.table_schema = 'public'
) select *
from apa
where class_name like 'error%'
