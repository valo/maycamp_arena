class AddContesterToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :contester, :boolean, :default => 1

  end

  def self.down
    remove_column :users, :contester

  end
end
