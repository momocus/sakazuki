#!/bin/bash

set -e # exit by error
cd $(cd $(dirname $0); pwd)/../ # cd to project root

NORMAL=$(tput sgr0)
YELLOW=$(tput setaf 3)
GRAY=$(tput setaf 8)

function message() {
    echo -e "$GRAY$*$NORMAL"
}

function warning() {
    echo -e "$YELLOW$*$NORMAL"
}

# generic

message "##### Run EOF Check"
./cli-scripts/check_endoffile_with_newline.sh

# node packages

message "##### Run ESLint"
yarn run lint:eslint

message "##### Run markdownlint"
yarn run lint:markdownlint

message "##### Run stylelint"
yarn run lint:stylelint

# gems

message "##### Run Rubocop"
bundle exec rubocop

message "##### Run ERBLint"
bundle exec erblint --lint-all

# docker

message "##### Run Hadolint"
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
