-- Deploy sead_api:20191012_DML_ECOCODE_GEOJSON_EXPORT to pg
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


create or replace function sead_utility.fn_sample_ecocode_abundances(
    v_ecocode_system_id int,
    v_ecocode_group_id int,
    v_master_set_id int)
    returns table (
        physical_sample_id int,
        ecocode_name character varying,
        abundance_count int,
        abundance_sum int
    )
as $BODY$
begin
    return query
    with ecocodes as (
        /* This is all unique ecocode names within selected system and group (used in cross join) */
        select ed.name as ecocode_name
        from tbl_ecocode_definitions ed
        join tbl_ecocode_groups eg using (ecocode_group_id)
        where eg.ecocode_system_id = v_ecocode_system_id
          and eg.ecocode_group_id = v_ecocode_group_id
        -- select unnest(v_ecocodes) as ecocode_name
    ), taxon_ecocodes as (
        /* This is just a taxon to eco-code mapping (for selected system and group) */
        select taxon_id, ed.name as ecocode_name
        from tbl_ecocode_groups eg
        join tbl_ecocode_definitions ed using (ecocode_group_id)
        join tbl_ecocodes e using (ecocode_definition_id)
        where eg.ecocode_system_id = v_ecocode_system_id
          and eg.ecocode_group_id = v_ecocode_group_id
    ), samples as (
        /* Only consider samples that belong to specified master dataset */
        select distinct samples.physical_sample_id
        from tbl_physical_samples samples
        join tbl_analysis_entities using (physical_sample_id)
        join tbl_datasets using (dataset_id)
        join tbl_dataset_masters using (master_set_id)
        where tbl_dataset_masters.master_set_id = v_master_set_id
          -- and tbl_dataset_masters.master_name =  'Bugs database'
    ), sample_ecocode_abundances as (
        /* Compute count and sum by sample and ecocode */
        select samples.physical_sample_id, taxon_ecocodes.ecocode_name, count(abundance_id) as abundance_count, sum(abundance) as abundance_sum
        from samples
        join tbl_analysis_entities using (physical_sample_id)
        join tbl_abundances using (analysis_entity_id)
        join taxon_ecocodes using (taxon_id)
        group by samples.physical_sample_id, taxon_ecocodes.ecocode_name
    ) select x.physical_sample_id,
             x.ecocode_name::character varying(150),
             coalesce(sample_ecocode_abundances.abundance_count, 0)::int,
             coalesce(sample_ecocode_abundances.abundance_sum, 0)::int
      from (
          select samples.physical_sample_id, ecocodes.ecocode_name
          from samples
          cross join ecocodes
      ) as x
      left join sample_ecocode_abundances using (physical_sample_id, ecocode_name);
end $BODY$ language plpgsql;

-- drop function if exists sead_utility.fn_generate_ecocode_crosstab_function(int, int);
create or replace function sead_utility.fn_generate_ecocode_crosstab_function(
    p_ecocode_system_id int,
    p_ecocode_group_id int
) returns text
as $$
declare
    v_ecocodes character varying[];
    v_fields text;
    v_typed_fields text;
    v_cx_sql text;
    v_data_sql text;
    v_category_sql text;
    v_udf_sql text;
    v_udf_name text;
begin
    v_ecocodes = (
        select array_agg(ed.name order by ed.name )
        from tbl_ecocode_definitions ed
        join tbl_ecocode_groups eg using (ecocode_group_id)
        where eg.ecocode_system_id = p_ecocode_system_id
          and eg.ecocode_group_id = p_ecocode_group_id
    );

    /* Generate list of EcoCode field names for selected system and group */
    v_fields = array_to_string(array(select 'cx."' || ecocode_name || '" ' from unnest(v_ecocodes) as ecocode_name), ', '::text);

    /* Generate list of typed EcoCode field names for selected system and group */
    v_typed_fields = array_to_string(array(select '"' || ecocode_name || '" int' from unnest(v_ecocodes) as ecocode_name), ', '::text);

    /* Generate list of EcoCode names as string values. This specifies categories in crosstab (i.e. columns) */
    v_category_sql = 'values ' || array_to_string(array(select '(''''' || ecocode_name || '''''::text)' from unnest(v_ecocodes) as ecocode_name), ', '::text);

    /* Cross tab data query. The sort order is required since crosstab function expects
       data to  be sorted in row, category order (othwerwise crosstab will display wrong values ). */
    v_data_sql = format('
        select physical_sample_id, ecocode_name::text, (array[abundance_count, abundance_sum])[%%s]::int as abundance
        from sead_utility.fn_sample_ecocode_abundances(%s, %s, %%s)
        order by 1, 2
    ', p_ecocode_system_id, p_ecocode_group_id);

    /* Final crosstab query parameterized by master set id and aggregate type (1:'count', 2:'sum') */
    v_cx_sql = format('
        select p_sum_or_count::text as agg_type, cx.physical_sample_id, %s
        from crosstab(format(''%s'', v_abundance_index, p_master_set_id), ''%s'') as cx (physical_sample_id int, %s)
    ', v_fields, v_data_sql, v_category_sql, v_typed_fields);

    v_udf_name = format('sead_utility.fn_ecocode_crosstab_%s_%s', p_ecocode_system_id, p_ecocode_group_id);

    v_udf_sql  = format('
drop function if exists %s(text);
create or replace function %s(p_master_set_id int, p_sum_or_count text)
/*
    Note! This function was automatically generated by fn_generate_ecocode_crosstab_function.
*/

returns table (
  agg_type text,
  physical_sample_id integer,
  %s
) as
$body$
declare
  v_sql text;
  v_abundance_index int;
begin
    v_abundance_index = case when p_sum_or_count = ''count'' then 1 else 2 end;
    return query
        %s;
end;
$body$
language ''plpgsql'';
', v_udf_name, v_udf_name, v_typed_fields, v_cx_sql);

    raise notice '%', v_udf_sql;
    execute v_udf_sql;
    return v_udf_sql;
end $$ language plpgsql;

commit;


-- select sead_utility.fn_generate_ecocode_crosstab_function(2, 7)
--select *
--from sead_utility.fn_ecocode_crosstab_2_7(1, 'count')
