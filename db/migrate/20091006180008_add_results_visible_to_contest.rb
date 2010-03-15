class AddResultsVisibleToContest < ActiveRecord::Migration
  def self.up
    add_column :contests, :results_visible, :boolean, :default => false
  end

  def self.down
    remove_column :contests, :results_visible
  end
end
