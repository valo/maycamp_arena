# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout "main"
  
  # render new.rhtml
  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      if user.admin?
        redirect_to :controller => :admin, :action => "index"
      else
        redirect_to root_path
      end
      flash[:notice] = "Вие влязохте успешно"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Неуспешно влизане с потребителско име '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
