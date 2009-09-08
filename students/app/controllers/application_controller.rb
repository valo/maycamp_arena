# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  include AuthenticatedSystem

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
    def verify_logged_in
      @logged_user = User.find_by_user_id(session[:logged_user_id])
    
      if !@logged_user
        redirect_to :controller => :users, :action => "login"
      end
    end
end
