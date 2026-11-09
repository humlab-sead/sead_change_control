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
  Notes         Legacy tables are retained for backward compatibility.
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

        if not exists (select 1 from tbl_contact_types where contact_type_id = 2)
           or not exists (select 1 from tbl_contact_types where contact_type_id = 4) then
            raise exception 'Contact types 2 (Analysed by) and 4 (Samples taken by) are required';
        end if;

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
            submission_state_id integer null references tbl_submission_states(submission_state_id) on update cascade,
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

        alter table tbl_datasets
            add column submission_id integer null
                references tbl_submissions(submission_id) on update cascade;

        alter table tbl_dataset_contacts
            add column event_date date;

        create index idx_submissions_submission_state_id on tbl_submissions(submission_state_id);
        create index idx_submissions_biblio_id on tbl_submissions(biblio_id);
        create index idx_submissions_data_provider_id on tbl_submissions(data_provider_id);
        create index idx_submission_tasks_submission_task_type_id on tbl_submission_tasks(submission_task_type_id);
        create index idx_submission_tasks_contact_id on tbl_submission_tasks(contact_id);
        create index idx_submission_tasks_submission_id on tbl_submission_tasks(submission_id);
        create index idx_submission_tasks_biblio_id on tbl_submission_tasks(biblio_id);
        create index idx_datasets_submission_id on tbl_datasets(submission_id);


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


        comment on table tbl_submission_states is
            'Defines the lifecycle states available to submissions.';
        comment on column tbl_submission_states.submission_state_id is
            'Identifies the submission state.';
        comment on column tbl_submission_states.submission_state is
            'Name of the submission lifecycle state.';
        comment on column tbl_submission_states.note is
            'Additional explanation or guidance for the submission state.';

        comment on table tbl_data_providers is
            'Stores organizations or individuals that provide submitted data.';
        comment on column tbl_data_providers.data_provider_id is
            'Identifies the data provider.';
        comment on column tbl_data_providers.data_provider_code is
            'Optional code used to identify the data provider in an external or local system.';
        comment on column tbl_data_providers.data_provider_uuid is
            'Unique UUID generated for the data provider.';
        comment on column tbl_data_providers.data_provider_name is
            'Name of the organization or individual that provides data.';
        comment on column tbl_data_providers.notes is
            'Additional information about the data provider.';
        comment on column tbl_data_providers.contact_id is
            'Identifies the contact person associated with the data provider.';
        comment on column tbl_data_providers.biblio_id is
            'Identifies the bibliography entry associated with the data provider.';
        comment on column tbl_data_providers.url is
            'Web address for the data provider.';

        comment on table tbl_submissions is
            'Stores submission metadata and links each submission to its data provider.';
        comment on column tbl_submissions.submission_id is
            'Primary key (automatically incremented).';
        comment on column tbl_submissions.submission_state_id is
            'Identifies the lifecycle state assigned to the submission.';
        comment on column tbl_submissions.biblio_id is
            'Identifies a publication or reference associated with the submission.';
        comment on column tbl_submissions.upload_date is
            'Date on which files for the submission were uploaded.';
        comment on column tbl_submissions.submission_date is
            'Date on which the submission was made to SEAD.';
        comment on column tbl_submissions.submission_identifier is
            'Identifier assigned to the submission by the data provider or source system, when available.';
        comment on column tbl_submissions.issue_identifier is
            'Identifier of the issue or ticket used to track work on this submission, when available.';
        comment on column tbl_submissions.author is
            'Name of the person or organization credited as author of the submitted data.';
        comment on column tbl_submissions.notes is
            'Additional information about the submission.';
        comment on column tbl_submissions.data_provider_id is
            'Identifies the provider that supplied the data.';
        comment on column tbl_submissions.submission_name is
            'Name or title used to identify the submission.';
        comment on column tbl_submissions.source_name is
            'Name of the source from which the submitted data originated.';
        comment on column tbl_submissions.data_types is
            'Types of data included in the submission.';
        comment on column tbl_submissions.submission_uuid is
            'Unique UUID generated for the submission.';

        comment on table tbl_submission_task_types is
            'Defines the types of tasks associated with submissions.';
        comment on column tbl_submission_task_types.submission_task_type_id is
            'Identifies the submission task type.';
        comment on column tbl_submission_task_types.action_task_name is
            'Name of the action performed as part of a submission task.';
        comment on column tbl_submission_task_types.description is
            'Description of the action or task type.';

        comment on table tbl_submission_tasks is
            'Records submission tasks and the contacts responsible for them.';
        comment on column tbl_submission_tasks.submission_task_id is
            'Primary key (automatically incremented).';
        comment on column tbl_submission_tasks.submission_task_type_id is
            'Identifies the type of task performed.';
        comment on column tbl_submission_tasks.contact_id is
            'Identifies the contact responsible for the task.';
        comment on column tbl_submission_tasks.submission_id is
            'Identifies the submission to which the task belongs.';
        comment on column tbl_submission_tasks.biblio_id is
            'Identifies the dataset bibliography associated with a migrated legacy task, when available.';
        comment on column tbl_submission_tasks.event_date is
            'Records when the submission task occurred.';
        comment on column tbl_submission_tasks.notes is
            'Additional information about the submission task.';

        comment on column tbl_dataset_contacts.event_date is
            'Records when the dataset contact activity occurred, when known.';
        comment on column tbl_datasets.submission_id is
            'Identifies the submission associated with this dataset.';
            
        grant select on tbl_submission_states to public;
        grant select on tbl_data_providers to public;
        grant select on tbl_submissions to public;
        grant select on tbl_submission_task_types to public;
        grant select on tbl_submission_tasks to public;

        /* Add initial lookup values for submission states and task types */
        
        insert into tbl_submission_states (submission_state_id, submission_state, note)
            values
                (1, 'Pending', 'Submission is pending review'),
                (2, 'Approved', 'Submission has been approved'),
                (3, 'Rejected', 'Submission has been rejected'),
                (4, 'Pulled', 'Submission has been pulled'),
                (5, 'Future', 'Submission is scheduled for future upload');

        insert into tbl_submission_task_types ( submission_task_type_id, action_task_name, description )
            select submission_type_id, submission_type, description
            from tbl_dataset_submission_types
            where submission_type_id not in (10, 11);
        

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
