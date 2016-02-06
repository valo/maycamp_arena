# encoding: utf-8

# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController
  layout "main"

  # render new.rhtml
  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])

    handle_login(user, params[:login])
  end

  def destroy
    logoff
    # flash[:notice] = "Вие излязохте успешно от системата."
    redirect_to root_path
  end

  def facebook
    facebook_email = request.env['omniauth.auth']['info']['email']
    user = User.where(email: facebook_email).last

    handle_login(user, facebook_email)
  end

  private

  def handle_login(user, login)
    if user
      self.current_user = user

      if session[:back]
        back_path = session[:back]
        session[:back] = nil
        redirect_to back_path
      else
        redirect_to root_path
      end
    else
      flash.now[:error] = "Неуспешно влизане с потребителско име '#{login}'"
      logger.warn "Failed login for '#{login}' from #{request.remote_ip} at #{Time.now.utc}"

      @login       = login
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end
end
