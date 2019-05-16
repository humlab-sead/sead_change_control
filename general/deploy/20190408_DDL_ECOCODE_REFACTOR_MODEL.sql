-- Deploy sead_db_change_control:CSR_20190408_ALTER_TYPE_ECOCODE_GROUPS to pg

/****************************************************************************************************************
  Author
  Date
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

        set client_min_messages to warning;

        if sead_utility.column_exists('public'::text, 'tbl_ecocode_definitions'::text, 'name'::text) = TRUE then
            raise exception sqlstate 'GUARD';
        end if;

        drop index if exists tbl_ecocode_groups_idx_label;
        drop index if exists tbl_ecocode_groups_idx_name;

        if sead_utility.column_exists('public'::text, 'tbl_ecocode_groups'::text, 'label'::text) = TRUE then
            alter table tbl_ecocode_definitions rename column "label" to "name";
        end if;

        alter table tbl_ecocode_groups
            drop column if exists "label",
            alter column "name" drop not null,
            alter column "name" type character varying(200),
            add column "abbreviation" character varying(255);

        create index tbl_ecocode_groups_idx_name on tbl_ecocode_groups using btree (name);

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
