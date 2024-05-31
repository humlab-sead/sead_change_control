-- Deploy facet: 20240530_DML_FACET_MISSPELLING

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-05-30
  Description   Bibliography misspelled in several facets.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/105
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    update facet.facet
        set	display_title = replace(display_title, 'Bibligraphy', 'Bibliography'),
            description = replace(description, 'Bibligraphy', 'Bibliography')
        where display_title like 'Bibligraphy%'
        or description like 'Bibligraphy%';

end $$;
commit;
