# frozen_string_literal: true

source 'http://rubygems.org'

gem 'rails', '6.0.3.3'
gem 'pg'
gem 'devise'
gem 'devise_token_auth'
gem 'haml-rails'
gem 'thin'
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
  gem 'relish'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rubocop-performance'
  gem 'mry'
  gem 'listen'
end

group :test, :development do
  gem 'email_spec'
  gem 'jasmine-rails'
  gem 'rspec-rails', '~> 4.0.0.beta2'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rspec-activemodel-mocks'
  gem 'rubycritic'
end
