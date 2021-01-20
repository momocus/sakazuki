#!/bin/bash

# exit by error
set -e

# generic

echo "##### Run EOF Check"
$(cd $(dirname $0); pwd)/check_endoffile_with_newline.sh

# js-ts

echo "##### Run ESLint"
yarn lint

# ruby

echo "##### Run Rubocop"
bundle exec rubocop

echo "##### Run ERBLint"
bundle exec erblint --lint-all
