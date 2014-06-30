class CreateIndexOnRunsUpdatedAt < ActiveRecord::Migration
  def change
    add_index :runs, :updated_at
  end
end
