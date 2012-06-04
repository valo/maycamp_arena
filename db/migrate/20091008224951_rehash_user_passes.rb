class RehashUserPasses < ActiveRecord::Migration
  def self.up
    User.find_each do |user|
	  user.unencrypted_password = "123123"
	  user.unencrypted_password_confirmation = "123123"
      user.save!
    end
  end

  def self.down
  end
end
