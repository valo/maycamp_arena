class AddUserProblemIndex < ActiveRecord::Migration
  def self.up
    add_index :runs, [:user_id, :problem_id]
  end

  def self.down
    remove_index :runs, [:user_id, :problem_id]
  end
end
