source 'http://rubygems.org'

# gem 'rails4_upgrade'

gem 'rails', '4.2.3'
gem 'sqlite3'
gem 'devise', '3.5.1'
gem 'dynamic_form'
# gem 'aws-s3'
gem 'haml-rails'
gem 'thin'
gem 'foreman'
gem 'unicorn'

gem 'rb-fsevent'

group :production do
  gem 'rails_log_stdout',           github: 'heroku/rails_log_stdout'
  gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'
end

gem 'sass-rails'
gem 'coffee-rails' #, '~>4.0.0'
gem 'uglifier'

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
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'
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
  gem 'guard-jasmine'
  gem 'jasmine-stories'
  gem 'rspec-rails', '2.99'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'rspec-activemodel-mocks'
end
