require_relative "boot"

require "rails/all"
require "elasticsearch/rails/instrumentation"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sakazuki
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those
    # specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # For Japanese
    config.i18n.load_path +=
      Dir[Rails.root.join("config/locales/**/*.{rb,yml}")]
    config.i18n.available_locales = %i[en ja]
    config.i18n.default_locale = :ja

    # Timezone
    config.time_zone = "Tokyo"
    config.active_record.default_timezone = :local
  end
end
