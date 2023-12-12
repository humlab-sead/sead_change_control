-- Revert sead_api: 20200201_DDL_ECOCODE_GEOJSON_EXPORT
-- Deploy sead_api:20191012_DML_ECOCODE_GEOJSON_EXPORT to pg
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;



commit;


-- select sead_utility.fn_generate_ecocode_crosstab_function(2, 7)
--select *
--from sead_utility.fn_ecocode_crosstab_2_7(1, 'count')
