source 'http://rubygems.org'

gem 'rails', '3.1.10'
gem 'pg'
gem 'devise'
gem 'dynamic_form'
gem 'aws-s3'

# Rails 3.1 - Asset Pipeline
gem 'json'
gem 'sass'
gem 'haml'
gem 'coffee-script'
gem 'uglifier'
gem 'sprockets'

gem 'jquery-rails'

gem "zurb-foundation", :group => :assets

group :production do
  gem 'therubyracer-heroku'
end

group :cucumber, :development, :test do
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
end

group :development do
  gem 'rspec-rails'
  gem 'yaml_db'
  gem 'relish'
end

group :test do
  gem 'email_spec'
  gem 'sqlite3'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'autotest'
  gem 'webrat', '0.7.2'
  gem 'factory_girl_rails', '1.0'
#  gem 'cover_me', '>= 1.0.0.rc2'
end
