class Message < ActiveRecord::Base
  validates_presence_of :subject, :body
  
  def deliver
    if RAILS_ENV == "development"
      self.emails_sent = User.first.email
      UserMails.deliver_message([User.first], self)
    else
      self.emails_sent = User.all.map(&:email).select { |e| e =~ /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i }.join(', ')
      UserMails.deliver_message(User.all, self)
    end
    save
  end
end