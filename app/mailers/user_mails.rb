class UserMails < ActionMailer::Base
  self.default :from => "mentors@maycamp.com",
               :reply_to => "mentors@maycamp.com"
  
  def password_forgot(user)
    @user = user
    
    mail(:to => @user.email, 
         :subject => "Забравена парола за Maycamp Arena")
  end
  
  def notification(users, msg)
    @msg_content = msg.body

    part "text/plain" do |p|
      p.body = render_message "notification.text.plain", :msg_content => @msg_content
    end

    mail(:bcc => msg.emails_sent, :subject => msg.subject)
  end
end
