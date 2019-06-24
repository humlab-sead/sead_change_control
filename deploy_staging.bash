#!/bin/bash

export PGCLIENTENCODING=UTF8

#echo "130.239.1.181" >  ~/.default.sead.server
#echo "humlab_admin" >  ~/.default.sead.username

dbhostfile=~/.default.sead.server
dbuserfile=~/.default.sead.username
dbsource=sead_master_9
dbtarget=sead_staging
dbdeprecated=${dbtarget}_`date "+%Y%m%d%H%M%S"`
on_conflict=rename
cr_version=@v0.1

#sqitch_projects="utility general bugs sead_api report"
sqitch_projects="utility general bugs"

if [[ -f "$dbhostfile" ]]; then
    dbhost=`cat $dbhostfile`
fi
if [[ -f "$dbuserfile" ]]; then
    dbuser=`cat $dbuserfile`
fi

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -h|--host)
            dbhost="$2"; shift; shift
        ;;
        -u|--user)
            dbuser="$2"; shift; shift
        ;;
        -t|--target-database)
            dbtarget="$2"; shift; shift
        ;;
        -s|--source-database)
            dbsource="$2"; shift; shift
        ;;
        -v|--to)
            cr_version="$2"; shift; shift
        ;;
        -c|--on-conflict)
            on_conflict="$2"; shift
        ;;
        *)
            POSITIONAL+=("$1") # save it in an array for later
            shift
        ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ "$dbhost" != "130.239.1.181" ]; then
    echo "This script can for now only be run on 130.239.1.181";
    exit 64
fi

if [ "$dbtarget" == "sead_production" ]; then
    echo "Not allowed: You are not allowed to deploy directly to sead_production!";
    exit 64
fi

function dbexec() {
    dbname=$1
    sql=$2
    echo $sql
    psql --host=$dbhost --username=$dbuser --no-password --dbname=$dbname --command "$sql"
    if [ $? -ne 0 ];  then
        echo "FATAL: psql command failed! Deploy aborted." >&2
        exit 64
    fi
}

sql=$(cat <<EOF
    select pg_terminate_backend(pg_stat_activity.pid)
    from pg_stat_activity
    where pg_stat_activity.datname in ('${dbtarget}', '${dbsource}')
      and pid <> pg_backend_pid();
EOF
)

dbexec "postgres" "$sql" # > /dev/null

if [ "$( psql --host=$dbhost --username=$dbuser --no-password --dbname=postgres -tAc "select 1 from pg_database where datname='${dbtarget}'" )" = '1' ]
then
    if [ "$on_conflict" == "rename" ]; then
        echo "Renaming ${dbtarget} to ${dbdeprecated}..."
        sql="alter database ${dbtarget} rename to ${dbdeprecated};"
        dbexec "postgres" "$sql"
    elif [ "$on_conflict" == "drop" ]; then
        sql='drop database if exists ${dbtarget};'
        dbexec "postgres" "$sql"
    else
        echo "error: target database ${dbtarget} exists. drop or use --on-conflict [drop|rename] to resolve"
        exit 64
    fi
fi

sql="create database ${dbtarget} with template ${dbsource} owner sead_master;"
dbexec "postgres" "$sql"

for sqitch_project in $sqitch_projects; do
    sqitch deploy --target staging --to $cr_version --mode change --no-verify -C ./$sqitch_project
    if [ $? -ne 0 ];  then
        echo "FAILURE: sqitch deploy FAILED! DB is in an undefined state." >&2
        exit 64
    fi
done

#FIXME: Måste foxa sqitch på local terminal (debian): kör nu inte docker-sqitchcpan install App::Sqitch DBD::Pg DBD::SQLite