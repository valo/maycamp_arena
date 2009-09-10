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

ActiveRecord::Schema.define(:version => 20090910075449) do

  create_table "contests", :force => true do |t|
    t.string   "set_code",     :limit => 64,                 :null => false
    t.string   "name",         :limit => 128,                :null => false
    t.datetime "start_time",                                 :null => false
    t.integer  "duration",                                   :null => false
    t.integer  "show_sources",                :default => 0, :null => false
    t.text     "about",                                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.datetime "new_time",                  :null => false
    t.string   "file",       :limit => 64,  :null => false
    t.string   "topic",      :limit => 128, :null => false
    t.text     "content",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problems", :force => true do |t|
    t.integer  "contest_id",               :null => false
    t.string   "letter",     :limit => 16
    t.string   "name",       :limit => 64, :null => false
    t.integer  "time_limit",               :null => false
    t.text     "about",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "runs", :force => true do |t|
    t.integer  "problem_id",                :null => false
    t.integer  "user_id",                   :null => false
    t.datetime "submit_time",               :null => false
    t.string   "language",    :limit => 16, :null => false
    t.text     "source_code",               :null => false
    t.string   "source_name", :limit => 32, :null => false
    t.text     "about",                     :null => false
    t.string   "status",      :limit => 16, :null => false
    t.text     "log",                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                                    :default => false
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
