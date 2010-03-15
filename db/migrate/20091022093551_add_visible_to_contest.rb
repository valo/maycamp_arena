class AddVisibleToContest < ActiveRecord::Migration
  def self.up
    add_column :contests, :visible, :boolean, :default => true
  end

  def self.down
    remove_column :contests, :visible
  end
end
