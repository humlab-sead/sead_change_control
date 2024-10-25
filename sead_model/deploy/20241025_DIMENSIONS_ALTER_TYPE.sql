-- Deploy sead_model: 20241025_DIMENSIONS_ALTER_TYPE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-10-25
  Description   Increase size of descriptive field in dimensions
  Issue         https://github.com/humlab-sead/sead_change_control/issues/323
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes         This is a temporary change.
                The change has been merged into the SEAD_DATA_BASE_MODEL change request.
*****************************************************************************************************************/

begin;
do $$
begin

    perform sead_utility.store_view_definition('clearing_house', 'view_dimensions');
    perform sead_utility.store_view_definition('clearing_house', 'view_clearinghouse_dataset_measured_values');
    perform sead_utility.store_view_definition('postgrest_default_api', 'dimension');

    drop view clearing_house.view_clearinghouse_dataset_measured_values;
    drop view clearing_house.view_dimensions;
    drop view postgrest_default_api.dimension;

    alter table tbl_dimensions alter column "dimension_abbrev" type character varying(40) collate "pg_catalog"."default";

    perform sead_utility.restore_view_definition('clearing_house', 'view_dimensions');
    perform sead_utility.restore_view_definition('clearing_house', 'view_clearinghouse_dataset_measured_values');
    perform sead_utility.restore_view_definition('postgrest_default_api', 'dimension');

end $$;
commit;
