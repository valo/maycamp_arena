class AddDefaultValueToContests < ActiveRecord::Migration
  def self.up
    change_column_default :contests, :show_sources, false
  end

  def self.down
    change_column_default :contests, :show_sources, false
  end
end
