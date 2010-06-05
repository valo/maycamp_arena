class CreateTaskCategories < ActiveRecord::Migration
  def self.up
    create_table :task_categories, :options => "DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci" do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :task_categories
  end
end
