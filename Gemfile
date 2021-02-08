source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.1.1"
# Use Puma as the app server
gem "puma", "~> 5.2"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 5.2.1"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

# Use pg as the database for Active Record
gem "pg"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# For Japanese
gem "enum_help"
gem "rails-i18n"

# For authentication
gem "bcrypt"
gem "devise"
gem "devise-i18n"

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

# Bootstrap icons
gem "bootstrap-icons-helper"

# ElasticSearch
gem "bonsai-elasticsearch-rails"
gem "elasticsearch-model"
gem "elasticsearch-rails"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "letter_opener_web"
  # useful repl pry
  gem "pry"
  gem "pry-byebug"
  gem "pry-doc"
  gem "pry-rails"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
end

group :development do
  gem "annotate"
  gem "better_errors"
  gem "binding_of_caller"
  gem "erb_lint", require: false
  # Access an interactive console on exception pages or by calling 'console'
  # anywhere in the code.
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end
