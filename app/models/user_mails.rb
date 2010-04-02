class UserMails < ActionMailer::Base
  def password_forgot(user)
    recipients user.email
    reply_to "mentors@maycamp.com"
    subject "Забравена парола за Maycamp Arena"
    from "mentors@maycamp.com"
    
    @user = user
  end
  
  def message(users, msg)
    bcc msg.emails_sent
    reply_to "mentors@maycamp.com"
    subject msg.subject
    from "mentors@maycamp.com"
    content_type "text/plain"
    
    body :body => msg.body
  end
end
