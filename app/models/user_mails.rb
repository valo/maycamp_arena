class UserMails < ActionMailer::Base
  self.default :from => "mentors@maycamp.com",
               :reply_to => "mentors@maycamp.com"
  
  def password_forgot(user)
    @user = user
    
    mail(:to => @user.email, 
         :subject => "Забравена парола за Maycamp Arena")
  end
  
  def notification(users, msg)
    @message_body = msg.body
    mail(:bcc => msg.emails_sent, :subject => msg.subject)
  end
end
