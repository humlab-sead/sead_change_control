-- Deploy general: 20190410_DDL_COMMENTS_UPDATE_COMMENTS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
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

        create or replace view sead_utility.sead_comments as
            select schema_name, table_name, column_name, objsubid, description::varchar(2048)
            from (
                select pg_namespace.nspname as schema_name, pg_class.relname as table_name, '' as column_name, objsubid, pg_description.description
                from pg_description
                join pg_class on pg_description.objoid = pg_class.oid
                join pg_namespace on pg_class.relnamespace = pg_namespace.oid
                union all
                select c.table_schema, c.table_name, c.column_name, objsubid, d.description
                from pg_description d
                join information_schema.columns c
                   on (c.table_schema || '.' || c.table_name)::regclass = d.objoid
                   and c.ordinal_position = d.objsubid
            ) as c
            where coalesce(description, '') <> ''
              and schema_name = 'public'
            order by schema_name, table_name, column_name;


        comment on table public.tbl_chronologies is 'Constraint removed to obsolete table (tbl_age_types), replaced by non-binding id of relative_age_types - but not fully implemented. Notes should be used to inform on chronology years types and construction.';
        comment on column public.tbl_sites.site_location_accuracy is 'Accuracy of highest location resolution level. E.g. Nearest settlement, lake, bog, ancient monument, approximate';

        comment on column public.tbl_chronologies.relative_age_type_id is 'Constraint removed to obsolete table (tbl_age_types), replaced by non-binding id of relative_age_types - but not fully implemented. Notes should be used to inform on chronology years types and construction.';
        comment on column public.tbl_relative_ages.abbreviation is 'Standard abbreviated form of name if available';

        comment on table public.tbl_sites is 'Accuracy of highest location resolution level. E.g. Nearest settlement, lake, bog, ancient monument, approximate';

        comment on table public.tbl_analysis_entity_ages is '20170911PIB: Changed numeric ranges of values to 20,5 to match tbl_relative_ages
20120504PIB: Should this be connected to physical sample instead of analysis entities? Allowing multiple ages (from multiple dates) for a sample. At the moment it requires a lot of backtracing to find a sample''s age... but then again, it allows... what, exactly?';

        comment on table public.tbl_analysis_entity_prep_methods is '20170907PIB: Devolved due to problems in isolating measurement datasets with pretreatment/without. Many to many between datasets and methods used as replacement.
20120506PIB: created to cater for multiple preparation methods for analysis but maintaining simple dataset concept.';

        comment on table public.tbl_chronologies is  '20170911PIB: Removed Not Null requirement for sample-group_id to allow for chronologies not tied to a single sample group (e.e. calibrated ages for DataArc or other projects)
Increased length of some fields.
20120504PIB: Note that the dropped age type recorded the type of dates (C14 etc) used in constructing the chronology... but is only one per chonology enough? Can a chronology not be made up of mulitple types of age? (No, years types can only be of one sort - need to calibrate if mixed?)';

        comment on table public.tbl_relative_dates is  '20120504PIB: Added method_id to store dating method used to attribute sample to period or calendar date (e.g. strategraphic dating, typological)
20130722PIB: added field dating_uncertainty_id to cater for "from", "to" and "ca." etc. especially from import of BugsCEP
20170906PIB: removed fk physical_samples_id and replaced with analysis_entity_id';

        -- comment on view public.view_taxa_alphabetically is 'Lists full taxonomic tree in alphabetical order';

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
