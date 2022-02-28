require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sakazuki
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults(6.0)

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # For Japanese
    config.i18n.load_path +=
      Dir[Rails.root.join("config/locales/**/*.ja.{rb,yml}")]
    config.i18n.available_locales = %i[en ja]
    config.i18n.default_locale = :ja

    # Timezone
    config.time_zone = "Tokyo"
    config.active_record.default_timezone = :local

    # RSpec
    config.generators do |g|
      g.test_framework(:rspec)
    end
  end
end
