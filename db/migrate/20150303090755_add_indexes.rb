class AddIndexes < ActiveRecord::Migration
  def change
    add_index :categories_problems, :category_id
    add_index :contest_results, :contest_id
    add_index :contest_results, :user_id
    add_index :problems, :contest_id
    add_index :rating_changes, :user_id
    add_index :run_blob_collections, :run_id
    add_index :runs, :problem_id
    add_index :user_preferences, :user_id
  end
end
