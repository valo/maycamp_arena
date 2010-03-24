class UserMails < ActionMailer::Base
  default_url_options[:host] = "localhost:3000"
  def password_forgot(user)
    recipients user.email
    reply_to "mentors@maycamp.com"
    subject "Забравена парола за Maycamp Arena"
    from "mentors@maycamp.com"
    
    @user = user
  end
  
  def message(users, msg)
    bcc users.map(&:email).join(", ")
    reply_to "mentors@maycamp.com"
    subject msg.subject
    from "mentors@maycamp.com"
    
    body :body => msg.body
  end
end
