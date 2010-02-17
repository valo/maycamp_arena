class Session
  attr_reader :session
  
  def initialize(session)
    self.session = session
  end
  
  def logged_user
    User.find_by_user_id(session[:logged_user_id])
  end
  
  def logged_user=(user)
    session[:logged_user_id] = user.id
  end
end
