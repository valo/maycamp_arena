class CreateNews < ActiveRecord::Migration
  def self.up
    create_table "news", :force => true do |t|
      t.datetime "new_time",                :null => false
      t.string   "file",     :limit => 64,  :null => false
      t.string   "topic",    :limit => 128, :null => false
      t.text     "content",                 :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end
