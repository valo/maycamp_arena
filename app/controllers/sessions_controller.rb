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
    omniauth_response = request.env['omniauth.auth']
    facebook_email = omniauth_response['info']['email'] if omniauth_response.is_a?(Hash)

    user = User.where(email: facebook_email).last

    handle_login(user, facebook_email)
  end

  def failure
    handle_provider_failure(request.env['omniauth.strategy'].name)
  end

  private

  def handle_login(user, login)
    if user
      handle_success(user)
    else
      handle_failure(login)
    end
  end

  def handle_success(user)
    self.current_user = user

    if session[:back]
      back_path = session[:back]
      session[:back] = nil
      redirect_to back_path
    else
      redirect_to root_path
    end
  end

  def handle_provider_failure(provider)
    handle_failure(nil, provider.capitalize)
  end

  def handle_failure(login = nil, provider = nil)
    flash.now[:error] = login ? "Неуспешно влизане с потребителско име '#{login}'"
                              : "Неуспешно влизане с #{provider}"

    if login
      logger.warn "Failed login for '#{login}' from #{request.remote_ip} at #{Time.now.utc}"
      @login = login
    end

    @remember_me = params[:remember_me]
    render :action => 'new'
  end
end
