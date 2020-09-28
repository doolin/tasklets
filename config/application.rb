require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tasklets
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Enable the asset pipeline
    config.assets.enabled = true

    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    config.action_mailer.default_url_options = { host: 'localhost:3000' }
  end
end
