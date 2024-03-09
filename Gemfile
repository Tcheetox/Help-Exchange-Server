source 'https://rubygems.org'

ruby '3.3.0'

# Authentication and Users
gem 'devise', '>= 4.8'
gem 'doorkeeper', '>= 5.4'
gem 'rack-cors', '>= 1.1.1'
gem 'figaro', '>= 1.2.0'
# First install necessary dependencies 'sudo apt-get install libmagickwand-dev'
#gem 'rmagick', '>= 5.3.0' 
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 6.1.4.1'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.5.3'
# Use Puma as the app server
gem 'puma', '>= 4.3.1'
# Google SSO
gem 'google_sign_in', '>= 1.2.0'
#gem 'google-api-client'
gem 'google-apis-gmail_v1', '>= 0.11.0'
gem 'googleauth', '>= 1.1.0'
gem 'mail', '>= 2.7.1'

# Use SCSS for stylesheets
# gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'

gem 'redis', '>= 4.5.1'
gem 'redis-namespace', '>= 1.8.1'
gem 'redis-rails', '>= 5.0.2'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# DOES NOT WORK because of permission denied - supposed to reduce boot times through caching; required in config/boot.rb
#gem 'bootsnap', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'ffi', '>= 1.15.4'
  gem 'rspec-rails', '>= 4.0.2'
  gem 'seed_dump', '>= 3.3.1'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.2.0'
end

# group :test do
#   # Adds support for Capybara system testing and selenium driver
#   gem 'capybara', '>= 2.15'
#   gem 'selenium-webdriver'
#   # Easy installation and use of web drivers to run system tests with browsers
#   gem 'webdrivers'
# end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "tzinfo-data", "~> 1.2024"
