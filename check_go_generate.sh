#!/bin/bash
# This script is used by the CI to check if 'go generate ./...' is up to date.
#
# Note: If the generated files aren't up to date then this script updates
# them despite printing an error message (but this isn't a problem for the CI).

set -euo pipefail
cd "$( dirname "$0" )"

TEMP_DIR=$( mktemp -d )
function cleanup() {
    rm -rf "${TEMP_DIR}"
}
trap cleanup EXIT

cp -r . "${TEMP_DIR}/"
go generate ./...
if ! diff -r . "${TEMP_DIR}"; then
    echo
    echo "The generated files aren't up to date."
    echo "Update them with the 'go generate ./...' command."
    exit 1
fi
