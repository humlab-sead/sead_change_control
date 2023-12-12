-- Deploy sead_api: 20220923_DDL_FACET_SCHEMA_UPDATE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2022-09-23
  Description
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

        alter table facet.table_relation
            drop constraint table_relation_source_table_id_fkey,
            drop constraint table_relation_target_table_id_fkey,
            add constraint table_relation_source_table_id_fkey foreign key (source_table_id)
                references facet."table" (table_id) match simple
                on update no action
                on delete cascade,
            add constraint table_relation_target_table_id_fkey foreign key (target_table_id)
                references facet."table" (table_id) match simple
                on update no action
                on delete cascade;

        alter table facet.facet_table
            drop constraint facet_table_table_id_fkey,
            add constraint facet_table_table_id_fkey foreign key (table_id)
                references facet."table" (table_id) match simple
                on update no action
                on delete cascade;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
