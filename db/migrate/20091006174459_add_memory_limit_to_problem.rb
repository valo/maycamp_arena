class AddMemoryLimitToProblem < ActiveRecord::Migration
  def self.up
    # Default memory limit of 16MB
    add_column :problems, :memory_limit, :integer, :default => 16777216
  end

  def self.down
    remove_column :problems, :memory_limit
  end
end
