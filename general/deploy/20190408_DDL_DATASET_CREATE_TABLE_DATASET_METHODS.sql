-- Deploy general: 20190408_DDL_DATASET_CREATE_TABLE_DATASET_METHODS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-08
  Issue         https://github.com/humlab-sead/sead_change_control/issues/167
  Description   Add new table
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

            --if sead_utility.table_exists('public'::text, 'tbl_dataset_methods'::text) = false then
            --    raise exception sqlstate 'GUARD';
            --end if;

            create table if not exists tbl_dataset_methods (
                 dataset_method_id serial primary key,
                 dataset_id int4 not null,
                 method_id int4 not null,
                 date_updated timestamp with time zone default now(),
                 constraint "fk_tbl_dataset_methods_to_tbl_datasets" foreign key ("dataset_id")
                    references tbl_datasets ("dataset_id") on delete no action on update no action,
                 constraint "fk_tbl_dataset_methods_to_tbl_methods" foreign key ("method_id")
                    references tbl_methods ("method_id") on delete no action on update no action
            );

            alter table tbl_dataset_methods owner to "sead_master";

        exception when sqlstate 'GUARD' then
            raise notice 'already executed';
        end;

    end $$ language plpgsql;

commit;
