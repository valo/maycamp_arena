class AddAdminUser < ActiveRecord::Migration
  def self.up
    u = User.new(:login => 'root', 
                 :name => "The admin", 
                 :email => "valentin.mihov@gmail.com")

    u.unencrypted_password = "123123"
    u.unencrypted_password_confirmation = "123123"
    u.encrypted_password = User.devise_encrypt_password("123123") 
    u.admin = true
    u.city = "Sofia"
    u.save!
  end

  def self.down
    User.destroy_all(:login => 'root')
  end
end
