-- Deploy general: 20170906_DDL_RELATIVE_DATES_ALTER_RELATION

begin;
do $$
begin
	begin

        set client_min_messages to warning;

        if sead_utility.column_exists('public'::text, 'tbl_relative_dates'::text, 'analysis_entity_id'::text) = TRUE then
            raise exception sqlstate 'GUARD';
        end if;

        if (select count(*) from tbl_relative_dates) > 0 then
            raise exception 'Table tbl_relative_dates contains data. Cannot deploy requested DDL change since data will be lost.';
            -- todo update is not deterministic
        end if;

        alter table tbl_relative_dates
            add column analysis_entity_id int4 not null,
            add constraint "fk_tbl_relative_dates_to_tbl_analysis_entities" foreign key (analysis_entity_id) references tbl_analysis_entities (analysis_entity_id) on delete no action on update no action;

        alter table tbl_relative_dates
            drop constraint if exists "fk_relative_dates_physical_sample_id",
            drop column if exists "physical_sample_id";

        comment on table "public"."tbl_relative_dates" is '20120504PIB: Added method_id to store dating method used to attribute sample to period or calendar date (e.g. strategraphic dating, typological)
20130722PIB: added field dating_uncertainty_id to cater for "from", "to" and "ca." etc. especially from import of BugsCEP
20170906PIB: removed fk physical_samples_id and replaced with analysis_entity_id';

    exception when SQLSTATE 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
