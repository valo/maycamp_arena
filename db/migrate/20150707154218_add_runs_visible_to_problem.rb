class AddRunsVisibleToProblem < ActiveRecord::Migration
  def change
    add_column :problems, :runs_visible, :boolean
  end
end
