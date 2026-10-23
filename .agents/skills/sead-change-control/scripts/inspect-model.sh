#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
tables="$repo_root/sead_model/deploy/SEAD_DATABASE_MODEL/tables.sql"
foreignkeys="$repo_root/sead_model/deploy/SEAD_DATABASE_MODEL/foreignkeys.sql"
comments="$repo_root/sead_model/deploy/SEAD_MODEL_COMMENTS/comments.sql"

if [[ $# -eq 0 ]]; then
    printf 'SEAD model sources:\n'
    printf '  %s\n' "$tables" "$foreignkeys" "$comments"
    printf '\nUsage:\n  %s <pattern>\n' "${0##*/}"
    printf 'Example:\n  %s "tbl_analysis_entities|tbl_datasets"\n' "${0##*/}"
    exit 0
fi

if command -v rg >/dev/null 2>&1; then
    rg -n --context 2 "$1" "$tables" "$foreignkeys" "$comments"
else
    grep -En "$1" "$tables" "$foreignkeys" "$comments"
fi