# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Add bootstrap-icons to assets path
# https://github.com/rails/cssbundling-rails/pull/76/commits/65861d43a9817b9c795abc786451976cbfbc86c8
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/font")
