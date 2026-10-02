-- Deploy sead_model: 20260830_DDL_SUBMISSION_MODEL_REFACTOR

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2026-08-30
  Description   Improved design of SEAD schema for handling data submissions and related data
  Issue         https://github.com/humlab-sead/sead_change_control/issues/440
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes         Legacy tables are retained for audit and compatibility until their replacement views are agreed.
*****************************************************************************************************************/

set client_encoding = 'UTF8';
set client_min_messages = warning;

begin;
do $$
declare
    legacy_provider_count integer;
    migrated_provider_count integer;
    migrated_submission_count integer;
begin

    begin

        if sead_utility.table_exists('public', 'tbl_submissions') then
            raise exception SQLSTATE 'GUARD';
        end if;

        if exists (
            select 1
            from tbl_datasets
            where master_set_id is null
        ) then
            raise exception 'Cannot migrate datasets without a dataset master';
        end if;

        if not exists (select 1 from tbl_contact_types where contact_type_id = 2)
           or not exists (select 1 from tbl_contact_types where contact_type_id = 4) then
            raise exception 'Contact types 2 (Analysed by) and 4 (Samples taken by) are required';
        end if;

        select count(*) into legacy_provider_count from tbl_dataset_masters;
        create table tbl_submission_states (
            submission_state_id integer primary key,
            submission_state text not null unique,
            note text
        );

        create table tbl_data_providers (
            data_provider_id integer primary key,
            data_provider_code text unique,
            data_provider_uuid uuid not null default uuid_generate_v4() unique,
            data_provider_name text not null unique,
            notes text,
            contact_id integer references tbl_contacts(contact_id) on update cascade,
            biblio_id integer references tbl_biblio(biblio_id) on update cascade,
            url text
        );

        create table tbl_submissions (
            submission_id serial primary key,
            submission_state_id integer not null references tbl_submission_states(submission_state_id) on update cascade,
            biblio_id integer references tbl_biblio(biblio_id) on update cascade,
            upload_date date,
            submission_date date,
            submission_identifier text,
            issue_identifier text,
            author text,
            notes text,
            data_provider_id integer not null references tbl_data_providers(data_provider_id) on update cascade,
            submission_name text not null,
            source_name text,
            data_types text,
            submission_uuid uuid not null default uuid_generate_v4() unique
        );

        create table tbl_submission_task_types (
            submission_task_type_id integer primary key,
            action_task_name text not null,
            description text
        );

        create table tbl_submission_tasks (
            submission_task_id serial primary key,
            submission_task_type_id integer not null references tbl_submission_task_types(submission_task_type_id) on update cascade,
            contact_id integer not null references tbl_contacts(contact_id) on update cascade,
            submission_id integer not null references tbl_submissions(submission_id) on update cascade,
            biblio_id integer references tbl_biblio(biblio_id) on update cascade,
            event_date date,
            notes text
        );

        alter table tbl_datasets add column submission_id integer;
        alter table tbl_dataset_contacts add column event_date date;

        insert into tbl_submission_states (submission_state_id, submission_state, note)
        values
            (1, 'Pending', 'Submission is pending review'),
            (2, 'Approved', 'Submission has been approved'),
            (3, 'Rejected', 'Submission has been rejected'),
            (4, 'Pulled', 'Submission has been pulled'),
            (5, 'Future', 'Submission is scheduled for future upload');

        insert into tbl_data_providers (
            data_provider_id,
            data_provider_uuid,
            data_provider_name,
            notes,
            contact_id,
            biblio_id,
            url
        )
        select
            master_set_id,
            master_set_uuid,
            master_name,
            master_notes,
            contact_id,
            biblio_id,
            url
        from tbl_dataset_masters;

        insert into tbl_submission_task_types (
            submission_task_type_id,
            action_task_name,
            description
        )
        select
            submission_type_id,
            submission_type,
            description
        from tbl_dataset_submission_types
        where submission_type_id not in (10, 11);

        -- Historical rows cannot be reconstructed as true logical submissions. Review these provider-level seed values before deployment.
        insert into tbl_submissions (
            submission_id,
            submission_state_id,
            biblio_id,
            upload_date,
            submission_date,
            submission_identifier,
            issue_identifier,
            author,
            notes,
            data_provider_id,
            submission_name,
            source_name,
            data_types
        )
        values
            (1,  2, null, null, null, null, null, null, null, 1, 'Initial BugsCEP Submission', 'BugsCEP_20190519.mdb', 'palaeoentomology,entomology'),
            (2,  2, null, null, null, null, null, null, null, 2, 'Environmental Archaeology Lab (Umeå)/MAL', 'SEAD Java Application', 'dendrochronology'),


            (3,  2, null, null, null, null, null, null, null, 3, 'The Laboratory for Ceramic Research (Lund/KFL)', 'ceramics_data_latest_20200107.xlsx', 'ceramics'),
            /* These datasets belongs to ceramics submission
                select distinct dataset_id
                from tbl_ceramics
                join tbl_analysis_entities using (analysis_entity_id)
                join tbl_datasets using (dataset_id)
            */

            (4,  2, null, null, null, null, null, null, null, 10, 'Dendrochronology Pilot Project (Lund)', 'building_dendro_2023-12_import_v6.xlsx', 'dendrochronology'),

            
            (5,  4, null, null, null, null, null, null, null, 11, 'Isotope Pilot Project (Stockholm/KFL)', 'c14_import_20200224.xlsx', 'isotope'),
            (6,  2, null, null, null, null, null, null, 
                'SEAD Clearing House import options:'
                'check_only: false'
                'data_types: adna'
                'dbname: null'
                'explode: true'
                'filename: ./data/input/SEAD_aDNA_data_20241114_RM.xlsx'
                'host: null'
                'output_folder: ./data/output/'
                'port: 5432'
                'register: true'
                'skip: false'
                'submission_id: null'
                'table_names: null'
                'tidy_xml: false'
                'timestamp: false'
                'transfer_format: csv'
                'user: null'
                'xml_filename: null',
                12, 'SciLifelab Ancient DNA Pilot Project', 'SEAD_aDNA_data_20241114 (SEAD_aDNA_data_20241114_RM_20250121.xlsx)', 'adna'),
            (7,  2, null, null, null, null, null, null, null, 10, 'Dendrochronology Archeology', 'dendro_ark_data_latest_20191213.xlsx', 'dendrochronology'),
            (8,  2, null, null, null, null, null, null, null, 10,  'Dendrochronology Building', 'dendro_build_data_latest_20191213.xlsm', 'dendrochronology'),

            -- Lund Living Trees Dataset
            (9,  2, null, null, null, null, null, null, null, 10,  'Lund Living Trees', 'lund_living_trees_20241213.xlsx', 'dendrochronology'),

            -- Data from Stockholm, Chelsea knows more about this data
            (10, 2, null, null, null, null, null, null, null, 10,  'Isotope data', 'isotope_data_latest_20191218.xlsx', 'isotope'),

            -- Strucke dataset, pending upload
            (11,  4, null, null, null, null, null, null, null, 10,  'Strucke Data', 'AllaC14_230316_v4.xlsx', 'radiocarbon'),

            -- Arbodat dataset, pending upload
            (12,  4, null, null, null, null, null, null, null, 10,  'Arbodat Data', 'arbodat database xyz', 'archeobotany');



        update tbl_datasets
        set submission_id = master_set_id;

        alter table tbl_datasets
            alter column submission_id set not null,
            add constraint fk_datasets_submission_id
                foreign key (submission_id)
                references tbl_submissions(submission_id)
                on update cascade;

        insert into tbl_submission_tasks (
            submission_task_id,
            submission_task_type_id,
            contact_id,
            submission_id,
            biblio_id,
            event_date,
            notes
        )
        select
            source.dataset_submission_id,
            source.submission_type_id,
            source.contact_id,
            datasets.master_set_id,
            datasets.biblio_id,
            case
                when btrim(source.date_submitted) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
                    then substring(btrim(source.date_submitted) from 1 for 10)::date
                when btrim(source.date_submitted) ~ '^[0-9]{4}-[0-9]{2}$'
                    then (btrim(source.date_submitted) || '-01')::date
                when btrim(source.date_submitted) ~ '^[0-9]{4}$'
                    then (btrim(source.date_submitted) || '-01-01')::date
                else null
            end,
            source.notes
        from tbl_dataset_submissions source
        join tbl_datasets datasets on datasets.dataset_id = source.dataset_id
        where source.submission_type_id not in (10, 11);

        insert into tbl_dataset_contacts (contact_id, contact_type_id, dataset_id, event_date)
        select distinct
            source.contact_id,
            case source.submission_type_id
                when 10 then 4
                when 11 then 2
            end,
            source.dataset_id,
            case
                when btrim(source.date_submitted) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
                    then substring(btrim(source.date_submitted) from 1 for 10)::date
                when btrim(source.date_submitted) ~ '^[0-9]{4}-[0-9]{2}$'
                    then (btrim(source.date_submitted) || '-01')::date
                when btrim(source.date_submitted) ~ '^[0-9]{4}$'
                    then (btrim(source.date_submitted) || '-01-01')::date
                else null
            end
        from tbl_dataset_submissions source
        where source.submission_type_id in (10, 11)
          and not exists (
              select 1
              from tbl_dataset_contacts target
              where target.dataset_id = source.dataset_id
                and target.contact_id = source.contact_id
                and target.contact_type_id = case source.submission_type_id
                    when 10 then 4
                    when 11 then 2
                end
                and target.event_date is not distinct from case
                    when btrim(source.date_submitted) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
                        then substring(btrim(source.date_submitted) from 1 for 10)::date
                    when btrim(source.date_submitted) ~ '^[0-9]{4}-[0-9]{2}$'
                        then (btrim(source.date_submitted) || '-01')::date
                    when btrim(source.date_submitted) ~ '^[0-9]{4}$'
                        then (btrim(source.date_submitted) || '-01-01')::date
                    else null
                end
          );

        create index idx_submissions_submission_state_id on tbl_submissions(submission_state_id);
        create index idx_submissions_biblio_id on tbl_submissions(biblio_id);
        create index idx_submissions_data_provider_id on tbl_submissions(data_provider_id);
        create index idx_submission_tasks_submission_task_type_id on tbl_submission_tasks(submission_task_type_id);
        create index idx_submission_tasks_contact_id on tbl_submission_tasks(contact_id);
        create index idx_submission_tasks_submission_id on tbl_submission_tasks(submission_id);
        create index idx_submission_tasks_biblio_id on tbl_submission_tasks(biblio_id);
        create index idx_datasets_submission_id on tbl_datasets(submission_id);

        perform setval(
            pg_get_serial_sequence('tbl_data_providers', 'data_provider_id'),
            (select max(data_provider_id) from tbl_data_providers),
            true
        );
        perform setval(
            pg_get_serial_sequence('tbl_submissions', 'submission_id'),
            (select max(submission_id) from tbl_submissions),
            true
        );
        perform setval(
            pg_get_serial_sequence('tbl_submission_tasks', 'submission_task_id'),
            (select max(submission_task_id) from tbl_submission_tasks),
            true
        );

        select count(*) into migrated_provider_count from tbl_data_providers;
        select count(*) into migrated_submission_count from tbl_submissions;

        if migrated_provider_count <> legacy_provider_count then
            raise exception 'Provider migration count mismatch: expected %, migrated %', legacy_provider_count, migrated_provider_count;
        end if;

        if migrated_submission_count <> legacy_provider_count then
            raise exception 'Submission migration count mismatch: expected %, migrated %', legacy_provider_count, migrated_submission_count;
        end if;

        if (select count(*) from tbl_submission_tasks)
           <> (select count(*) from tbl_dataset_submissions where submission_type_id not in (10, 11)) then
            raise exception 'Submission task migration count mismatch';
        end if;

        if exists (
            select 1
            from tbl_dataset_submissions source
            join tbl_datasets datasets on datasets.dataset_id = source.dataset_id
            left join tbl_submission_tasks target on target.submission_task_id = source.dataset_submission_id
            where source.submission_type_id not in (10, 11)
              and (
                  target.submission_task_id is null
                  or target.submission_id <> datasets.master_set_id
                  or target.biblio_id is distinct from datasets.biblio_id
                  or target.event_date is distinct from case
                      when btrim(source.date_submitted) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
                          then substring(btrim(source.date_submitted) from 1 for 10)::date
                      when btrim(source.date_submitted) ~ '^[0-9]{4}-[0-9]{2}$'
                          then (btrim(source.date_submitted) || '-01')::date
                      when btrim(source.date_submitted) ~ '^[0-9]{4}$'
                          then (btrim(source.date_submitted) || '-01-01')::date
                      else null
                  end
              )
        ) then
            raise exception 'One or more legacy submission tasks have incorrect provider, bibliography, or event date values';
        end if;

        if exists (
            select 1
            from tbl_dataset_submissions source
            where source.submission_type_id in (10, 11)
              and not exists (
                  select 1
                  from tbl_dataset_contacts target
                  where target.dataset_id = source.dataset_id
                    and target.contact_id = source.contact_id
                    and target.contact_type_id = case source.submission_type_id
                        when 10 then 4
                        when 11 then 2
                    end
                    and target.event_date is not distinct from case
                        when btrim(source.date_submitted) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
                            then substring(btrim(source.date_submitted) from 1 for 10)::date
                        when btrim(source.date_submitted) ~ '^[0-9]{4}-[0-9]{2}$'
                            then (btrim(source.date_submitted) || '-01')::date
                        when btrim(source.date_submitted) ~ '^[0-9]{4}$'
                            then (btrim(source.date_submitted) || '-01-01')::date
                        else null
                    end
              )
        ) then
            raise exception 'One or more legacy contact events have no migrated dataset contact';
        end if;

        if exists (
            select 1
            from tbl_datasets datasets
            left join tbl_submissions submissions on submissions.submission_id = datasets.submission_id
            where submissions.submission_id is null
        ) then
            raise exception 'One or more datasets have no migrated submission';
        end if;

        comment on table tbl_dataset_masters is
            'Deprecated by tbl_data_providers. Retained temporarily for audit and compatibility. '
            'Represents a major grouping identifier for datasets, typically indicating a contributing database, project, user, or '
            'laboratory (e.g., BugsCEP, MAL, Lund Dendro Lab).';
        comment on table tbl_dataset_submissions is
            'Deprecated by tbl_submissions and tbl_submission_tasks. Retained temporarily for audit and compatibility. '
            'Contains records of various submission events related to a dataset, such as initial recording, database entries, and '
            'integrations with SEAD.';
        comment on table tbl_dataset_submission_types is
            'Deprecated by tbl_submission_task_types. Retained temporarily for audit and compatibility. '
            'Serves as a lookup for different types of dataset submissions, such as original submissions or data ingested from '
            'external databases.';

        comment on table tbl_submission_states is 'Defines the lifecycle states available to submissions.';
        comment on table tbl_data_providers is 'Stores organizations or individuals that provide submitted data.';
        comment on table tbl_submissions is 'Stores submission metadata and links each submission to its data provider.';
        comment on table tbl_submission_task_types is 'Defines the types of tasks associated with submissions.';
        comment on table tbl_submission_tasks is 'Records submission tasks and the contacts responsible for them.';
        comment on column tbl_submission_tasks.biblio_id is 'Identifies the dataset bibliography associated with a migrated legacy task, when available.';
        comment on column tbl_submission_tasks.event_date is 'Records when the submission task occurred.';
        comment on column tbl_dataset_contacts.event_date is 'Records when the dataset contact activity occurred, when known.';

        grant select on tbl_submission_states to public;
        grant select on tbl_data_providers to public;
        grant select on tbl_submissions to public;
        grant select on tbl_submission_task_types to public;
        grant select on tbl_submission_tasks to public;
        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
