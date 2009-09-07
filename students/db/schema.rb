# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "contests", :primary_key => "contest_id", :force => true do |t|
    t.string   "set_code",     :limit => 64,  :null => false
    t.string   "name",         :limit => 128, :null => false
    t.datetime "start_time",                  :null => false
    t.integer  "duration",                    :null => false
    t.integer  "show_sources",                :null => false
    t.text     "about",                       :null => false
  end

  create_table "news", :primary_key => "new_id", :force => true do |t|
    t.datetime "new_time",                :null => false
    t.string   "file",     :limit => 64,  :null => false
    t.string   "topic",    :limit => 128, :null => false
    t.text     "content",                 :null => false
  end

  create_table "problems", :primary_key => "problem_id", :force => true do |t|
    t.integer "contest_id",               :null => false
    t.string  "letter",     :limit => 16, :null => false
    t.string  "name",       :limit => 64, :null => false
    t.integer "time_limit",               :null => false
    t.text    "about",                    :null => false
  end

  add_index "problems", ["contest_id"], :name => "new_fk_constraint"

  create_table "runs", :primary_key => "run_id", :force => true do |t|
    t.integer  "problem_id",                      :null => false
    t.integer  "user_id",                         :null => false
    t.datetime "submit_time",                     :null => false
    t.string   "language",    :limit => 16,       :null => false
    t.text     "source_code", :limit => 16777215, :null => false
    t.string   "source_name", :limit => 32,       :null => false
    t.text     "about",                           :null => false
    t.string   "status",      :limit => 16,       :null => false
    t.text     "log",                             :null => false
  end

  add_index "runs", ["problem_id"], :name => "fk_problems"
  add_index "runs", ["user_id"], :name => "fk_users"

  create_table "users", :primary_key => "user_id", :force => true do |t|
    t.string  "name",         :limit => 16,                :null => false
    t.string  "pass_md5",     :limit => 64,                :null => false
    t.string  "display_name", :limit => 64,                :null => false
    t.text    "about",                                     :null => false
    t.integer "hidden",                     :default => 0, :null => false
  end

end
