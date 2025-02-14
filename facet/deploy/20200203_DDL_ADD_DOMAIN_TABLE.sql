-- Deploy sead_api: 20200203_DDL_ADD_DOMAIN_TABLE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2020-02-03
  Description   New domain facets table
  Issue         https://github.com/humlab-sead/sead_change_control/issues/149
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

        /* Add new column that enforces that facets withot picks are involved in query */
        if sead_utility.column_exists('facet', 'facet_clause', 'enforce_constraint') <> TRUE then
            alter table facet.facet_clause
                add column enforce_constraint bool not null default(FALSE);
        end if;

        -- if sead_utility.column_exists('facet'::text, 'facet_children'::text, 'facet_code'::text) = TRUE then
        --     raise exception SQLSTATE 'GUARD';
        -- end if;

    	call sead_utility.drop_table('facet.facet_children');

    	create table facet.facet_children (
    		facet_code character varying not null,
    		child_facet_code character varying not null,
    		position int not null default(0),
    		constraint fk_facet_children_facet_code_facet_code foreign key (facet_code)
    			references facet.facet (facet_code) match simple on update no action on delete no action,
    		constraint fk_facet_children_child_facet_code_facet_code foreign key (child_facet_code)
    			references facet.facet (facet_code) match simple on update no action on delete no action,
    		constraint child_facet_pkey primary key (facet_code, child_facet_code)
    	);

        /* Add new column that enforces that facets withot picks are involved in query */
        if sead_utility.column_exists('facet', 'facet_clause', 'enforce_constraint') <> TRUE then
            alter table facet.facet_clause
                add column enforce_constraint bool not null default(FALSE);
        end if;

        if sead_utility.column_exists('facet', 'result_field', 'datatype') <> TRUE then

            alter table facet.result_field
                add column datatype varchar(40) not null default('text');

            update facet.result_field set datatype = 'text' where result_field_id = 1; -- sitename, tbl_sites.site_name
            update facet.result_field set datatype = 'text' where result_field_id = 2; -- record_type, tbl_record_types.record_type_name
            update facet.result_field set datatype = 'int' where result_field_id = 3; -- analysis_entities, tbl_analysis_entities.analysis_entity_id
            update facet.result_field set datatype = 'int' where result_field_id = 4; -- site_link, tbl_sites.site_id
            update facet.result_field set datatype = 'int' where result_field_id = 5; -- site_link_filtered, tbl_sites.site_id
            update facet.result_field set datatype = 'text' where result_field_id = 6; -- aggregate_all_filtered, 'Aggregated'::text
            update facet.result_field set datatype = 'int' where result_field_id = 7; -- sample_group_link, tbl_sample_groups.sample_group_id
            update facet.result_field set datatype = 'int' where result_field_id = 8; -- sample_group_link_filtered, tbl_sample_groups.sample_group_id
            update facet.result_field set datatype = 'text' where result_field_id = 9; -- abundance, tbl_abundances.abundance
            update facet.result_field set datatype = 'int' where result_field_id = 10; -- taxon_id, tbl_abundances.taxon_id
            update facet.result_field set datatype = 'text' where result_field_id = 11; -- dataset, tbl_datasets.dataset_name
            update facet.result_field set datatype = 'int' where result_field_id = 12; -- dataset_link, tbl_datasets.dataset_id
            update facet.result_field set datatype = 'int' where result_field_id = 13; -- dataset_link_filtered, tbl_datasets.dataset_id
            update facet.result_field set datatype = 'text' where result_field_id = 14; -- sample_group, tbl_sample_groups.sample_group_name
            update facet.result_field set datatype = 'text' where result_field_id = 15; -- methods, tbl_methods.method_name
            update facet.result_field set datatype = 'int' where result_field_id = 18; -- category_id, category_id
            update facet.result_field set datatype = 'text' where result_field_id = 19; -- category_name, category_name
            update facet.result_field set datatype = 'decimal' where result_field_id = 20; -- latitude_dd, latitude_dd
            update facet.result_field set datatype = 'decimal' where result_field_id = 21; -- longitude_dd, longitude_dd

        end if;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
