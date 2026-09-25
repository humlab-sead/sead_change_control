-- Export the source-of-truth live column-level schema listing for the SEAD public schema.
--
-- Suggested usage with psql:
-- \copy (
--   <paste this query>
-- ) TO '.github/skills/sead-change-control/references/table-schema-detailed.csv' WITH CSV HEADER

with relation_columns as (
    select
        cols.table_schema,
        cols.table_name,
        cols.column_name,
        cols.ordinal_position,
        cols.data_type,
        cols.numeric_precision,
        cols.numeric_scale,
        cols.character_maximum_length,
        cols.is_nullable,
        pgc.oid as table_oid,
        pga.attnum,
        col_description(pgc.oid, pga.attnum) as description
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
primary_keys as (
    select
        n.nspname as table_schema,
        cls.relname as table_name,
        att.attname as column_name,
        'YES'::text as is_pk
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
        'YES'::text as is_fk,
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
)
select
    rc.table_name,
    rc.column_name,
    rc.ordinal_position,
    rc.data_type,
    rc.numeric_precision,
    rc.numeric_scale,
    rc.character_maximum_length,
    rc.is_nullable,
    coalesce(pk.is_pk, 'NO') as is_pk,
    coalesce(fk.is_fk, 'NO') as is_fk,
    fk.fk_table_name,
    fk.fk_column_name,
    rc.description
from relation_columns rc
left join primary_keys pk
    on pk.table_schema = rc.table_schema
   and pk.table_name = rc.table_name
   and pk.column_name = rc.column_name
left join foreign_keys fk
    on fk.table_schema = rc.table_schema
   and fk.table_name = rc.table_name
   and fk.column_name = rc.column_name
order by rc.table_name, rc.ordinal_position;