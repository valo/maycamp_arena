# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  include Authentication
  
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password
  before_filter :set_locale

  layout "main"

  protected
    def set_locale
      I18n.locale = :bg
    end
end
