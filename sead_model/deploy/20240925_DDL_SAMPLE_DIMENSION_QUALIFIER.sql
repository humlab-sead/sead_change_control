-- Deploy sead_model: 20240925_DDL_SAMPLE_DIMENSION_QUALIFIER
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-09-25
  Description   Add qualifier to sample dimension values
  Issue         https://github.com/humlab-sead/sead_change_control/issues/356
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes         Backported to 20240924_DDL_MEASURED_VALUES_REFACTOR
*****************************************************************************************************************/

-- set client_encoding = 'UTF8';
-- set client_min_messages = warning;
-- set role sead_master;

-- begin;
-- do $$
-- begin
--     if not sead_utility.column_exists('public', 'tbl_sample_dimensions', 'qualifier_id') then
--         alter table "tbl_sample_dimensions" add column "qualifier_id" int null references "tbl_value_qualifiers" ("qualifier_id") deferrable;
--     end if;
--     set role clearinghouse_worker;
--     call clearing_house_commit.create_or_update_clearinghouse_system(false, false, false);
-- end $$;
-- commit;
-- reset role;
