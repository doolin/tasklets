# frozen_string_literal: true

source 'http://rubygems.org'

gem 'rails', '5.1.2'
gem 'sqlite3'
gem 'devise'
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
  gem 'cucumber-rails', require: false
  gem 'rails-controller-testing'
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
  gem 'listen'
end

gem 'jasminerice', git: 'https://github.com/bradphelan/jasminerice.git'

group :test, :development do
  gem 'email_spec'
  gem 'jasmine-rails'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'rspec-activemodel-mocks'
end
