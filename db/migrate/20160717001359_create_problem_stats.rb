class CreateProblemStats < ActiveRecord::Migration
  def change
    create_table :problem_stats do |t|
      t.references :problem, index: { unique: true }, null: false
      t.float :percent_success, null: false, default: 0

      t.timestamps null: false
    end
  end
end
