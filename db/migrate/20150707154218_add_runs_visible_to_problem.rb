class AddRunsVisibleToProblem < ActiveRecord::Migration
  def up
    add_column :problems, :runs_visible, :boolean
  end

  def down
    remove_column :problems, :runs_visible
  end
end
