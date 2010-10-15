class FixUserModel < ActiveRecord::Migration
  def self.up
    remove_column :users, :crypted_password
    remove_column :users, :salt
    remove_column :users, :remember_token
    remove_column :users, :remember_token_expires_at
    add_column :users, :password, :string, :limit => 40
  end

  def self.down
    remove_column :users, :password
    add_column :users, :remember_token_expires_at, :datetime
    add_column :users, :remember_token, :string,            :limit => 40
    add_column :users, :salt, :string,                      :limit => 40
    add_column :users, :crypted_password, :string,          :limit => 40
  end
end
