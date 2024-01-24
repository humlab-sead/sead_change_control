#!/bin/bash

# This function find the version tag for a change in a project
function get_change_tag() {
    

    local project=$1
    local change=$2

    change="${change##*/}"
    change="${change%.*}"

    echo $(grep -A999 -e "^${change}" $project/sqitch.plan | grep -e "^@[23].*" | head -1 | cut -d ' ' -f 1)
}

# This function reads the sorted list of projects from projects.txt
function get_projects() {
    local script_dir=$(dirname "$0")
    local projects_file=$(realpath $script_dir/../projects.txt)
    echo $(grep -v '^#' $projects_file | grep -v '^[[:space:]]*$')
}

# This function finds the project that contains a specific change
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

# This function retrieves the issue url for a change in a project plan.
function get_cr_issue_url() {
    local project=$1
    local change=$2

    change="${change##*/}"
    change="${change%.*}"
    url=$(grep -e "^${change}" $project/sqitch.plan | grep -o 'https://github.com/humlab-sead/sead_change_control/issues/[0-9]*:')
    if [ -z "$url" ]; then
        url=$(grep -e "^${change}" $project/sqitch.plan | grep -o 'https://github.com/humlab-sead/sead_change_control/issues/[0-9]*')
        if [ -z "$url" ]; then
            return
        fi
    fi
    echo ${url%:}
}

# This function retrieves the issue id for a change from the URL found in the project plan.
function get_cr_issue_id() {
    url=$(get_cr_issue_url $1 $2)
    echo ${url##*/}
}

# This function retrieves the comment for a change in a project plan (issue url is stripped away).
function get_cr_comment()
{
    local project=$1
    local change=$2
    local comment=$(awk -v keyword="$change" '$1 == keyword { match($0, /#(.*)$/); print substr($0, RSTART+1, RLENGTH-1) }' $project/sqitch.plan)
    if [[ "$comment" == *"https://"* ]]; then
        comment=$(echo $comment | cut -d':' -f3-)
        comment=$(echo "$comment" | sed -e 's/^ *//' -e 's/ *$//')
    fi
    echo $comment
}

# This function replaces a line starting with a keyword if found in a file, otherwise adds a line at a give linenumber.
function replace_or_add_line() {
    local file=$1
    local keyword=$2
    local replacement=$3
    local linenumber=$4

    set +e
    grep -q "^$keyword" "$file"
    if [ $? -eq 0 ]
    then
        sed -i "/^${keyword}/c${replacement}" "$file"
    else
        sed -i "${linenumber}i\
${replacement}" "$file"
    fi
    set -e

}

# This function updates the header of a change in a project with change name, issue url and comment..
function update_cr_header(){
    local project=$1
    local change=$2
    local types=$3

    change="${change##*/}"
    change="${change%.*}"

    if [ ! -f "$project/deploy/${change}.sql" ]; then
        echo "Change $project/deploy/${change}.sql does not exist"
        exit 64
    fi

    if [ -z "$types" ]; then
        types=(deploy)
    fi
    for type in "${types[@]}"; do

        local filename="$project/$type/$change.sql"
        if [ ! -f $filename ]; then
            echo "Change $filename does not exist"
            exit 64
        fi
        echo "Updating $filename"

        sed -i -e "/^-- ${type}/Id" $filename
        sed -i "1i\
-- ${type^} $project: $change" $filename

        local issue_url=$(get_cr_issue_url $project $change)

        if [ ! -z "$issue_url" ]; then
            echo "$issue_url"
            replace_or_add_line $filename "  Issue" "\ \ Issue         $issue_url" 7
        fi

        local cr_note=$(get_cr_comment $project $change)
        if [ ! -z "$cr_note" ]; then
            echo "$cr_note"
            replace_or_add_line $filename "  Description" "\ \ Description   $cr_note" 8
        fi

        change_date=${change:0:8}
        if [[ $change_date =~ ^[0-9]+$ ]]; then
            replace_or_add_line $filename "  Date" "\ \ Date          $(date -d "${change_date}" +%Y-%m-%d)" 6
        fi
    done

}

check_only_one_set() {
    local count=0
    for var in "$@"; do
        [[ -n $var ]] && let count++
    done

    if (( count == 1 )); then
        return 0
    else
        return 1
    fi
}


function basename_without_extension() {
    local path=$1
    local base=$(basename -- "$path")
    echo "${base%.*}"
}

function dirname_without_trailing_slash() {
    local path=$1
    local dir=$(dirname -- "$path")
    echo "${dir%/}"
}

function get_absolute_path() {
    local path=$1
    local dir=$(dirname_without_trailing_slash "$path")
    local base=$(basename_without_extension "$path")
    echo "$dir/$base"
}

function get_absolute_path_without_extension() {
    local path=$1
    local dir=$(dirname_without_trailing_slash "$path")
    local base=$(basename_without_extension "$path")
    echo "$dir/$base"
}
