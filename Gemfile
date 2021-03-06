# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.7.2'

gem 'rails', '6.1.3.1'
gem 'pg'
gem 'devise'
gem 'devise_token_auth'
gem 'haml-rails'
# gem 'thin'
# http://blog.daviddollar.org/2011/05/06/introducing-foreman.html
# The advice from https://github.com/ddollar/foreman is to _not_
# put `foreman` in the Gemfile, install is using `gem install foreman`
# Hence taking it out.
# gem 'foreman'
gem 'unicorn'
gem 'brakeman'
gem 'rb-fsevent'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'sprockets'
gem 'jquery-rails'
gem 'zurb-foundation', group: :assets
gem 'coverband'
gem 'aws-sdk-secretsmanager'
gem 'sentry-raven'
gem 'flay'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :test do
  gem 'simplecov', require: false
end

group :cucumber, :development, :test do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'launchy'
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'
end

group :development do
  gem 'awesome_print'
  gem 'relish'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rubocop-performance'
  gem 'listen'
end

group :test, :development do
  gem 'email_spec'
  gem 'bundle-audit', require: false
  gem 'jasmine-rails'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rspec-activemodel-mocks'
  gem 'rubycritic'
end

gem 'webpacker', '~> 5.2'
