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
yarn lint-ts

message "##### Run markdownlint"
yarn lint-md

message "##### Run stylelint"
yarn lint-style

# gems

message "##### Run Rubocop"
bundle exec rubocop

message "##### Run ERBLint"
bundle exec erblint --lint-all

# docker
message "##### Run Hadolint"
files=$(git ls-files docker/\*\*/Dockerfile)
if type hadolint > /dev/null 2>&1; then
    for file in ${files}; do
        hadolint ${file}
    done
elif type docker > /dev/null 2>&1; then
    for file in ${files}; do
        docker run --rm -i hadolint/hadolint < ${file}
    done
else
    warning "[SKIP] hadolint is not installed."
fi
