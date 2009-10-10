# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout "main"
  
  # render new.rhtml
  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      self.current_user = user
      # flash[:notice] = "Вие влязохте успешно"
      
      if user.admin?
        redirect_to :controller => :admin, :action => "index"
      else
        redirect_to root_path
      end
    else
      flash.now[:error] = "Неуспешно влизане с потребителско име '#{params[:login]}'"
      logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
      
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    reset_session
    # flash[:notice] = "Вие излязохте успешно от системата."
    redirect_to root_path
  end
end
