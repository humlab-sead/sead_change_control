-- Deploy general: 20190408_DDL_ECOCODE_REFACTOR_MODEL

/****************************************************************************************************************
  Author
  Date          2019-04-08
  Description   Alter type for columns name, abbreviation
  Issue         https://github.com/humlab-sead/sead_change_control/issues/169
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin
    set client_min_messages to warning;

    drop index if exists tbl_ecocode_groups_idx_label;
    drop index if exists tbl_ecocode_groups_idx_name;

    if sead_utility.column_exists('public'::text, 'tbl_ecocode_definitions'::text, 'label'::text) = TRUE then
        alter table tbl_ecocode_definitions rename column "label" to "name";
    end if;

    alter table tbl_ecocode_groups
        drop column if exists "label",
        alter column "name" drop not null,
        alter column "name" type character varying(200);

    if sead_utility.column_exists('public'::text, 'tbl_ecocode_groups'::text, 'abbreviation'::text) = FALSE then
        alter table tbl_ecocode_groups
            add column "abbreviation" character varying(255);
    end if;

    create index tbl_ecocode_groups_idx_name on tbl_ecocode_groups using btree (name);
end $$;
commit;
