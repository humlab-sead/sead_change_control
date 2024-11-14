-- Deploy general: 20241113_DDL_ADD_UNIQUE_CONSTRAINTS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description   Add unique constraint for alternative keys
  Issue         https://github.com/humlab-sead/sead_change_control/issues/328
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
declare
    v_table_name text;
    v_column_name text;
	v_sql text;
    v_constraint_exists boolean;
begin

    for v_table_name, v_column_name in (values
        -- ('tbl_abundance_elements', 'element_name'),
        ('tbl_activity_types', 'activity_type'),
        ('tbl_aggregate_order_types', 'aggregate_order_type'),
        ('tbl_alt_ref_types', 'alt_ref_type'),
        ('tbl_chronologies', 'chronology_name'),
        ('tbl_colours', 'colour_name'),
        ('tbl_data_type_groups', 'data_type_group_name'),
        ('tbl_data_types', 'data_type_name'),
        ('tbl_dataset_masters', 'master_name'),
        ('tbl_dating_uncertainty', 'uncertainty'),
        -- ('tbl_dimensions', 'dimension_abbrev'),
        ('tbl_ecocode_groups', 'name'),
        ('tbl_ecocode_systems', 'name'),
        -- ('tbl_feature_types', 'feature_type_name'),
        -- ('tbl_features', 'feature_name'),
        -- ('tbl_horizons', 'horizon_name'),
        ('tbl_identification_levels', 'identification_level_name'),
        ('tbl_image_types', 'image_type'),
        ('tbl_location_types', 'location_type'),
        ('tbl_method_groups', 'group_name'),
        ('tbl_methods', 'method_abbrev_or_alt_name'),
        ('tbl_modification_types', 'modification_type_name'),
        ('tbl_project_stages', 'stage_name'),
        ('tbl_project_types', 'project_type_name'),
        -- ('tbl_projects', 'project_name'),
        ('tbl_projects', 'project_abbrev_name'),
        ('tbl_record_types', 'record_type_name'),
        ('tbl_relative_age_types', 'age_type'),
        ('tbl_sample_description_types', 'type_name'),
        ('tbl_sample_group_description_types', 'type_name'),
        ('tbl_sample_location_types', 'location_type'),
        ('tbl_sample_types', 'type_name'),
        ('tbl_season_types', 'season_type'),
        ('tbl_seasons', 'season_name'),
        ('tbl_species_association_types', 'association_type_name'),
        ('tbl_units', 'unit_abbrev'),
        ('tbl_units', 'unit_name'),
        ('tbl_years_types', 'name')
    ) loop
        begin

            select exists (
                select 1
                from pg_constraint
                where conname = format('%I_%I_unique', v_table_name, v_column_name)
                and contype = 'u'
            ) into v_constraint_exists;

            if not v_constraint_exists then
			    v_sql = format('alter table %I add constraint %I_%I_unique unique (%I);', v_table_name, v_table_name, v_column_name, v_column_name);
                raise notice '%', v_sql;
                execute v_sql;
            else
                raise notice 'unique constraint %_%_unique already exists.', v_table_name, v_column_name;
            end if;
        exception
            when sqlstate '42P07' then raise notice 'unique constraint %_%_unique already exists.', v_table_name, v_column_name;
        end;
    end loop;      

end $$;
commit;
