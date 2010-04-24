class AddCategoriesTasks < ActiveRecord::Migration
  def self.up
    create_table :categoriestasks, :id => false do |t|
      t.column "category_id", :integer
      t.column "task_id", :integer
    end
  end

  def self.down
    drop_table :categoriestasks
  end
end
