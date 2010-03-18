class UserMails < ActionMailer::Base
  default_url_options[:host] = "localhost:3000"
  def password_forgot(user)
    recipients user.email
    subject "Забравена парола за Maycamp Arena"
    from "mentors@maycamp.com"
    
    @user = user
  end
end
