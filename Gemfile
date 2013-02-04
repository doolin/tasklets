source 'http://rubygems.org'

gem 'rails', '3.2.11'
gem 'pg'
gem 'devise'
gem 'dynamic_form'
gem 'aws-s3'

# Rails 3.1 - Asset Pipeline
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'json'
gem 'haml'
gem 'sprockets'
gem 'jquery-rails'

gem "zurb-foundation", :group => :assets

group :test do
  gem 'cucumber-rails', require: false
end

group :cucumber, :development, :test do
  gem 'capybara'
  gem 'cucumber'
  gem 'launchy'    # So you can do Then show me the page
end

group :development do
  gem 'yaml_db'
  gem 'relish'
end

group :test do
  gem 'email_spec'
  gem 'sqlite3'
  gem 'rspec-rails', '2.12.2'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end
