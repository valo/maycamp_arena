require 'authentication'

class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery
  
  include Authentication

  layout "main"
end
