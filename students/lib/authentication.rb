module Authentication
  def self.included(base)
    base.helper_method :current_user, :logged_in?
  end
  
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
      session[:back] = nil
      if !logged_in? or !authorized?
        session[:back] = request.url if !logged_in?
        redirect_to new_session_path
      end
    end
    
    def logoff
      reset_session
    end
end