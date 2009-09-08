class CreateRuns < ActiveRecord::Migration
  def self.up
    create_table "runs", :force => true do |t|
      t.integer  "problem_id",                      :null => false
      t.integer  "user_id",                         :null => false
      t.datetime "submit_time",                     :null => false
      t.string   "language",    :limit => 16,       :null => false
      t.text     "source_code",                     :null => false
      t.string   "source_name", :limit => 32,       :null => false
      t.text     "about",                           :null => false
      t.string   "status",      :limit => 16,       :null => false
      t.text     "log",                             :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :runs
  end
end
