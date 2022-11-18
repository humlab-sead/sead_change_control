-- Deploy report:CS_REPORT__20190411_LANDING_PAGE_FUNCTIONS to pg

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

        raise exception 'NOTE! Check if these functions really are relevant. Origin is unknown.';
    
        if sead_utility.column_exists('public'::text, 'table_name'::text, 'column_name'::text) = TRUE then
            raise exception SQLSTATE 'GUARD';
        end if;
        
        CREATE OR REPLACE FUNCTION "public"."site_landing_page_site"("p_site_id" int4)
            RETURNS "pg_catalog"."json" AS $BODY$
        DECLARE 
            v_json json;
        BEGIN
            WITH T AS (
                SELECT json_build_object(
                    'siteId', s.site_id,
                    'siteName', s.site_name,
                    'siteDescription', COALESCE(s.site_description,''),
                    'places', site_landing_page_site_locations(p_site_id),
                    'coordinates',  json_build_object(
                        'lat', s.latitude_dd,
                        'lng', s.longitude_dd,
                        'epsg', '4326' -- FIXME!
                    ),
                    'sections', json_build_array(
                        site_landing_page_site_sample_section(p_site_id),
                        null
                    )
                ) AS json_site
                FROM tbl_sites s
                WHERE s.site_id = p_site_id
            ) SELECT json_site INTO v_json
              FROM T;
            RETURN v_json;
        END	
        $BODY$ LANGUAGE plpgsql;

        CREATE OR REPLACE FUNCTION "public"."site_landing_page_site_locations"("p_site_id" int4)
            RETURNS "pg_catalog"."json" AS $BODY$
        DECLARE 
            v_json json;
        BEGIN
            WITH T AS (
                SELECT L.location_name as name, L.location_type_id as level
                FROM tbl_site_locations SL
                JOIN tbl_locations L
                  ON L.location_id = SL.location_id
                WHERE SL.site_id = p_site_id
                ORDER BY L.location_type_id ASC
            ) SELECT array_to_json(array_agg(T))
                INTO v_json
              FROM T;
            RETURN v_json;
        END	
        $BODY$ LANGUAGE plpgsql;

        CREATE OR REPLACE FUNCTION "public"."site_landing_page_site_sample_groups"("p_site_id" int4)
            RETURNS "pg_catalog"."json" AS $BODY$
        DECLARE 
            v_sample_group_columns json;
            v_sample_group_rows json;
        BEGIN
             WITH data_columns AS (
                 SELECT *
                 FROM (
                     VALUES 
                        ('Samples', false, 'subtable'),
                        ('Site ID', false, 'numeric'),
                        ('Sample group ID', true, 'numeric'),
                        ('Sample group name', false, 'string'),
                        ('Sampling context', false, 'string'),
                        ('Sampling method', false, 'string'),
                        ('Number of samples', false, 'numeric'),
                        ('Datasets ID', false, 'string')
                ) AS A(title,pkey,dataType)
            ) SELECT array_to_json(array_agg(data_columns))
              INTO v_sample_group_columns
              FROM data_columns;

            WITH T AS (
                SELECT null
                FROM tbl_sites s
                WHERE s.site_id = 1
            ) SELECT array_to_json(array_agg(T))
                INTO v_sample_group_rows
              FROM T;

            RETURN json_build_object(
                    'name', 'samplegroups',
                    'title', 'Sample groups',
                    'data', json_build_object(
                        'columns', v_sample_group_columns,
                        'rows', v_sample_group_rows
                    )
                );
        END	
        $BODY$ LANGUAGE plpgsql;

        CREATE OR REPLACE FUNCTION "public"."site_landing_page_site_sample_section"("p_site_id" int4)
            RETURNS "pg_catalog"."json" AS $BODY$
        DECLARE 
            v_json json;
        BEGIN
            WITH T AS (
                SELECT json_build_object(
                    'name', 'samples',
                    'title', 'Samples',
                    'description', 'Samples collected from this site',
                    'contentItems', site_landing_page_site_sample_groups(p_site_id)
                ) AS json_site
                FROM tbl_sites s
                WHERE s.site_id = p_site_id
            ) SELECT json_site INTO v_json
              FROM T;
            RETURN v_json;
        END	
        $BODY$ LANGUAGE plpgsql;
                                     
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
