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

ActiveRecord::Schema.define(:version => 20101016192458) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_problems", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "problem_id"
  end

  create_table "configurations", :force => true do |t|
    t.string   "key",        :default => "",       :null => false
    t.string   "value"
    t.string   "value_type", :default => "string", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contest_results", :force => true do |t|
    t.integer  "contest_id"
    t.integer  "user_id"
    t.decimal  "points",     :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contest_start_events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contest_start_events", ["user_id", "contest_id"], :name => "index_contest_start_events_on_user_id_and_contest_id", :unique => true

  create_table "contests", :force => true do |t|
    t.string   "set_code",        :default => "",    :null => false
    t.string   "name",            :default => "",    :null => false
    t.datetime "start_time",                         :null => false
    t.datetime "end_time",                           :null => false
    t.integer  "duration",                           :null => false
    t.integer  "show_sources",    :default => 0,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "practicable",     :default => false
    t.boolean  "results_visible", :default => false
    t.boolean  "auto_test",       :default => false
    t.boolean  "visible",         :default => true
  end

  create_table "external_contest_results", :force => true do |t|
    t.integer  "external_contest_id"
    t.string   "coder_name"
    t.string   "city"
    t.integer  "user_id"
    t.integer  "points",              :limit => 10, :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "external_contests", :force => true do |t|
    t.string   "name"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "subject",     :default => "", :null => false
    t.text     "body",                        :null => false
    t.text     "emails_sent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.datetime "new_time",                                  :null => false
    t.string   "file",       :limit => 64,  :default => "", :null => false
    t.string   "topic",      :limit => 128, :default => "", :null => false
    t.text     "content",                                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problems", :force => true do |t|
    t.integer  "contest_id",                                                                     :null => false
    t.string   "letter",       :limit => 16
    t.string   "name",         :limit => 64,                               :default => "",       :null => false
    t.decimal  "time_limit",                 :precision => 5, :scale => 2,                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "memory_limit",                                             :default => 16777216
  end

  create_table "rating_changes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contest_result_id"
    t.string   "contest_result_type"
    t.integer  "previous_rating_change_id"
    t.decimal  "rating",                    :precision => 10, :scale => 2
    t.decimal  "volatility",                :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "runs", :force => true do |t|
    t.integer  "problem_id",                                                         :null => false
    t.integer  "user_id",                                                            :null => false
    t.string   "language",                                    :default => "",        :null => false
    t.binary   "source_code",                                                        :null => false
    t.string   "status",                                      :default => "pending", :null => false
    t.text     "log"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "total_points", :precision => 10, :scale => 2
    t.float    "max_time"
    t.integer  "max_memory"
  end

  add_index "runs", ["user_id", "problem_id"], :name => "index_runs_on_user_id_and_problem_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "login",      :limit => 40
    t.string   "name",       :limit => 100, :default => ""
    t.string   "email",      :limit => 100
    t.string   "city",       :limit => 100, :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                     :default => false
    t.string   "password",   :limit => 40
    t.string   "token",      :limit => 16
    t.boolean  "contester",                 :default => true
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
