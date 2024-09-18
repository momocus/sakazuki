ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

# Railsのセットアップなので順番を変更しない
# rubocop:disable Style/RequireOrder
require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.
# rubocop:enable Style/RequireOrder
