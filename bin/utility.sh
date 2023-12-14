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