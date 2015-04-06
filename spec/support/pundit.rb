# Require shoulda matchers before the pundit, because pundit's permit matcher
# is also defined in the shoulda matchers for validating parameter whitelisting
# in controllers
require 'shoulda/matchers'
require "pundit/rspec"
