class AddAutoTestToContest < ActiveRecord::Migration
  def self.up
    add_column :contests, :auto_test, :boolean, :default => false
  end

  def self.down
    remove_column :contests, :auto_test
  end
end
