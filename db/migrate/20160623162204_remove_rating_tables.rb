class RemoveRatingTables < ActiveRecord::Migration
  def up
    drop_table :rating_changes
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
