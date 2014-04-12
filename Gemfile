source 'http://rubygems.org'

gem 'rails', '~> 3.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3-ruby', :require => 'sqlite3'

# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

gem 'mysql2'
gem 'rubyzip', :require => "zip/zip"
gem 'andand'
gem 'hoptoad_notifier'
gem 'newrelic_rpm'
gem 'will_paginate'
gem 'rubystats'
gem 'dynamic_form'
gem 'rprocfs'
gem 'memcache-client'

group :production do
  gem 'SyslogLogger'
end

group :test do
  gem 'factory_girl_rails'
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'mocha', :require => 'mocha/api'
  gem 'launchy'
	# gem 'ruby-debug'
end

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
