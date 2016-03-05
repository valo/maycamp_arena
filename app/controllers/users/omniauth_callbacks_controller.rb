class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def google_oauth2

      auth = request.env["omniauth.auth"]

      user = User.where(:provider => auth.provider, :uid => auth.uid).first

      # first time login with this provider
      unless user
        user = User.where(:email => auth.info.email).last
        # first time login with this provider & no user with such email
        unless user

        # add provider and uid to the last user with this email
        else
          user.provider = auth.provider
          user.uid = auth.uid
          user.save!
        end

      end

      if !user.nil? and user.persisted?
      	self.current_user = user
      	flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"

      	if session[:back]
        	back_path = session[:back]
        	session[:back] = nil
        	redirect_to back_path
      	else
        	redirect_to root_path
      	end

      else
      	flash[:alert] = "Регистрирайте се, за да използвате системата"
      	#FIXME should I prepopulate email, name, login=given_name.downcase ?
      	# delete the extra part of the hash to avoid cookie overflow
      	request.env["omniauth.auth"].delete_if { |k,v| k =~ /\Aextra/ }
        session["devise.google_data"] = request.env["omniauth.auth"]
        redirect_to signup_url
      end
  end

  def failure
  	default_reason = "Комуникационна грешка"
  	reason = default_reason
  	reason = "Отказахте достъп" if params[:error] == "access_denied"

  	flash[:alert] = I18n.t "devise.omniauth_callbacks.failure", 
  		:kind => "Google", :reason => reason
  	redirect_to new_session_path
  end


end