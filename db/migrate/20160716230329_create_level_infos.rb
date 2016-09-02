class CreateLevelInfos < ActiveRecord::Migration
  def change
    create_table :level_infos do |t|
      t.references :user, index: {:unique=>true}, foreign_key: true
      t.integer :level, null: false, default: 1
      t.integer :current_exp, null: false, default: 0
      t.datetime :last_level_showed_at

      t.timestamps null: false
    end
  end
end
