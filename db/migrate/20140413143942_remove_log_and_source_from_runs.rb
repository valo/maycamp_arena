class RemoveLogAndSourceFromRuns < ActiveRecord::Migration
  def change
    remove_column :runs, :source_code
    remove_column :runs, :log
  end
end
