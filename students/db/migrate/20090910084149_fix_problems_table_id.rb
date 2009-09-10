class FixProblemsTableId < ActiveRecord::Migration
  def self.up
    rename_column :problems, :problem_id, :id
    change_column :problems, :letter, :string, :null => true, :default => nil
  end

  def self.down
    change_column :problems, :letter, :string
    rename_column :problems, :id, :problem_id
  end
end
