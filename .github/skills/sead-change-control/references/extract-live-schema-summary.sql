-- Export the source-of-truth live table-level schema summary for the SEAD public schema.
--
-- Suggested usage with psql:
-- \copy (
--   <paste this query>
-- ) TO '.github/skills/sead-change-control/references/table-schema-summary.csv' WITH CSV HEADER

with relation_columns as (
    select
        cols.table_schema,
        cols.table_name,
        cols.column_name,
        cols.ordinal_position,
        pgc.oid as table_oid
    from information_schema.columns cols
    join pg_catalog.pg_namespace pgn
        on pgn.nspname = cols.table_schema
    join pg_catalog.pg_class pgc
        on pgc.relnamespace = pgn.oid
       and pgc.relname = cols.table_name
       and pgc.relkind in ('r', 'p')
    join pg_catalog.pg_attribute pga
        on pga.attrelid = pgc.oid
       and pga.attname = cols.column_name
       and pga.attnum > 0
       and not pga.attisdropped
    where cols.table_schema = 'public'
),
table_descriptions as (
    select distinct
        rc.table_schema,
        rc.table_name,
        obj_description(rc.table_oid, 'pg_class') as table_description
    from relation_columns rc
),
primary_keys as (
    select
        n.nspname as table_schema,
        cls.relname as table_name,
        att.attname as column_name,
        pk_cols.position
    from pg_catalog.pg_constraint con
    join pg_catalog.pg_class cls
        on cls.oid = con.conrelid
    join pg_catalog.pg_namespace n
        on n.oid = cls.relnamespace
    join unnest(con.conkey) with ordinality as pk_cols(attnum, position)
        on true
    join pg_catalog.pg_attribute att
        on att.attrelid = con.conrelid
       and att.attnum = pk_cols.attnum
    where con.contype = 'p'
      and n.nspname = 'public'
),
foreign_keys as (
    select
        src_ns.nspname as table_schema,
        src_cls.relname as table_name,
        src_att.attname as column_name,
        src_cols.position,
        ref_cls.relname as fk_table_name,
        ref_att.attname as fk_column_name
    from pg_catalog.pg_constraint con
    join pg_catalog.pg_class src_cls
        on src_cls.oid = con.conrelid
    join pg_catalog.pg_namespace src_ns
        on src_ns.oid = src_cls.relnamespace
    join pg_catalog.pg_class ref_cls
        on ref_cls.oid = con.confrelid
    join pg_catalog.pg_namespace ref_ns
        on ref_ns.oid = ref_cls.relnamespace
    join unnest(con.conkey) with ordinality as src_cols(attnum, position)
        on true
    join unnest(con.confkey) with ordinality as ref_cols(attnum, position)
        on ref_cols.position = src_cols.position
    join pg_catalog.pg_attribute src_att
        on src_att.attrelid = con.conrelid
       and src_att.attnum = src_cols.attnum
    join pg_catalog.pg_attribute ref_att
        on ref_att.attrelid = con.confrelid
       and ref_att.attnum = ref_cols.attnum
    where con.contype = 'f'
      and src_ns.nspname = 'public'
      and ref_ns.nspname = 'public'
),
column_counts as (
    select
        table_schema,
        table_name,
        count(*) as column_count
    from relation_columns
    group by table_schema, table_name
),
pk_lists as (
    select
        table_schema,
        table_name,
        string_agg(column_name, ',' order by position) as pk_columns
    from primary_keys
    group by table_schema, table_name
),
fk_lists as (
    select
        table_schema,
        table_name,
        string_agg(column_name, ',' order by position, column_name) as fk_columns,
        string_agg(distinct fk_table_name, ',' order by fk_table_name) as fk_target_tables
    from foreign_keys
    group by table_schema, table_name
)
select
    cc.table_name,
    td.table_description,
    cc.column_count,
    coalesce(pk.pk_columns, '') as pk_columns,
    coalesce(fk.fk_columns, '') as fk_columns,
    coalesce(fk.fk_target_tables, '') as fk_target_tables
from column_counts cc
left join table_descriptions td
    on td.table_schema = cc.table_schema
   and td.table_name = cc.table_name
left join pk_lists pk
    on pk.table_schema = cc.table_schema
   and pk.table_name = cc.table_name
left join fk_lists fk
    on fk.table_schema = cc.table_schema
   and fk.table_name = cc.table_name
order by cc.table_name;