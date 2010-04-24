class RenameTaskIdToProblemId < ActiveRecord::Migration
  def self.up
    rename_column :categories_problems, :task_id, :problem_id
  end

  def self.down
    rename_column :categories_problems, :problem_id, :task_id
  end
end
