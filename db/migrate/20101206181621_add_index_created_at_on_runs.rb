class AddIndexCreatedAtOnRuns < ActiveRecord::Migration
  def self.up
    add_index :runs, :created_at
  end

  def self.down
    remove_index :runs, :created_at
  end
end
