class RemoveAboutFields < ActiveRecord::Migration
  def self.up
    remove_column :contests, :about
    remove_column :problems, :about
  end

  def self.down
    add_column :problems, :about, :text, :null => false
    add_column :contests, :about, :text, :null => false
  end
end
