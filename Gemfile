source 'https://rubygems.org'

gem 'rails'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3-ruby', :require => 'sqlite3'

# Use unicorn as the web server
gem 'puma'

gem 'mysql2'
gem 'rubyzip'
gem 'zip-zip'
gem 'andand'
gem 'newrelic_rpm'
gem 'will_paginate'
gem 'rubystats'
gem 'dynamic_form'
gem 'rprocfs'
gem 'dalli'
gem 'connection_pool'
gem 'utf8-cleaner'
gem 'coderay'
gem 'pundit'
gem 'codemirror-rails'
gem 'highcharts-rails'
gem 'gon'
gem 'bootstrap-sass', '~> 3.3.5'

group :production do
  gem 'SyslogLogger'
end

group :development do
  gem 'spring'
  gem "spring-commands-rspec"
  gem 'sprockets-rails'
  gem 'uglifier', '>= 1.0.3'
  # Deploy with 
  gem 'sass-rails'
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem "capistrano-db-tasks", require: false
end

group :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers', require: false
  gem 'factory_girl_rails'
  gem 'mocha', :require => 'mocha/api'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails', :require => false
end

gem 'jquery-rails'


# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
