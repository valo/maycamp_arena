class CreateProblemBestScores < ActiveRecord::Migration
  def up
    create_table :problem_best_scores do |t|
      t.references :user, foreign_key: true
      t.references :problem, foreign_key: true
      t.integer :top_points, null: false, default: 0

      t.timestamps null: false
    end

    add_index :problem_best_scores, [:user_id, :problem_id], unique: true
  end

  def down
    drop_table :problem_best_scores
  end
end
