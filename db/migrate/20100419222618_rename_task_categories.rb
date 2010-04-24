class RenameTaskCategories < ActiveRecord::Migration
  def self.up
    rename_table :task_categories, :categories
  end

  def self.down
    rename_table :categories, :task_categories
  end
end
