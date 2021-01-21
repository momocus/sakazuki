#!/bin/bash

set -e # exit by error
cd $(cd $(dirname $0); pwd)/../ # cd to project root

# generic

echo "##### Run EOF Check"
./cli-scripts/check_endoffile_with_newline.sh

# node packages

echo "##### Run ESLint"
yarn lint-ts

echo "##### Run markdownlint"
yarn lint-md

echo "##### Run stylelint"
yarn lint-style

# gems

echo "##### Run Rubocop"
bundle exec rubocop

echo "##### Run ERBLint"
bundle exec erblint --lint-all

# docker

echo "##### Run Hadolint"
hadolint Dockerfile
