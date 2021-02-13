require_relative 'boot'

require "rails" # Instead of 'rails/all'
# Pick the frameworks you want:
# require "active_model/railtie"
# require "active_job/railtie"
# require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
# require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HelpexchangeServer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.api_only = true
    config.debug_exception_response_format = :default
    config.load_defaults 6.0
    config.autoload_paths << "#{Rails.root}/lib/assets"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Attempt at enabling CORS
    # config.middleware.insert_before 0, "Rack::Cors" do
    #   allow do
    #     origins '*'
    #     resource '*', :headers => :any, :methods => [:get, :post, :options]
    #   end
    # end

  end
end
