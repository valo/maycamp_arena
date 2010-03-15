class RehashUserPasses < ActiveRecord::Migration
  def self.up
    User.find_each do |user|
      user.password = ""
      user.save!
    end
  end

  def self.down
  end
end
