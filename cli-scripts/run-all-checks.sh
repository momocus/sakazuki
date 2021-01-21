#!/bin/bash

set -e # exit by error
cd $(cd $(dirname $0); pwd)/../ # cd to project root

# generic

echo "##### Run EOF Check"
./cli-scripts/check_endoffile_with_newline.sh

# js-ts

echo "##### Run ESLint"
yarn lint

# ruby

echo "##### Run Rubocop"
bundle exec rubocop

echo "##### Run ERBLint"
bundle exec erblint --lint-all
