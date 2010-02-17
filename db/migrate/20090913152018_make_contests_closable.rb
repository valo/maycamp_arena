class MakeContestsClosable < ActiveRecord::Migration
  def self.up
    add_column :contests, :practicable, :boolean, :default => false
  end

  def self.down
    remove_column :contests, :practicable
  end
end
