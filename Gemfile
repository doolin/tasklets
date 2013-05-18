source 'http://rubygems.org'
ruby '2.0.0'

gem 'rails4_upgrade'

gem 'rails', '4.0.0.rc1'
gem 'pg'
gem 'devise', '3.0.0.rc'
gem 'dynamic_form'
gem 'aws-s3'
gem 'haml-rails'
gem 'thin'
gem 'foreman'
gem 'unicorn'

gem 'protected_attributes'
gem 'rb-fsevent'

group :production do
  gem 'rails_log_stdout',           github: 'heroku/rails_log_stdout'
  gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'
end

# Rails 3.1 - Asset Pipeline
group :assets do
  gem 'sass-rails', '4.0.0.rc1'
  gem 'coffee-rails', '~>4.0.0'
  gem 'uglifier'
end

gem 'haml'
gem 'sprockets'
gem 'jquery-rails'

gem "zurb-foundation", :group => :assets

group :test do
  gem 'cucumber-rails', require: false
end

group :cucumber, :development, :test do
  gem 'capybara'
  gem 'launchy'    # So you can do Then show me the page
end

group :development do
  gem 'yaml_db'
  gem 'relish'
end

gem 'jasminerice', :git => 'https://github.com/bradphelan/jasminerice.git'

group :test, :development do
  gem 'email_spec'
  gem 'jasmine'
  gem 'jasmine-headless-webkit'
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end
