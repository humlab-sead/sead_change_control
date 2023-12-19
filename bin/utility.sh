#!/bin/bash

function get_change_tag() {
    local project=$1
    local change=$2

    change="${change##*/}"
    change="${change%.*}"

    echo $(grep -A999 -e "^${change}" $project/sqitch.plan | grep -e "^@[23].*" | head -1 | cut -d ' ' -f 1)
}

function get_projects() {
    local script_dir=$(dirname "$0")
    local projects_file=$(realpath $script_dir/../projects.txt)
    echo $(grep -v '^#' $projects_file | grep -v '^[[:space:]]*$')
}

function find_project() {
    local cr=$1
    local projects=$(get_projects)
    for project in $projects; do
        if [ -f "$project/deploy/${cr}.sql" ]; then
            echo $project
            return
        fi
    done
}

function get_cr_issue_url() {
    local project=$1
    local change=$2

    change="${change##*/}"
    change="${change%.*}"

    url=$(grep -e "^${change}" $project/sqitch.plan | grep -o 'https://github.com/humlab-sead/sead_change_control/issues/[0-9]*:')
    if [ -z "$url" ]; then
        return
    fi
    echo ${url%:}
}

function get_cr_issue_id() {
    url=$(get_cr_issue_url $1 $2)
    echo ${url##*/}
}

function update_cr_header(){
    local project=$1
    local change=$2

    change="${change##*/}"
    change="${change%.*}"

    if [ ! -f "$project/deploy/${change}.sql" ]; then
        echo "Change $project/deploy/${change}.sql does not exist"
        exit 64
    fi

    for type in deploy revert verify ; do
        local filename="$project/$type/$change.sql"
        echo "Updating $filename"
        if [ ! -f $filename ]; then
            echo "Change $filename does not exist"
            exit 64
        fi
        echo "-- ${type^} $project: $change" > /tmp/$change.sql
        grep -v -i -e "^-- ${type}" $filename >> /tmp/$change.sql ;
        mv -f /tmp/$change.sql $filename
    done

}
