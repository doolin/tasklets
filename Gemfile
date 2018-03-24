# frozen_string_literal: true

source 'http://rubygems.org'

gem 'rails', '5.1.4'
gem 'pg'
gem 'devise'
gem 'devise_token_auth'
gem 'dynamic_form'
gem 'haml-rails'
gem 'thin'
gem 'foreman'
gem 'unicorn'
gem 'rubocop'
gem 'brakeman'
gem 'rb-fsevent'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'sprockets'
gem 'jquery-rails'
gem 'zurb-foundation', group: :assets

group :production do
  gem 'rails_log_stdout',           github: 'heroku/rails_log_stdout'
  gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'
end

group :test do
  gem 'simplecov', require: false
  gem 'cucumber-rails', require: false
end

group :cucumber, :development, :test do
  gem 'capybara'
  gem 'launchy'
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'
end

group :development do
  gem 'relish'
  gem 'mry'
  gem 'listen'
end

group :test, :development do
  gem 'email_spec'
  gem 'jasmine-rails'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rspec-activemodel-mocks'
end
