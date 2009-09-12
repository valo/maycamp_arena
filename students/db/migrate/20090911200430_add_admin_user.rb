class AddAdminUser < ActiveRecord::Migration
  def self.up
    u = User.new(:login => 'root', 
                 :name => "The admin", 
                 :email => "valentin.mihov@gmail.com",
                 :password => "123123",
                 :password_confirmation => "123123")
    u.admin = true
    u.save!
  end

  def self.down
    User.destroy_all(:login => 'root')
  end
end
