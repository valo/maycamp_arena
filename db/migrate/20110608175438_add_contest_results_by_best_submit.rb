class AddContestResultsByBestSubmit < ActiveRecord::Migration
  def self.up
    add_column :contests, :best_submit_results, :boolean, :default => false
  end

  def self.down
    remove_column :contests, :best_submit_results
  end
end
