
create or replace function find_dependent_objects(
    p_schema_name text,    -- schema where the table resides
    p_table_name text,     -- table name to check
    p_column_name text     -- column name to check
) returns table (
    schema_name text,
    object_type text,
    object_name text,
    object_kind text,
    column_name text
) language plpgsql as $$
begin
    return query
    with recursive dependencies as (
        -- step 1: find direct dependencies on the specific column
        select
            d.classid::regclass::text as object_type,
            c.relname as object_name,
            c.relkind as object_kind,
            n.nspname as schema_name,
            a.attname as column_name,
            d.refobjid,
            d.objid
        from pg_depend d
        join pg_attribute a on d.refobjid = a.attrelid and d.refobjsubid = a.attnum
        join pg_class c on d.objid = c.oid
        join pg_namespace n on c.relnamespace = n.oid
        where a.attname = p_column_name
            and a.attrelid = (
                select oid 
                from pg_class 
                where relname = p_table_name 
                and relnamespace = (
                    select oid 
                    from pg_namespace 
                    where nspname = p_schema_name 
                )
            )
        
        union all

        -- step 2: recursively find dependencies of dependent objects
        select
            d.classid::regclass::text as object_type,
            c.relname as object_name,
            c.relkind as object_kind,
            n.nspname as schema_name,
            null as column_name,
            d.refobjid,
            d.objid
        from pg_depend d
        join pg_class c on d.objid = c.oid
        join pg_namespace n on c.relnamespace = n.oid
        join dependencies dp on d.refobjid = dp.objid
    )
    select distinct d.schema_name, d.object_type, d.object_name, d.object_kind, d.column_name
    from dependencies d
    order by d.schema_name, d.object_type, d.object_name;
end $$;


-- Credit to Kong Man. Source: https://stackoverflow.com/a/28290575/5834512
with recursive preference as (
    select 10 as max_depth
    , 16384 as min_oid -- user objects only
    , '^(londiste|pgq|pg_toast)'::text AS schema_exclusion
    , '^pg_(conversion|language|ts_(dict|template))'::text AS class_exclusion
    , '{"SCHEMA":"00", "TABLE":"01", "TABLE CONSTRAINT":"02", "DEFAULT VALUE":"03",
        "INDEX":"05", "SEQUENCE":"06", "TRIGGER":"07", "FUNCTION":"08",
        "VIEW":"10", "MATERIALIZED VIEW":"11", "FOREIGN TABLE":"12"}'::json AS type_sort_orders
), dependency_pair AS (
    SELECT objid
      , array_agg(objsubid ORDER BY objsubid) AS objsubids
      , upper(obj.type) AS object_type
      , coalesce(obj.schema, substring(obj.identity, E'(\\w+?)\\.'), '') AS object_schema
      , obj.name AS object_name
      , obj.identity AS object_identity
      , refobjid
      , array_agg(refobjsubid ORDER BY refobjsubid) AS refobjsubids
      , upper(refobj.type) AS refobj_type
      , coalesce(CASE WHEN refobj.type='schema' THEN refobj.identity
                                                ELSE refobj.schema END
          , substring(refobj.identity, E'(\\w+?)\\.'), '') AS refobj_schema
      , refobj.name AS refobj_name
      , refobj.identity AS refobj_identity
      , CASE deptype
            WHEN 'n' THEN 'normal'
            WHEN 'a' THEN 'automatic'
            WHEN 'i' THEN 'internal'
            WHEN 'e' THEN 'extension'
            WHEN 'p' THEN 'pinned'
        END AS dependency_type
    FROM pg_depend AS dep
      , LATERAL pg_identify_object(classid, objid, 0) AS obj
      , LATERAL pg_identify_object(refclassid, refobjid, 0) AS refobj
      , preference
    WHERE deptype = ANY('{n,a}')
    AND objid >= preference.min_oid
    AND (refobjid >= preference.min_oid OR refobjid = 2200) -- need public schema as root node
    AND coalesce(obj.schema, substring(obj.identity, E'(\\w+?)\\.'), '') !~ preference.schema_exclusion
    AND coalesce(CASE WHEN refobj.type='schema' THEN refobj.identity
                                                ELSE refobj.schema END
          , substring(refobj.identity, E'(\\w+?)\\.'), '') !~ preference.schema_exclusion
    GROUP BY objid, obj.type, obj.schema, obj.name, obj.identity
      , refobjid, refobj.type, refobj.schema, refobj.name, refobj.identity, deptype
), 
dependency_hierarchy AS (
    SELECT DISTINCT
        0 AS level,
        refobjid AS objid,
        refobj_type AS object_type,
        refobj_identity AS object_identity,
        --refobjsubids AS objsubids,
        NULL::text AS dependency_type,
        ARRAY[refobjid] AS dependency_chain,
        ARRAY[concat(preference.type_sort_orders->>refobj_type,refobj_type,':',refobj_identity)] AS dependency_sort_chain
    FROM dependency_pair root
    , preference
    WHERE NOT EXISTS
       (SELECT 'x' FROM dependency_pair branch WHERE branch.objid = root.refobjid)
    AND refobj_schema !~ preference.schema_exclusion
    UNION ALL
    SELECT
        level + 1 AS level,
        child.objid,
        child.object_type,
        child.object_identity,
        --child.objsubids,
        child.dependency_type,
        parent.dependency_chain || child.objid,
        parent.dependency_sort_chain || concat(preference.type_sort_orders->>child.object_type,child.object_type,':',child.object_identity)
    FROM dependency_pair child
    JOIN dependency_hierarchy parent ON (parent.objid = child.refobjid)
    , preference
    WHERE level < preference.max_depth
    AND child.object_schema !~ preference.schema_exclusion
    AND child.refobj_schema !~ preference.schema_exclusion
    AND NOT (child.objid = ANY(parent.dependency_chain)) -- prevent circular referencing
), 
aliased_and_filtered as (
    SELECT level
        , objid as object_id
        , object_type
        , object_identity
        , dependency_type
        , dependency_chain
        , dependency_sort_chain
    FROM dependency_hierarchy
    WHERE object_type IN ('TABLE CONSTRAINT','RULE')

), 
text_search as (
    SELECT level
        , object_id
        , object_type
        , CASE WHEN object_identity like '% on %'
            THEN SUBSTR(object_identity, position(' on ' in object_identity)+ 4)
            END AS schema_and_object
        , object_identity
        , dependency_type
        , dependency_chain
        , dependency_sort_chain
    FROM aliased_and_filtered
), 
final as (
    SELECT *
    FROM text_search
)
    SELECT *
    FROM final
    --WHERE schema_and_object = 'public.tbl_dimensions'
    ORDER BY schema_and_object

