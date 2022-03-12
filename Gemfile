source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "= 7.0.2.2"

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"

# Use PostgeSQL as the database for Active Record
gem "pg"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
# gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
# gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# For Japanese
gem "enum_help"
gem "rails-i18n"

# For authentication
gem "bcrypt"
gem "devise"
gem "devise-i18n"
gem "devise_invitable"

# Create seed data files from the existing data in database
gem "seed_dump"

# For image uploading
gem "carrierwave"
gem "cloudinary"

# For twitter card
gem "meta-tags"

# For complex search
gem "ransack"

# Pagination
gem "kaminari"
gem "kaminari-i18n"

# Japanese Era
gem "era_ja"

# ElasticSearch
# Do not update, because released gems have not adapted to Ruby 3 yet.
gem "bonsai-elasticsearch-rails"
gem "elasticsearch", ">=7.13", "< 7.14"
gem "elasticsearch-model", ">=7.2.1"
gem "elasticsearch-rails", ">=7.2.1"

group :development, :test do
  # Auto annotation to schema
  gem "annotate"

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]

  # Use .env file
  gem "dotenv-rails"

  # FactoryBot for RSpec
  gem "factory_bot_rails"

  # Mailer
  gem "letter_opener_web"

  # parallel test
  gem "parallel_tests"

  # RSpec
  gem "rspec-rails"

  # Rubocop
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :development do
  # Useful debugger in browser
  gem "better_errors"
  gem "binding_of_caller"

  # Lint ERB files
  gem "erb_lint", require: false

  # Listen to file modifications
  gem "listen"

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"

  # For robe completion
  gem "yard"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"

  # Selenium
  gem "selenium-webdriver"

  # Simple coverage
  gem "simplecov"

  # Webdriver
  gem "webdrivers"
end
