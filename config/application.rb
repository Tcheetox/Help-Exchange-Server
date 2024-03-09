require_relative 'boot'

require 'rails' 
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_cable/engine'
#require 'rmagick'

require 'google/apis/gmail_v1'
gmail = Google::Apis::GmailV1::GmailService.new

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HelpexchangeServer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.api_only = true
    config.debug_exception_response_format = :default
    config.load_defaults 6.0
    
    config.time_zone = "Europe/Brussels"
    config.active_record.default_timezone = :local

    config.autoload_paths << Rails.root.join('lib', 'assets')

    if Rails.env.production?
      config.autoloader = :classic
    end

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
