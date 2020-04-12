source 'https://rubygems.org'

gem 'rails'

# Use unicorn as the web server
gem 'puma'

gem 'mysql2'
gem 'rubyzip'
gem 'zip-zip'
gem 'andand'
gem 'newrelic_rpm'
gem 'will_paginate-bootstrap'
gem 'rubystats'
gem 'dynamic_form'
gem 'rprocfs'
gem 'dalli'
gem 'connection_pool'
gem 'utf8-cleaner'
gem 'coderay'
gem 'pundit'
gem 'codemirror-rails'
gem 'bootstrap-sass'
gem 'highcharts-rails'
gem 'gon'
gem 'js_cookie_rails'
gem 'sass-rails'
gem 'draper'
gem 'sidekiq'

group :production do
  gem 'SyslogLogger'
end

group :development do
  gem 'spring'
  gem "spring-commands-rspec"
  gem 'sprockets-rails'
  gem 'uglifier', '>= 1.0.3'
  # Deploy with
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-db-tasks', require: false
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'
end

group :test do
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 4.0.0'
  gem 'shoulda-matchers'
  gem 'factory_bot_rails'
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
