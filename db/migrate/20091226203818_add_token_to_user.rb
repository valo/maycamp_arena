class AddTokenToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :token, :string, :limit => 16
  end

  def self.down
    remove_column :users, :token
  end
end
