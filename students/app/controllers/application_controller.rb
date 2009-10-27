# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details
  # filter_parameter_logging :password
  before_filter :set_locale

  layout "main"

  protected
    # Returns true or false if the user is logged in.
    # Preloads @current_user with the user model if they're logged in.
    def logged_in?
      !!current_user
    end

    # Accesses the current user from the session.
    # Future calls avoid the database because nil is not equal to false.
    def current_user
      @current_user ||= login_from_session unless @current_user == false
    end
    
    def current_user=(user)
      session[:user_id] = user.id
      @current_user = user
    end

    # Called from #current_user.  First attempt to login by the user id stored in the session.
    def login_from_session
      self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
    end
    
    def authorized?
      true
    end
    
    def login_required
      redirect_to new_session_path unless (logged_in? and authorized?)
    end
    
    def logoff
      reset_session
    end
    
    def set_locale
      I18n.locale = :bg
    end

    helper_method :current_user, :logged_in?
end
