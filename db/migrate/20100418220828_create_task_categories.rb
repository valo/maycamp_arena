class CreateTaskCategories < ActiveRecord::Migration
  def self.up
    create_table :task_categories do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :task_categories
  end
end
