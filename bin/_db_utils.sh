#!/bin/bash

if [ -f .env ]; then
    set -o allexport
    source .env
    set +o allexport
fi

g_database=
g_force=no
g_host=
g_port=5433
g_user=
g_verbose=
g_schema=

g_script_dir=$(dirname "$(readlink -f "$0")")
g_script_name="${BASH_SOURCE[0]}"

if [ "$g_host" == "" ]; then
    if [ -f ~/vault/.default.sead.server ]; then
        g_host=`cat ~/vault/.default.sead.server`;
    else
        g_host=$(hostname -A);
    fi
fi

if [ "$g_user" == "" ]; then
    if [ -f ~/vault/.default.sead.username ]; then
        g_user=`cat ~/vault/.default.sead.username`;
    fi
fi

# if [ -f ~/vault/.default.sead.password ]; then
#     export PGPASSWORD=$(cat ~/vault/.default.sead.password)
# fi

usage_message=$(cat <<EOF
usage: $g_script_name FILENAME OPTIONS

    --host SERVERNAME               Target server (${g_host})
    --user USERNAME                 User on target server (${g_user})
    --port PORT                     Server port on target server (${g_port})
    --database DATABASE             Database on target server (${g_database})
    --schema SCHEMANAME             Schema to use (${g_schema})
    --force                         Drop target schema if it exists
    --verbose                       Verbose output (${g_verbose})
EOF
)

function usage()
{
    local error_message=$1
    if [ "$error_message" != "" ]; then
        echo "$error_message"
    fi
    echo "$usage_message"
    exit 64
}

__positional=()
while [[ $# -gt 0 ]]; do
    case $1 in
        --database|--db|--dbname) g_database=$2; shift 2;;
        --port|-p)                g_port=$2;     shift 2;;
        --user|-U)                g_user=$2;     shift 2;;
        --host|-h)                g_host=$2;     shift 2;;
        --schema|-s)              g_schema=$2;   shift 2;;
        --verbose|-v)             g_verbose=-e;  shift;;
        --force)                  g_force=yes;   shift;;
        *)                        __positional+=("$1"); shift;;
    esac
done

set -- "${__positional[@]}"

unset __positional


function execute_sql() {
    local database="$1"
    local sql="$2"
    psql -bqw -h $g_host -p "$g_port" -U $g_user -c "$sql" $database > /dev/null
    if [ $? -ne 0 ];  then
        echo "fatal: sql failed!"
        exit 64
    fi
}

function kickout() {
    local database="$1"
    local sql="select pg_terminate_backend(pid) from pg_stat_activity where datname = '$database' and pid <> pg_backend_pid();"
    execute_sql "postgres" "$sql" &> /dev/null
}
