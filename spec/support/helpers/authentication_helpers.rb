module AutenticationHelpers
  def sign_in(user)
    session[:user_id] = user.id

    allow(controller).to receive(:current_user).and_return(user)
  end

end
