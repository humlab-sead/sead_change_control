-- Deploy mal: 20240601_DML_BIBLIO_EMPTY_YEARS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-06-01
  Description   Update bibligraphic entries with empty year with year found in reference
  Issue         https://github.com/humlab-sead/sead_change_control/issues/291
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    with extracted_years as (
        select biblio_id, (regexp_matches(full_reference, '(17[0-9]{2}|18[0-9]{2}|19[0-9]{2}|20[0-9]{2})'))[1] AS year
        from tbl_biblio
        where year is null
        and full_reference ~ '17[0-9]{2}|18[0-9]{2}|19[0-9]{2}|20[0-9]{2}' 
    )
        update tbl_biblio
        set year = extracted_years.year
        from extracted_years
        where extracted_years.biblio_id = tbl_biblio.biblio_id;
    
end $$;
commit;
