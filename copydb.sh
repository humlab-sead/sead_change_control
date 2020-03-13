#!/bin/bash

source_db="sead_production"
target_db=""
drop_if_exists=no
sync_sequences=no
dbhost=""
dbuser=""

if [ -f "~/vault/.default.sead.server" ]; then
    dbhost=`cat ~/vault/.default.sead.server`
fi

if [ -f "~/vault/.default.sead.username" ]; then
    dbuser=`cat  ~/vault/.default.sead.username`
fi

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        --source)
            source_db="$2"; shift; shift
        ;;
        --target)
            target_db="$2"; shift; shift
        ;;
        --force)
            drop_if_exists=yes; shift
        ;;
        --sync-sequences)
            sync_sequences=yes; shift
        ;;
        *)
        POSITIONAL+=("$1")
        shift
        ;;
    esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

function usage()
{
    echo "usage: setup_target_db [--source dbname] [--force] --target dbname"
    echo "Creates new databse using source as template. Source defaults to production."
    echo ""
    echo "   --source                  source database name"
    echo "   --target                  target database name"
    echo "   --force                   drop target if exists"
    echo "   --sync-sequences          sync sequences in target after create"
    echo ""
}

if [ "$target_db" == "sead_production" ]; then
    echo "fatal: you are not allowed to target production!"
    exit 64
fi

if [ "$target_db" == "" ]; then
    usage
    exit 64
fi

dbexec() {
    psql -bqw -h $dbhost -U $dbuser -c "$1" $target_db
}

kickout() {
    echo "Kicking out users from $1..."
    xsql="select pg_terminate_backend(pid) from pg_stat_activity where datname = '$1' and pid <> pg_backend_pid();"
    psql -bqw -h $dbhost -U $dbuser -c "$xsql" "postgres" > /dev/null 2>&1
    if [ $? -ne 0 ];  then
        echo "fatal: kickout failed! Deploy aborted." >&2
        exit 64
    fi
}

sync_sequences() {
    echo "Syncing sequences in $1..."
    xsql="select sead_utility.sync_sequences();"
    psql -bqw -h $dbhost -U $dbuser -c "$xsql" "$1"
    #> /dev/null 2>&1
    if [ $? -ne 0 ];  then
        echo "fatal: sync failed!" >&2
        exit 64
    fi
}

drop_target() {
    kickout $target_db
    echo "Dropping ${target_db} if exists..."
    dropdb --echo --host=$dbhost --username=$dbuser --no-password "$target_db"
    # > /dev/null 2>&1
}

create_target() {
    kickout $source_db
    echo "Creating database $target_db..."
    createdb --echo --owner=sead_master --host=$dbhost --username=$dbuser --no-password --encoding="UTF8" -T "$source_db" "$target_db"
    # > /dev/null
    if [ $? -ne 0 ];  then
        echo "fatal: create failed!" >&2
        exit 64
    fi
}

if [ "$drop_if_exists" == "yes" ]; then
    drop_target
fi

create_target

if [ "$sync_sequences" == "yes" ]; then
    kickout $target_db
    sync_sequences $target_db
fi