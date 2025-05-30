#!/bin/bash
#
# Patches/applies one or more change requests (or any SQL file) to a database.

SHELL=/bin/bash

set -a
source .env
set +a

g_user=${PGUSER}
g_host=${PGHOST}
g_port=${PGPORT}
g_db=${PGDATABASE}

if [ "$g_host" == "" ] && [ -f ~/vault/.default.sead.server ]; then
    g_host=`cat ~/vault/.default.sead.server`
    g_host=${g_host:=$(dnsdomainname -A)}
fi

g_db=${g_db:=sead_staging}
g_port=${g_port:=5433}

if [ "$g_user" == "" ] && [ -f ~/vault/.default.sead.username ]; then
    g_user=`cat  ~/vault/.default.sead.username`
fi

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        --database|-d)
            g_db="$2"; shift 2;
        ;;
        --port|-p)
            g_port="$2"; shift 2;
        ;;
        --user|-U)
            g_user="$2"; shift 2;
        ;;
        --host|-h)
            g_host="$2"; shift 2;
        ;;
        --*)
            usage 'fatal: target database not specified!'
            shift 2;
        ;;
        *)
        POSITIONAL+=("$1")
        shift
        ;;
    esac
done

set -- "${POSITIONAL[@]}"

if [ "$g_db" == "" ]; then
    if [ "$1" != "" ]; then
        g_db=$1
    else
        usage 'fatal: target database not specified!'
    fi
fi

psql -h $g_host -p $g_port -U $g_user -d $g_db

