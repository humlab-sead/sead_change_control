-- Deploy sead_api: 20200201_DDL_ECOCODE_GEOJSON_EXPORT
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

set client_min_messages to WARNING;

/*****************************************************************************
** physical_sample_dating:  compiles dating info for physical samples
******************************************************************************/

create or replace view sead_utility.physical_sample_dating as
    with abundance_analysis as (
        /* filter out samples with abundance data */
        select ae.physical_sample_id
        from public.tbl_analysis_entities ae
        join public.tbl_abundances ab_1 using (analysis_entity_id)
        join public.tbl_taxa_tree_master tm using (taxon_id)
        group by ae.physical_sample_id
    ), dating as (
        /* retrieve dating data from tbl_analysis_entity_ages */
        select  a.physical_sample_id, 1 as dating_type, aea.age_older, aea.age_younger,
                null::character varying as age_name, null::character varying as age_abbreviation
        from public.tbl_analysis_entities a
        join public.tbl_analysis_entity_ages aea using (analysis_entity_id)
        group by a.physical_sample_id, aea.age_older, aea.age_younger
        union
        /* retrieve dating data from tbl_relative_dates/ages */
        select ae.physical_sample_id, 2 as dating_type, ra.cal_age_older as age_older, ra.cal_age_younger as age_younger, ra.relative_age_name as age_name, ra.abbreviation as age_abbreviation
        from public.tbl_analysis_entities ae
        join public.tbl_relative_dates rd on rd.analysis_entity_id = ae.analysis_entity_id
        join public.tbl_relative_ages ra on rd.relative_age_id = ra.relative_age_id
        group by ae.physical_sample_id, 2::integer, ra.cal_age_older, ra.cal_age_younger, ra.relative_age_name, ra.abbreviation
    ), site_location as (
        /* retrieve location data */
        select    s.site_id, s.site_name, s.latitude_dd, s.longitude_dd, sg.sample_group_id, l.location_type_id, l.location_name
        from public.tbl_sample_groups sg
        join public.tbl_sites s on s.site_id = sg.site_id
        join public.tbl_site_locations sl_1 on sl_1.site_id = s.site_id
        join public.tbl_locations l on l.location_id = sl_1.location_id
        join public.tbl_location_types lt on lt.location_type_id = l.location_type_id
        where not (s.latitude_dd is null or s.longitude_dd is null)
        group by s.site_id, s.site_name, s.latitude_dd, s.longitude_dd, sg.sample_group_id, l.location_type_id, l.location_name
    )
        /* compile data */
        select    sl.location_name, sl.site_id, sl.site_name, sl.latitude_dd, sl.longitude_dd,
                ps.physical_sample_id,
                d.dating_type, d.age_older, d.age_younger, d.age_name, d.age_abbreviation
        from public.tbl_physical_samples ps
        join site_location sl using (sample_group_id)
        join abundance_analysis ab using (physical_sample_id)
        left join dating d using (physical_sample_id)
        where sl.location_type_id = 1;


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
        from public.tbl_ecocode_definitions ed
        join public.tbl_ecocode_groups eg using (ecocode_group_id)
        where eg.ecocode_system_id = v_ecocode_system_id
          and eg.ecocode_group_id = v_ecocode_group_id
        -- select unnest(v_ecocodes) as ecocode_name
    ), taxon_ecocodes as (
        /* This is just a taxon to eco-code mapping (for selected system and group) */
        select taxon_id, ed.name as ecocode_name
        from public.tbl_ecocode_groups eg
        join public.tbl_ecocode_definitions ed using (ecocode_group_id)
        join public.tbl_ecocodes e using (ecocode_definition_id)
        where eg.ecocode_system_id = v_ecocode_system_id
          and eg.ecocode_group_id = v_ecocode_group_id
    ), samples as (
        /* Only consider samples that belong to specified master dataset */
        select distinct samples.physical_sample_id
        from public.tbl_physical_samples samples
        join public.tbl_analysis_entities using (physical_sample_id)
        join public.tbl_datasets using (dataset_id)
        join public.tbl_dataset_masters using (master_set_id)
        where tbl_dataset_masters.master_set_id = v_master_set_id
          and tbl_dataset_masters.master_name =  'Bugs database'
    ), sample_ecocode_abundances as (
        /* Compute count and sum by sample and ecocode */
        select samples.physical_sample_id, taxon_ecocodes.ecocode_name, count(abundance_id) as abundance_count, sum(abundance) as abundance_sum
        from samples
        join public.tbl_analysis_entities using (physical_sample_id)
        join public.tbl_abundances using (analysis_entity_id)
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
    p_ecocode_group_id int,
    p_dry_run BOOLEAN = TRUE
) returns text
as $$
declare
    v_ecocodes character varying[];
    v_fields text;
    v_typed_fields text;
    v_data_sql text;
    v_category_sql text;
    v_udf_sql text;
    v_udf_name text;
    v_valid_groups text;
    v_ecocode_fields text;
begin
    v_ecocodes = (
        select array_agg(ed.name order by ed.name )
        from public.tbl_ecocode_definitions ed
        join public.tbl_ecocode_groups eg using (ecocode_group_id)
        where eg.ecocode_system_id = p_ecocode_system_id
          and eg.ecocode_group_id = p_ecocode_group_id
    );

    if v_ecocodes is null then

        select string_agg(ecocode_group_id::text, ',')
            into v_valid_groups from public.tbl_ecocode_groups
        where ecocode_system_id = p_ecocode_system_id;

        v_valid_groups = coalesce(v_valid_groups, 'none');

        raise exception 'Illegal combination: system_id %, group_id %', p_ecocode_system_id, p_ecocode_group_id
            using hint = 'Please check ecocode_group_id. Valid groups for ecocode_system_id ' || p_ecocode_system_id::text || ': ' ||  v_valid_groups;

        return '';
    end if;

    /* Generate list of EcoCode field names for selected system and group */
    v_fields = array_to_string(array(select 'x."' || ecocode_name || '" ' from unnest(v_ecocodes) as ecocode_name), ', '::text);

    /* Generate list of typed EcoCode field names for selected system and group */
    v_typed_fields = array_to_string(array(select '"' || ecocode_name || '" int' from unnest(v_ecocodes) as ecocode_name), ', '::text);

    /* Generate list of EcoCode names as string values. This specifies categories in crosstab (i.e. columns) */
    v_category_sql = 'values ' || array_to_string(array(select '(''''' || ecocode_name || '''''::text)' from unnest(v_ecocodes) as ecocode_name), ', '::text);

    /* Cross tab data query. The sort order is required since crosstab function expects
       data to  be sorted in row, category order (othwerwise crosstab will display wrong values ). */
    v_data_sql = format('
        select physical_sample_id, ecocode_name::text, (array[abundance_count, abundance_sum])[%%s]::int as abundance
        from sead_utility.fn_sample_ecocode_abundances(%1$s, %2$s, %%s)
        order by 1, 2
     ', p_ecocode_system_id, p_ecocode_group_id);

    /* Final crosstab query parameterized by master set id and aggregate type (1:'count', 2:'sum') */

    v_udf_sql  = format('
        -- drop function if exists sead_utility.fn_ecocode_crosstab_%1$s_%2$s(int, text);
        create or replace function sead_utility.fn_ecocode_crosstab_%1$s_%2$s(p_master_set_id int, p_sum_or_count text)
        /*
            Note! This function was automatically generated by fn_generate_ecocode_crosstab_function.
        */

        returns table (
            agg_type text,
            physical_sample_id integer,
            %3$s
        ) as
        $body$
        declare
            v_sql text;
            v_abundance_index int;
        begin
            v_abundance_index = case when p_sum_or_count = ''count'' then 1 else 2 end;
            return query
                select p_sum_or_count::text as agg_type, x.physical_sample_id, %4$s
                from crosstab(format(''%5$s'', v_abundance_index, p_master_set_id), ''%6$s'') as x (physical_sample_id int, %3$s);
        end;
        $body$
        language ''plpgsql'';
        ', p_ecocode_system_id, p_ecocode_group_id, v_typed_fields, v_fields, v_data_sql, v_category_sql);

    if p_dry_run = TRUE then
        raise notice '%', v_udf_sql;
    else
        execute v_udf_sql;
    end if;

    v_udf_sql  = format('

        -- drop function if exists sead_utility.fn_ecocode_dating_%1$s_%2$s(int, text);

        create or replace function sead_utility.fn_ecocode_dating_%1$s_%2$s(p_master_set_id int, p_sum_or_count text)
            /*
                Note! This function was automatically generated by fn_generate_ecocode_crosstab_function.
            */
        returns table (
            agg_type            text,
            physical_sample_id  integer,
            %3$s,
            location_name       character varying(255),
            site_id             integer,
            site_name           character varying(60),
            latitude_dd         numeric(18, 10),
            longitude_dd        numeric(18, 10),
            dating_type         integer,
            age_older           numeric(20, 5),
            age_younger         numeric(20, 5),
            age_name            character varying,
            age_abbreviation    character varying,
            sample_group_id     integer,
            alt_ref_type_id     integer,
            sample_type_id      integer,
            sample_name         character varying(50),
            date_updated        timestamp with time zone,
            date_sampled        character varying
        ) as
        $body$
        declare
            v_sql text;
            v_abundance_index int;
        begin
            return query
                select  x.agg_type,
                        x.physical_sample_id,
                        %4$s,
                        d.location_name, d.site_id, d.site_name, d.latitude_dd, d.longitude_dd,
                        d.dating_type, d.age_older, d.age_younger, d.age_name, d.age_abbreviation,
                        ps.sample_group_id, ps.alt_ref_type_id, ps.sample_type_id, ps.sample_name, ps.date_updated, ps.date_sampled
                from sead_utility.fn_ecocode_crosstab_%1$s_%2$s(p_master_set_id, p_sum_or_count) x
                join sead_utility.physical_sample_dating d USING (physical_sample_id)
                join public.tbl_physical_samples ps USING (physical_sample_id);
        end;
        $body$
        language ''plpgsql'';
    ', p_ecocode_system_id, p_ecocode_group_id, v_typed_fields, v_fields);

    if p_dry_run = TRUE then
        raise notice '%', v_udf_sql;
    else
        execute v_udf_sql;
    end if;


    select string_agg(format('''%1$s'', e."%1$s"', x.a), ', ') into v_ecocode_fields
    from (
    	select unnest(v_ecocodes) as a
    ) as x;


    v_udf_sql  = format('

        -- drop function if exists sead_utility.fn_ecocode_dating_geojson_%1$s_%2$s(int, text);

        create or replace function sead_utility.fn_ecocode_dating_geojson_%1$s_%2$s(p_master_set_id int, p_sum_or_count text)
            /*
                Note! This function was automatically generated by fn_generate_ecocode_crosstab_function.
            */
        returns table (
            agg_type      text,
            ecocode_json  json
        ) as
        $body$
        begin

             return query
                select  p_sum_or_count as agg_type,
                        json_build_object(
                            ''type'', ''FeatureCollection'',
                            ''features'', json_agg(
                                json_build_object(
                                    ''type'', ''Feature'',
                                    ''id'', e.physical_sample_id,
                                    ''geometry'', json_build_object(''type'', ''Point'', ''coordinates'', json_build_array(e.longitude_dd, e.latitude_dd)),
                                    ''properties'', json_build_object(
                                        ''id'', e.physical_sample_id,
                                        ''country'', e.location_name,
                                        ''sampleData'', json_build_object(
                                            ''site_id'', e.site_id,
                                            ''site_name'', e.site_name,
                                            ''sample_name'', e.sample_name,
                                            ''sample_group_id'', e.sample_group_id,
                                            ''dating_type'', (ARRAY[''Calibrated radiocarbon dates''::text, ''Relative dates''::text])[e.dating_type],
                                            ''start'', e.age_older,
                                            ''end'', e.age_younger,
                                            ''age_name'', e.age_name,
                                            ''age_abbreviation'', e.age_abbreviation),
                                            ''indicators'', json_build_object(%3$s)
                                        )
                                    )
                                )
                            ) AS ecocode_json
                from sead_utility.fn_ecocode_dating_%1$s_%2$s(p_master_set_id, p_sum_or_count) e;
        end;
        $body$
        language ''plpgsql'';
    ', p_ecocode_system_id, p_ecocode_group_id, v_ecocode_fields);


    if p_dry_run = TRUE then
        raise notice '%', v_udf_sql;
    else
        execute v_udf_sql;
    end if;

    /* REST api views */

    v_udf_sql = format('

        /* Public API: /rpc/fn_ecocode_dating_geojson_x_y_sum */
        drop function if exists  postgrest_api.fn_ecocode_dating_geojson_%1$s_%2$s_sum;
        create or replace function postgrest_api.fn_ecocode_dating_geojson_%1$s_%2$s_sum() returns json language sql
        as $body$
         	select ecocode_json
          	from sead_utility.fn_ecocode_dating_geojson_%1$s_%2$s(1, ''sum''::text);
        $body$;

        grant all on function postgrest_api.fn_ecocode_dating_geojson_%1$s_%2$s_sum() to humlab_admin;
        grant execute on function postgrest_api.fn_ecocode_dating_geojson_%1$s_%2$s_sum() to public;

        /* Public API: /rpc/fn_ecocode_dating_geojson_x_y_count */
        drop function if exists  postgrest_api.fn_ecocode_dating_geojson_%1$s_%2$s_count;
        create or replace function postgrest_api.fn_ecocode_dating_geojson_%1$s_%2$s_count() returns json language sql
        as $body$
         	select ecocode_json
          	from sead_utility.fn_ecocode_dating_geojson_%1$s_%2$s(1, ''count''::text);
        $body$;

        grant all on function postgrest_api.fn_ecocode_dating_geojson_%1$s_%2$s_sum() to humlab_admin;
        grant execute on function postgrest_api.fn_ecocode_dating_geojson_%1$s_%2$s_sum() to public;


        /* Public API: /ecocode_dating_geojson_x_y_count DEPRECATED (creates invalid GeoJSON caused by a wrapped JSON) */
        drop view if exists postgrest_api.ecocode_dating_geojson_%1$s_%2$s_sum;
        drop view if exists postgrest_api.ecocode_dating_geojson_%1$s_%2$s_count;
        -- create or replace view postgrest_api.ecocode_dating_geojson_%1$s_%2$s_sum as
        --     select ecocode_json
        --     from sead_utility.fn_ecocode_dating_geojson_%1$s_%2$s(1, ''sum'');
        -- create or replace view postgrest_api.ecocode_dating_geojson_%1$s_%2$s_count as
        --     select ecocode_json
        --     from sead_utility.fn_ecocode_dating_geojson_%1$s_%2$s(1, ''count'');
        -- grant select on table postgrest_api.ecocode_dating_geojson_%1$s_%2$s_sum to public;
        ---grant select on table postgrest_api.ecocode_dating_geojson_%1$s_%2$s_count to public;


    ', p_ecocode_system_id, p_ecocode_group_id);

    if p_dry_run = TRUE then
        raise notice '%', v_udf_sql;
    else
        execute v_udf_sql;
    end if;

    /* Permissions */

    v_udf_sql = format('

        grant select on table sead_utility.physical_sample_dating to public;
        grant execute on function sead_utility.fn_sample_ecocode_abundances(int,int,int) to public;

        grant execute on function sead_utility.fn_ecocode_crosstab_%1$s_%2$s(int, text) to public;
        grant execute on function sead_utility.fn_ecocode_dating_%1$s_%2$s(int, text) to public;
        grant execute on function sead_utility.fn_ecocode_dating_geojson_%1$s_%2$s(int, text) to public;

        grant usage on schema sead_utility, public to postgrest_anon;
        grant select on all tables in schema sead_utility to postgrest_anon;
        grant execute on all functions in schema sead_utility to postgrest_anon;

    ', p_ecocode_system_id, p_ecocode_group_id);

    if p_dry_run = TRUE then
        raise notice '%', v_udf_sql;
    else
        execute v_udf_sql;
    end if;

    return '';

end $$ language plpgsql;


commit;
