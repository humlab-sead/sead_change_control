#!/bin/bash
#
# import_gadm_data - loads GADM administrative boundaries into a "gadm" schema.
#
# GADM ships two shapes of GeoPackage and this handles both:
#
#   gadm_410-levels.gpkg  one layer per level (ADM_0 .. ADM_5), already dissolved.
#   gadm_410.gpkg         a single layer of ~356k leaf units, each carrying its whole
#                         ancestry in GID_0..GID_5 / NAME_0..NAME_5 columns.
#
# With the combined file a level is not a layer, it is a grouping: the level-1 boundary of
# a region is the union of every leaf beneath it. So that file is staged once and each
# level is then dissolved with ST_Union grouped by GID_n. That is the expensive part - the
# levels file avoids it entirely, and is worth downloading instead if you have the choice.
#
# Geometry is loaded at full resolution; no simplification is applied.
#
# Note that ogr2ogr lowercases column names when writing to PostgreSQL (LAUNDER defaults
# to YES), so GADM's GID_0 / NAME_1 / TYPE_2 arrive as gid_0 / name_1 / type_2.

set -euo pipefail

if [ -f .env ]; then
    set -o allexport
    # shellcheck disable=SC1091
    source .env
    set +o allexport
fi

g_script_dir=$(dirname "$(readlink -f "$0")")

g_gpkg=""
# Where the source archive and the unpacked GeoPackage are cached. This is deliberately
# not inside the repository: the archive is 1.4 GB and must never reach git. In the
# deployment it is a mounted directory, so the download survives container rebuilds.
g_data_dir="${GADM_DATA_DIR:-/var/lib/gadm}"
# GADM is fetched on demand rather than vendored. Override for a local mirror, or to
# point at a different GADM release.
g_source_url="${GADM_SOURCE_URL:-https://geodata.ucdavis.edu/gadm/gadm4.1/gadm_410-gpkg.zip}"
g_fetch_only=no
g_schema="gadm"
g_levels="0 1 2"
g_host="${PGHOST:-localhost}"
g_port="${PGPORT:-5432}"
g_database="${PGDATABASE:-sead_staging}"
g_user="${PGUSER:-}"
g_password="${PGPASSWORD:-}"
g_simplify="0.001"
# The schema is created here rather than by sqitch, so deploy.sh's grant block never sees
# it and the read-only roles cannot reach it unless we grant here.
g_read_roles="sead_ro,postgrest_anon"
g_grants_only=no
g_keep_staging=no
g_drop_existing=no
g_verbose=no

usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Loads GADM administrative boundaries into the "${g_schema}" schema, one table per level:
adm_0 (country), adm_1 (region), adm_2 (municipality).

Options:
  -f, --gpkg PATH       GeoPackage to load. Default: the one in the data directory,
                        fetched and unpacked on demand if it is not there yet.
      --data-dir DIR    Where the archive and GeoPackage are cached
                        (default: ${g_data_dir}, or \$GADM_DATA_DIR)
      --source-url URL  Where to fetch the archive from when it is missing
                        (default: \$GADM_SOURCE_URL, else the GADM 4.1 GeoPackage)
      --fetch-only      Download and unpack only; touch the database not at all
  -d, --database NAME   Database (default: ${g_database})
  -h, --host HOST       Host (default: ${g_host})
  -p, --port PORT       Port (default: ${g_port})
  -U, --user USER       Role to connect as
  -s, --schema NAME     Target schema (default: ${g_schema})
  -l, --levels "0 1 2"  Administrative levels to build (default: ${g_levels})
      --simplify TOL    Simplification tolerance in degrees (default: ${g_simplify},
                        roughly 111 m; 0 stores full resolution instead). Only the
                        simplified geometry is kept.
      --drop            Drop each target table before loading it
      --read-roles LIST Comma separated roles to grant read access to
                        (default: ${g_read_roles}). Roles that do not exist are skipped.
      --grants-only     Only (re)apply the read grants, importing nothing
      --keep-staging    Keep the staging table after deriving the levels
  -v, --verbose         Echo the SQL being run
      --help            This text

The password is taken from PGPASSWORD, ~/.pgpass or a prompt, as libpq normally does.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--gpkg)      g_gpkg="$2"; shift 2 ;;
        --data-dir)     g_data_dir="$2"; shift 2 ;;
        --source-url)   g_source_url="$2"; shift 2 ;;
        --fetch-only)   g_fetch_only=yes; shift ;;
        -d|--database)  g_database="$2"; shift 2 ;;
        -h|--host)      g_host="$2"; shift 2 ;;
        -p|--port)      g_port="$2"; shift 2 ;;
        -U|--user)      g_user="$2"; shift 2 ;;
        -s|--schema)    g_schema="$2"; shift 2 ;;
        -l|--levels)    g_levels="$2"; shift 2 ;;
        --simplify)     g_simplify="$2"; shift 2 ;;
        --drop)         g_drop_existing=yes; shift ;;
        --read-roles)   g_read_roles="$2"; shift 2 ;;
        --grants-only)  g_grants_only=yes; shift ;;
        --keep-staging) g_keep_staging=yes; shift ;;
        -v|--verbose)   g_verbose=yes; shift ;;
        --help)         usage; exit 0 ;;
        *)              echo "Unknown option: $1" >&2; usage; exit 1 ;;
    esac
done

die() { echo "ERROR: $*" >&2; exit 1; }
info() { echo "==> $*"; }

command -v ogr2ogr >/dev/null || die "ogr2ogr not found. Install GDAL (apt install gdal-bin)."
command -v psql >/dev/null    || die "psql not found. Install the PostgreSQL client."
command -v curl >/dev/null    || die "curl not found; it is needed to fetch the GADM archive."
command -v unzip >/dev/null   || die "unzip not found; it is needed to unpack the GADM archive."

for level in $g_levels; do
    [[ "$level" =~ ^[0-5]$ ]] || die "Invalid level '${level}'. GADM has levels 0-5."
done

# ---------------------------------------------------------------- the source file

# Resolves the GeoPackage, fetching it only when it is genuinely absent. The three states
# are checked cheapest first, so a redeploy on a host that already has the data does no
# network I/O and no unpacking at all.
resolve_source_file() {
    local archive="${g_data_dir}/$(basename "$g_source_url")"

    if [ -n "$g_gpkg" ]; then
        [ -f "$g_gpkg" ] || die "GeoPackage not found: ${g_gpkg}"
        return
    fi

    g_gpkg="${g_data_dir}/gadm_410.gpkg"

    if [ -f "$g_gpkg" ]; then
        info "Using the GeoPackage already in ${g_data_dir} ($(du -h "$g_gpkg" | cut -f1))"
        return
    fi

    mkdir -p "$g_data_dir" || die "Could not create the data directory ${g_data_dir}"

    if [ ! -f "$archive" ]; then
        info "Fetching $(basename "$archive") from ${g_source_url}"
        info "  (about 1.4 GB; this is a one-off - it is kept in ${g_data_dir})"
        # Downloaded to a .part file first, so an interrupted transfer is never mistaken
        # for a complete archive on the next run. -C - resumes one that was interrupted.
        curl -fL --retry 3 --retry-delay 5 -C - -o "${archive}.part" "$g_source_url" \
            || die "Download failed: ${g_source_url}"
        mv "${archive}.part" "$archive"
    else
        info "Using the archive already in ${g_data_dir} ($(du -h "$archive" | cut -f1))"
    fi

    # The archived .gpkg is deflated, and SQLite needs random access, so reading it in
    # place through /vsizip/ would be unusably slow. Unpack it.
    info "Unpacking $(basename "$archive") (about 2.6 GB unpacked)"
    unzip -o -q "$archive" -d "$g_data_dir" || die "Could not unpack ${archive}"
    [ -f "$g_gpkg" ] || die "No gadm_410.gpkg inside ${archive}; pass --gpkg for a different layout."
}

if [ "$g_grants_only" != "yes" ]; then
    resolve_source_file
fi

if [ "$g_fetch_only" == "yes" ]; then
    info "Fetch complete: ${g_gpkg}"
    exit 0
fi

# ---------------------------------------------------------------- connection

g_pgconn="host=${g_host} port=${g_port} dbname=${g_database}"
g_psql_args=(-h "$g_host" -p "$g_port" -d "$g_database" -v ON_ERROR_STOP=1 -q)
if [ -n "$g_user" ]; then
    g_pgconn="${g_pgconn} user=${g_user}"
    g_psql_args+=(-U "$g_user")
fi
if [ -n "$g_password" ]; then
    g_pgconn="${g_pgconn} password=${g_password}"
    export PGPASSWORD="$g_password"
fi

run_sql() {
    [ "$g_verbose" == "yes" ] && echo "--- SQL: $1"
    psql "${g_psql_args[@]}" -c "$1"
}

info "Target: ${g_database} on ${g_host}:${g_port}, schema \"${g_schema}\""
psql "${g_psql_args[@]}" -c "select 1;" >/dev/null || die "Could not connect to the database."

run_sql "CREATE EXTENSION IF NOT EXISTS postgis;"
run_sql "CREATE SCHEMA IF NOT EXISTS ${g_schema};"

# ---------------------------------------------------------------- read access

# Anything that reads SEAD through PostgREST or the read-only role needs to reach these
# tables too, and a schema created outside sqitch starts with no grants at all.
grant_read_access() {
    local roles role
    IFS=',' read -ra roles <<< "$g_read_roles"
    for role in "${roles[@]}"; do
        role="$(echo "$role" | xargs)"
        [ -z "$role" ] && continue
        if [ "$(psql "${g_psql_args[@]}" -tAc "SELECT 1 FROM pg_roles WHERE rolname = '${role}';")" != "1" ]; then
            info "  role '${role}' does not exist here, skipping"
            continue
        fi
        info "  granting read access on ${g_schema} to ${role}"
        run_sql "GRANT USAGE ON SCHEMA ${g_schema} TO ${role};"
        run_sql "GRANT SELECT ON ALL TABLES IN SCHEMA ${g_schema} TO ${role};"
        # so a later re-import does not silently lose access again
        run_sql "ALTER DEFAULT PRIVILEGES IN SCHEMA ${g_schema} GRANT SELECT ON TABLES TO ${role};"
    done
}

if [ "$g_grants_only" == "yes" ]; then
    info "Applying read grants only"
    grant_read_access
    info "Done."
    exit 0
fi

# ---------------------------------------------------------------- which shape is this file

g_layers=$(ogrinfo -so "$g_gpkg" 2>/dev/null | sed -n 's/^[0-9]\+: \([A-Za-z0-9_]\+\).*/\1/p')
[ -n "$g_layers" ] || die "No layers found in ${g_gpkg}"

has_layer() { echo "$g_layers" | grep -qx "$1"; }

g_staging="${g_schema}.gadm_leaf"

# ogr2ogr writes one level's layer straight into its own table
load_level_layer() {
    local level="$1" layer="$2" table="${g_schema}.adm_${1}"
    info "Loading layer ${layer} -> ${table}"
    [ "$g_drop_existing" == "yes" ] && run_sql "DROP TABLE IF EXISTS ${table} CASCADE;"
    ogr2ogr -f PostgreSQL "PG:${g_pgconn}" "$g_gpkg" "$layer" \
        -nln "adm_${level}" -lco "SCHEMA=${g_schema}" -lco GEOMETRY_NAME=geom \
        -lco FID=gid -lco SPATIAL_INDEX=GIST \
        -nlt PROMOTE_TO_MULTI -t_srs EPSG:4326 \
        --config PG_USE_COPY YES -progress
}

# the combined file: stage the leaves once, then dissolve each level out of them
load_staging() {
    if [ "$(psql "${g_psql_args[@]}" -tAc "select to_regclass('${g_staging}') is not null;")" == "t" ] \
       && [ "$g_drop_existing" != "yes" ]; then
        info "Staging table ${g_staging} already exists, reusing it (use --drop to reload)"
        return
    fi
    info "Staging ${g_layers} -> ${g_staging} (~356k features, this is the slow part)"
    run_sql "DROP TABLE IF EXISTS ${g_staging} CASCADE;"
    ogr2ogr -f PostgreSQL "PG:${g_pgconn}" "$g_gpkg" "$g_layers" \
        -nln "$(basename "$g_staging")" -lco "SCHEMA=${g_schema}" -lco GEOMETRY_NAME=geom \
        -lco FID=gid -lco SPATIAL_INDEX=GIST \
        -nlt PROMOTE_TO_MULTI -t_srs EPSG:4326 \
        --config PG_USE_COPY YES -progress
}

# level n = every leaf sharing a GID_n, dissolved into one boundary, then thinned
dissolve_level() {
    local level="$1" table="${g_schema}.adm_${1}" raw="${g_schema}.adm_${1}_raw"
    local name_cols type_cols select_cols

    info "Dissolving level ${level} -> ${table}"
    run_sql "DROP TABLE IF EXISTS ${table} CASCADE;"
    run_sql "DROP TABLE IF EXISTS ${raw} CASCADE;"

    # carry the ancestry down so a level-2 row still names its country and region
    name_cols=""
    select_cols="gid"
    for (( parent=0; parent<=level; parent++ )); do
        name_cols="${name_cols}, max(gid_${parent}) AS gid_${parent}, max(name_${parent}) AS name_${parent}"
        select_cols="${select_cols}, gid_${parent}, name_${parent}"
    done
    # the unit's own type only exists from level 1 down
    type_cols=""
    if [ "$level" -gt 0 ]; then
        type_cols=", max(type_${level}) AS type, max(engtype_${level}) AS engtype"
        select_cols="${select_cols}, type, engtype"
    fi

    run_sql "
        CREATE TABLE ${raw} AS
        SELECT
            gid_${level} AS gid
            ${name_cols}
            ${type_cols},
            ST_Multi(ST_Union(geom))::geometry(MultiPolygon, 4326) AS geom
        FROM ${g_staging}
        WHERE gid_${level} IS NOT NULL AND gid_${level} <> ''
        GROUP BY gid_${level};"

    if [ "$g_simplify" == "0" ] || [ -z "$g_simplify" ]; then
        info "  storing at full resolution (simplification disabled)"
        run_sql "ALTER TABLE ${raw} RENAME TO adm_${level};"
    else
        # ST_CoverageSimplify rather than ST_SimplifyPreserveTopology: it thins the whole
        # set as one coverage, so a border shared by two units is simplified identically on
        # both sides and no slivers or gaps open between neighbours. It returns geometries
        # with no SRID, hence ST_SetSRID, and may return single Polygons, hence ST_Multi.
        info "  simplifying as a coverage, tolerance ${g_simplify} degrees"
        run_sql "
            CREATE TABLE ${table} AS
            SELECT ${select_cols},
                   ST_Multi(ST_SetSRID(ST_CoverageSimplify(geom, ${g_simplify}) OVER (), 4326))
                       ::geometry(MultiPolygon, 4326) AS geom
            FROM ${raw};"
        run_sql "DROP TABLE ${raw};"
    fi

    run_sql "ALTER TABLE ${table} ADD PRIMARY KEY (gid);"
    run_sql "CREATE INDEX adm_${level}_geom_idx ON ${table} USING GIST (geom);"
    run_sql "CREATE INDEX adm_${level}_name_idx ON ${table} (name_${level});"
    run_sql "ANALYZE ${table};"
}

# ---------------------------------------------------------------- run

if has_layer "ADM_0" || has_layer "ADM_1"; then
    info "This is the per-level GeoPackage; loading layers directly (no dissolve needed)"
    for level in $g_levels; do
        has_layer "ADM_${level}" || die "Layer ADM_${level} not present in ${g_gpkg}"
        load_level_layer "$level" "ADM_${level}"
        run_sql "CREATE INDEX IF NOT EXISTS adm_${level}_name_idx ON ${g_schema}.adm_${level} (name_${level});"
        run_sql "ANALYZE ${g_schema}.adm_${level};"
    done
else
    info "This is the combined GeoPackage; levels will be dissolved from the leaf units"
    load_staging
    # ST_Union over large groups is memory hungry; a country is thousands of leaves
    run_sql "SET work_mem = '512MB';" || true
    for level in $g_levels; do
        dissolve_level "$level"
    done
    if [ "$g_keep_staging" == "no" ]; then
        info "Dropping staging table ${g_staging} (use --keep-staging to keep it)"
        run_sql "DROP TABLE IF EXISTS ${g_staging} CASCADE;"
    fi
fi

grant_read_access

info "Done. Loaded:"
for level in $g_levels; do
    printf '    %s.adm_%s: %s rows\n' "$g_schema" "$level" \
        "$(psql "${g_psql_args[@]}" -tAc "select count(*) from ${g_schema}.adm_${level};")"
done
