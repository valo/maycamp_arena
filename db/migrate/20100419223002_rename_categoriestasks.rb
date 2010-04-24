class RenameCategoriestasks < ActiveRecord::Migration
  def self.up
    rename_table :categoriestasks, :categories_problems
  end

  def self.down
    rename_table :categories_problems, :categoriestasks
  end
end
