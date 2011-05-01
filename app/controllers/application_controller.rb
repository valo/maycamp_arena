require 'authentication'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include Authentication

  layout "main"
end
