source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "= 6.1.4.1"
# Use Puma as the app server
gem "puma"
# Use SCSS for stylesheets
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# Do not update, see https://github.com/momocus/sakazuki/milestone/1
gem "webpacker", "= 5.4.3"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

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
gem "elasticsearch", ">= 7.13", "< 7.14"
gem "elasticsearch-model", github: "indirect/elasticsearch-rails"
gem "elasticsearch-rails", ">= 7.1", "< 7.2"

group :development, :test do
  gem "annotate"
  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "letter_opener_web"
  # parallel test
  gem "parallel_tests"
  # useful repl pry
  gem "pry"
  gem "pry-byebug"
  gem "pry-doc"
  gem "pry-rails"
  gem "rspec-rails"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "erb_lint", require: false
  # Access an interactive console on exception pages or by calling 'console'
  # anywhere in the code.
  gem "web-console"
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen"
  # For robe completion
  gem "yard"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end
