-- Deploy utility: 20250526_COUNTRY_CODES

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2025-05-26
  Description   Country codes https://r2.datahub.io/clt98ab600006l708tkbrtzel/main/raw/data.csv
  Issue         https://github.com/humlab-sead/sead_change_control/issues/383
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;


drop table if exists sead_utility.country_codes;
create table sead_utility.country_codes (
    code varchar(2) not null unique,
    name text not null
);

\cd /repo/utility/deploy

\copy sead_utility.country_codes (name, code) from '20250526_COUNTRY_CODES/country_codes.csv' with (HEADER, FORMAT text, DELIMITER E',', ENCODING 'utf-8');

commit;
