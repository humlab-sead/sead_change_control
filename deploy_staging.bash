#!/bin/bash

export PGCLIENTENCODING=UTF8

#echo "x.x.1.181" >  ~/.default.sead.server
#echo "x" >  ~/.default.sead.username

db_hostfile=~/vault/.default.sead.server
db_userfile=~/vault/.default.sead.username
db_source_db=sead_master_9
db_source_sql="./starting_point/sead_master_9_public.sql.gz"
db_target_db=sead_staging_test
db_deprecated_db=${db_target_db}_`date "+%Y%m%d%H%M%S"`
on_conflict=rename
db_source_type=sql

log_file=`date "+%Y%m%d%H%M%S"`_"deploy_${db_target_db}_${db_source_type}.log"

deploy_tag=

sqitch_projects="utility general"

# bugs sead_api report"

if [[ -f "$db_hostfile" ]]; then
    db_host=`cat $db_hostfile`
fi
if [[ -f "$db_userfile" ]]; then
    db_user=`cat $db_userfile`
fi

usage_message=$(cat <<EOF
usage: deploy_staging OPTIONS...

    --host SERVERNAME               Target server (${db_host})
    --user USERNAME                 User on target server (${db_user})
    --target-database DBNAME        Target database name. Will be overwritten!
    --source-database DBNAME        Create new db using DBNAME as template (sets type to "db", default sead_master_9)
    --source-sql-file FILENAME      Create new db using gzipped dump-file (sets type to "sql")
    --source-type [db|sql]          Source template type (sql)
    --on-conflict [drop|rename]     What to do if target database exists (rename)
    --deploy-to-tag TAG             Sqitch deploy to tag


EOF
)

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --host)
            db_host="$2"; shift; shift
        ;;
        --user)
            db_user="$2"; shift; shift
        ;;
        --target-database)
            db_target_db="$2"; shift; shift
        ;;
        --source-database)
            db_source_db="$2"; shift; shift
            db_source_type="db";
        ;;
        --source-sql-file)
            db_source_sql="$2"; shift; shift
            db_source_type="sql";
        ;;
        --source-type)
            db_source_type="$2"; shift; shift
        ;;
        --deploy-to-tag)
            deploy_tag="--to $2"; shift; shift
        ;;
        --on-conflict)
            on_conflict="$2"; shift
        ;;
        *)
            POSITIONAL+=("$1") # save it in an array for later
            shift
        ;;
    esac
done

function usage() {

    echo "$usage_message"
}

set -- "${POSITIONAL[@]}" # restore positional parameters

if [ "$db_host" != "seadserv.humlab.umu.se" ]; then
    echo "This script can for now only be run on 130.239.1.181";
    exit 64
fi

if [ "${db_source_type}" != "db" ] && [ "${db_source_type}" != "sql" ]; then
    usage
    exit 64
fi


if [ "$db_target_db" == "sead_production" ]; then
    echo "Not allowed: You are not allowed to deploy directly to sead_production!";
    exit 64
fi

function dbexec() {
    db_name=$1
    sql=$2
    echo $sql >> $log_file
    psql -v ON_ERROR_STOP=1 --host=$db_host --username=$db_user --no-password --dbname=$db_name --command "$sql" >> $log_file
    if [ $? -ne 0 ];  then
        echo "FATAL: psql command failed! Deploy aborted." >&2
        exit 64
    fi
}

function dbexecgz() {
    db_name=$1
    gz_file=$2
    echo "Executing file $gz_file..." >> $log_file
    zcat $gz_file | psql -v ON_ERROR_STOP=1 --host=$db_host --username=$db_user --no-password --dbname=$db_name >> $log_file
    if [ $? -ne 0 ];  then
        echo "FATAL: psql command failed! Deploy aborted." >&2
        exit 64
    fi
}

function kick_out_users() {
    echo "Kicking out users..."
    sql=$(cat <<____EOF
        select pg_terminate_backend(pg_stat_activity.pid)
        from pg_stat_activity
        where pg_stat_activity.datname in ('${db_target_db}', '${db_source_db}')
          and pid <> pg_backend_pid();
____EOF
    )
    dbexec "postgres" "$sql" >& /dev/null >> $log_file
}

kick_out_users

if [ "$( psql --host=$db_host --username=$db_user --no-password --dbname=postgres -tAc "select 1 from pg_database where datname='${db_target_db}'" )" == '1' ]
then
    echo "Database exists..."
    if [ "$on_conflict" == "rename" ]; then
        echo "Renaming ${db_target_db} to ${db_deprecated_db}..."
        sql="alter database ${db_target_db} rename to ${db_deprecated_db};"
        dbexec "postgres" "$sql"
    elif [ "$on_conflict" == "drop" ]; then
        sql='drop database if exists ${db_target_db};'
        dbexec "postgres" "$sql"
    else
        echo "error: target database ${db_target_db} exists. please drop database or use --on-conflict [drop|rename] to resolve"
        exit 64
    fi
fi

if [ "${db_source_type}" == "db" ]; then

    if [ "${db_source_db}" == "" ]; then
        echo "error: source database not specified"
        usage
        exit 64
    fi

    echo "Creating database ${db_target_db} using template ${db_source_db}..."
    dbexec "postgres" "create database ${db_target_db} with template ${db_source_db} owner sead_master;"

elif [ "${db_source_type}" == "sql" ]; then

    if [ "${db_source_sql}" == "" ]; then
        echo "error: source sql.gz file not specified"
        usage
        exit 64
    fi

    echo "Creating database ${db_target_db}..."
    dbexec "postgres" "create database ${db_target_db} owner sead_master;"

    dbexec "$db_target_db" "drop schema if exists public;"

    echo "Applying source SQL script..."
    dbexecgz "$db_target_db" "$db_source_sql"

    echo "Applying default permissions..."
    dbexecgz "${db_target_db}" "./starting_point/role_permissions.sql.gz"

else

    echo "error: please specify which source db to use as base template"
    usage
    exit 64

fi

if [ "$deploy_tag" != "" ]; then

    deploy_target_uri="db:pg://${db_user}@${db_host}/${db_target_db}"
    for sqitch_project in $sqitch_projects; do
        sqitch deploy --target ${deploy_target_uri} $deploy_tag --mode change --no-verify -C ./$sqitch_project
        if [ $? -ne 0 ];  then
            echo "FAILURE: sqitch deploy FAILED! DB is in an undefined state." >&2
            exit 64
        fi
    done
fi
