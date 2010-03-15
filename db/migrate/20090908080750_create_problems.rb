class CreateProblems < ActiveRecord::Migration
  def self.up
    create_table "problems", :force => true do |t|
      t.integer "contest_id",               :null => false
      t.string  "letter",     :limit => 16, :null => true
      t.string  "name",       :limit => 64, :null => false
      t.integer "time_limit",               :null => false
      t.text    "about",                    :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :problems
  end
end
