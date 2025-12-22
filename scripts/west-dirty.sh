#!/usr/bin/env bash
set -euo pipefail

status_output="$(git status --porcelain)"

if [[ -n "${status_output}" ]]; then
    if [[ "${1:-}" == "--show-details" ]]; then
        echo "### ${WEST_PROJECT_NAME:-unknown}"
        # Preserve newlines from git status output
        printf '%s\n' "${status_output}"
    else
        echo "${WEST_PROJECT_NAME:-unknown}"
    fi
fi

exit 0
