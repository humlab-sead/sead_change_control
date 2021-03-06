#!/bin/bash

export PGCLIENTENCODING=UTF8

#echo "x.x.1.181" >  ~/.default.sead.server
#echo "x" >  ~/.default.sead.username

default_source_db_name=sead_master_9
default_source_dump_file="./starting_point/sead_master_9_public.sql.gz"

dothostfile=~/vault/.default.sead.server
dotuserfile=~/vault/.default.sead.username
dotsqitchfile=~/vault/.sqitch.env

target_db_name=
create_database=NO
source_type=
source_name=
conflict_resolution=rename
create_snapshot=NO

log_file=`date "+%Y%m%d%H%M%S"`_"deploy_${target_db_name}_${source_type}.log"

deploy_tag=

sqitch_projects="utility general bugs security subsystem sead_api"

if [[ -f "$dothostfile" ]]; then
    dbhost=`cat $dothostfile`
fi
if [[ -f "$dotuserfile" ]]; then
    dbuser=`cat $dotuserfile`
fi

usage_message=$(cat <<EOF
usage: deploy_staging OPTIONS...

    --host SERVERNAME               Target server (${dbhost})
    --user USERNAME                 User on target server (${dbuser})
    --target-db-name DBNAME         Target database name. Mandatory.
    --create-database               Create a fresh database from given source.
    --create-snapshot               Create snapshot of database.
    --source-type [db|dump]         Source type i.e. a database name or a dump filename.
                                    Mandatory if "--create" is specified, else ignored.
    --source [DBNAME|FILE]          Name of source database or dump file depending on source type
                                    Optional if "--create" is specified, else ignored.
                                    Default "sead_master_9" if "source_type" is "db"
                                    Default "./starting_point/sead_master_9_public.sql.gz" if "source_type" is "dump"
    --on-conflict [drop|rename]     What to do if target database exists (rename)
                                    Optional if "--create" is specified, else ignored. Default rename.
    --deploy-to-tag TAG             Sqitch deploy to tag. Optional. Set tag to "latest" for full deploy.
    --sqitch-project PROJECT        Sqitch project to deploy


EOF
)

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --host)
            dbhost="$2"; shift; shift
        ;;
        --user)
            dbuser="$2"; shift; shift
        ;;
        --target-db-name)
            target_db_name="$2"; shift; shift
        ;;
        --create-snapshot)
            create_snapshot="YES"; shift;
        ;;
        --create-database)
            create_database="YES"; shift;
        ;;
        --source)
            source_name="$2";
            shift; shift
        ;;
        --sqitch-project)
            sqitch_projects="$2";
            shift; shift
        ;;
        --source-type)
            source_type="$2";
            if [ "$source_name" == "" ]; then
                if [ "$source_type" == "dump" ]; then
                    source_name=${default_source_dump_file}
                elif [ "$source_type" == "db" ]; then
                    source_name=${default_source_db_name}
                else
                    echo "error: source-type must be db or dump"
                fi
            fi
            shift; shift
        ;;
        --deploy-to-tag)
            deploy_tag="--to $2"; shift; shift
        ;;
        # --deploy-change)
        #     deploy_tag="$2"; shift; shift
        # ;;
        --on-conflict)
            conflict_resolution="$2"; shift; shift;
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

if [ "$dbhost" != "seadserv.humlab.umu.se" ]; then
    echo "This script can for now only be run on 130.239.1.181";
    exit 64
fi


if [ "$create_snapshot" == "YES" ]; then

    if [ "$create_database" == "YES" ]; then
        echo "error: cannot create snapshot AND database at the same time"
        usage
        exit 64
    fi

    if [ "${source_name}" == "" ]; then
        echo "error: you must specify source database name";
        usage
        exit 64
    fi

    if [ "${target_db_name}" != "" ] || [ "${deploy_tag}" != "" ]  || [ "${source_type}" == "dump" ] ; then
        echo "error: invalid options for snapshot";
        usage
        exit 64
    fi

    snapshot_name=./starting_point/${source_name}_`date "+%Y%m%d"`.sql

    echo "pg_dump -C -c --if-exists -d "${source_name}" -h "$dbhost" -F p -U $dbuser -f $snapshot_name"

    pg_dump -C -c --if-exists -d "${source_name}" -h "$dbhost" -F p -U $dbuser -f $snapshot_name

    gzip $snapshot_name

    exit 64
fi

function dbexec() {
    db_name=$1
    sql=$2
    echo $sql >> $log_file
    psql -v ON_ERROR_STOP=1 --host=$dbhost --username=$dbuser --no-password --dbname=$db_name --command "$sql" >> $log_file
    if [ $? -ne 0 ];  then
        echo "FATAL: psql command failed! Deploy aborted." >&2
        exit 64
    fi
}

if [ "$create_database" == "YES"  ] && [ "${source_type}" != "db" ] && [ "${source_type}" != "dump" ]; then
    echo "error: you need to specify a db source type (db or dump) for new database";
    usage
    exit 64
fi

if [ "$target_db_name" == "" ]; then
    echo "error: you need to specify a target database";
    usage
    exit 64
fi

if [ "$target_db_name" == "sead_production" ]; then
    echo "Not allowed: You are not allowed to deploy directly to sead_production!";
    usage
    exit 64
fi

if [ "$create_database" == "NO" ]; then

    echo "notice: a new target database will not be create since --create-target is not requested";
    echo "  ==> Settings "source-db", "source-sql-file" and "source-type" is ignored.";

elif [ "$create_database" == "YES" ]; then

	if [ "${source_type}" == "" ]; then
        echo "error: source type must be specified when --create  is specified"
        usage
        exit 64
    fi

    if [ "${source_name}" == "" ]; then
        echo "error: source ${source_type} name not specified"
        usage
        exit 64
    fi

fi

if [ "$SQITCH_USERNAME" == "" ]; then
    export SQITCH_USERNAME=${dbuser}
fi

if [ "$SQITCH_USERNAME" == "" ]; then
    echo "error: username not specified"
    usage
    exit 64
fi

if [ "$SQITCH_PASSWORD" == "" ]; then
    if [ -f "${dotsqitchfile}" ]; then
        echo "info: using credentials found in vault"
        source "${dotsqitchfile}"
    else
        echo "error: password not specified (SQITCH_PASSWORD not defined and ${dotsqitchfile} not found)"
        usage
        exit 64
    fi
fi

git pull

deprecated_name=${target_db_name}_`date "+%Y%m%d%H%M%S"`

function dbexec() {
    db_name=$1
    sql=$2
    echo $sql >> $log_file
    psql -v ON_ERROR_STOP=1 --host=$dbhost --username=$dbuser --no-password --dbname=$db_name --command "$sql" >> $log_file
    if [ $? -ne 0 ];  then
        echo "FATAL: psql command failed! Deploy aborted." >&2
        exit 64
    fi
}

function dbexecgz() {
    db_name=$1
    gz_file=$2
    echo "Executing file $gz_file..." >> $log_file
    zcat $gz_file | psql -v ON_ERROR_STOP=1 --host=$dbhost --username=$dbuser --no-password --dbname=$db_name >> $log_file
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
        where pg_stat_activity.datname in ('${target_db_name}', '${source_name}')
          and pid <> pg_backend_pid();
____EOF
    )
    dbexec "postgres" "$sql" >& /dev/null >> $log_file
}

kick_out_users

function setup_new_target_database() {

    target_db_exists="$( psql --host=$dbhost --username=$dbuser --no-password --dbname=postgres -tAc "select 1 from pg_database where datname='${target_db_name}'" )"

	if [ "$target_db_exists" = "1" ]
	then

	    echo "Database exists..."

	    if [ "$conflict_resolution" == "rename" ]; then

		    echo "Renaming ${target_db_name} to ${deprecated_name}..."
		    sql="alter database ${target_db_name} rename to ${deprecated_name};"
		    dbexec "postgres" "$sql"

	    elif [ "$conflict_resolution" == "drop" ]; then

		    sql="drop database if exists ${target_db_name};"
		    dbexec "postgres" "$sql"

	    else
		    echo "error: target database ${target_db_name} exists. Drop database or use --on-conflict [drop|rename] to resolve"
		    exit 64
	    fi
	fi

	if [ "${source_type}" == "db" ]; then

	    if [ "${source_name}" == "" ]; then
		    echo "error: source database not specified"
		    usage
		    exit 64
	    fi

	    echo "Creating database ${target_db_name} using template ${source_name}..."
	    dbexec "postgres" "create database ${target_db_name} with template ${source_name} owner sead_master;"

	elif [ "${source_type}" == "dump" ]; then

	    if [ "${source_name}" == "" ]; then
		    echo "error: source sql.gz file not specified"
		    usage
		    exit 64
	    fi

	    echo "Creating database ${target_db_name}..."
	    dbexec "postgres" "create database ${target_db_name} owner sead_master;"

	    dbexec "$target_db_name" "drop schema if exists public;"

	    echo "Applying source SQL script..."
	    dbexecgz "$target_db_name" "$source_name"

	    echo "Applying default permissions..."
        # FIXME: Loop and apply all gz-files found in starting_point/
	    dbexecgz "${target_db_name}" "./starting_point/role_permissions.sql.gz"

	fi
}

if [ "$create_database" == "YES" ]; then

    echo "Setting up a new database..."

    setup_new_target_database

else

    echo "Using existing database ${target_db_name}..."

fi

if [ "$deploy_tag" == "" ]; then

    echo "Skipping change deploy (not requested)"
    exit 0
fi

if [ "$deploy_tag" == "--to latest" ]; then
    deploy_tag=
fi

target_db_exists="$( psql --host=$dbhost --username=$dbuser --no-password --dbname=postgres -tAc "select 1 from pg_database where datname='${target_db_name}'" )"
deploy_target_uri="db:pg://${dbuser}@${dbhost}/${target_db_name}"

if [ "$target_db_exists" != "1" ]; then
    echo "error: Target ${target_db_name} does not exist"
    exit 64
fi

for sqitch_project in $sqitch_projects; do

    echo "sqitch deploy --target ${deploy_target_uri} --mode change --no-verify -C ./$sqitch_project" $deploy_tag
    sqitch deploy --target ${deploy_target_uri} --mode change --no-verify -C ./$sqitch_project $deploy_tag
    if [ $? -ne 0 ];  then
        echo "FAILURE: sqitch deploy FAILED! DB is in an undefined state." >&2
        exit 64
    fi
done

