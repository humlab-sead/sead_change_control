#!/bin/bash

echo "130.239.1.181" >  ~/.default.sead.server
echo "humlab_admin" >  ~/.default.sead.username

dbhost=`cat ~/.default.sead.server`
dbuser=`cat ~/.default.sead.username`

dbsource=sead_master_9
dbtarget=sead_staging
dbdeprec=${dbtarget}_`date "+%Y%m%d%H%M%S"`

if [ "$dbhost" != "130.239.1.181" ]; then
    echo "This script can for now only be run on 130.239.1.181";
    exit 64
fi

echo "$dbhost"

function dbexec() {
    dbname=$1
    sql=$2
    echo $sql
    psql --host=$dbhost --username=$dbuser --no-password --dbname=$dbname --command "$sql"
}

sql=$(cat <<EOF
    select pg_terminate_backend(pg_stat_activity.pid)
    from pg_stat_activity
    where pg_stat_activity.datname in ('${dbtarget}', '${dbsource}')
      and pid <> pg_backend_pid();
EOF
)

dbexec "postgres" "$sql" > /dev/null

if [ "$( psql --host=$dbhost --username=$dbuser --no-password --dbname=postgres -tAc "select 1 from pg_database where datname='${dbtarget}'" )" = '1' ]
then
    echo "Renaming ${dbtarget} to ${dbdeprec}..."
    sql="alter database ${dbtarget} rename to ${dbdeprec};"
    dbexec "postgres" "$sql"
    #sql='drop database if exists ${dbtarget};'
    #dbexec "postgres" "$sql"
fi

sql="create database ${dbtarget} with template ${dbsource} owner sead_master;"
dbexec "postgres" "$sql"

sqitch deploy --target staging --to @v0.1 --mode change --no-verify -C ./utility
sqitch deploy --target staging --to @v0.1 --mode change --no-verify -C ./general
sqitch deploy --target staging --to @v0.1 --mode change --no-verify -C ./bugs
