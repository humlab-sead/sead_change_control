-- Deploy facet: 20240404_DDL_CATEGORY_OPERATOR

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-04-04
  Description   Add category operator to facet schema
  Issue         https://github.com/humlab-sead/sead_change_control/issues/289
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    if not exists (select 1 from facet.facet_type where facet_type_id = 4) then
        insert into facet.facet_type (facet_type_id, facet_type_name, reload_as_target)
            values (4, 'rangesintersect', TRUE);
    end if;

	alter table facet.facet drop column if exists category_id_operator;

    alter table facet.facet
        add column if not exists category_id_operator varchar(40) not null DEFAULT ('=');
    
end $$;
commit;
