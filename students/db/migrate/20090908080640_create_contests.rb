class CreateContests < ActiveRecord::Migration
  def self.up
    create_table "contests", :force => true do |t|
      t.string   "set_code",     :limit => 64,  :null => false
      t.string   "name",         :limit => 128, :null => false
      t.datetime "start_time",                  :null => false
      t.integer  "duration",                    :null => false
      t.integer  "show_sources",                :null => false
      t.text     "about",                       :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :contests
  end
end
