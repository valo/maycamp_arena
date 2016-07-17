class RemoveExternalContests < ActiveRecord::Migration
  def up
    drop_table :external_contests
    drop_table :external_contest_results
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
