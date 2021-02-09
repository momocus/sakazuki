#!/bin/bash

cd $(cd $(dirname $0); pwd)/../ # cd to project root

if type hadolint > /dev/null 2>&1; then
    HADOLINT="hadolint"
elif type docker > /dev/null 2>&1; then
    HADOLINT="docker run --rm -i hadolint/hadolint <"
fi

if [ -n "${HADOLINT}" ]; then
    files=$(git ls-files | grep "Dockerfile")
    for file in ${files}; do
        eval "${HADOLINT} ${file}"
    done
else
    warning "[SKIP] hadolint is not installed."
fi
