class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def google_oauth2
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      auth = request.env["omniauth.auth"]
      ap auth

      user = User.where(:provider => auth.provider, :uid => auth.uid).first
      ap user

      # first time login with this provider
      unless user
        user = User.where(:email => auth.info.email).last
        ap user
        # first time login with this provider & no user with such email
        unless user

          		
          user = User.new
          user.provider = auth.provider
          user.uid = auth.uid
          user.email = auth.info.email
          user.password = Devise.friendly_token[0,20]
          user.name = auth.info.name   # assuming the user model has a name
          user.login = auth.info.first_name.downcase
          user.role = "contester"
          #user.unencrypted_password
          #user.city
          ap user.errors.messages
          ap user.valid?
          ap user.errors.messages
          #user.activate
          #user.save!

        # found existing user with this email  
        else
          user.provider = auth.provider
          user.uid = auth.uid
          user.save!
        end

      end


      #user = User.from_omniauth(request.env["omniauth.auth"])
      ap user

      if user.persisted?
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
        session["devise.google_data"] = request.env["omniauth.auth"]
        redirect_to signup_url
      end
  end

  def failure
  	flash[:alert] = I18n.t "devise.omniauth_callbacks.failure", :kind => "Google", :reason => "Отказахте достъп"
  	redirect_to new_session_path
  end


end