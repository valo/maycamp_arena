# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160304143917) do

  create_table "categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_problems", id: false, force: :cascade do |t|
    t.integer "category_id", limit: 4
    t.integer "problem_id",  limit: 4
  end

  add_index "categories_problems", ["category_id"], name: "index_categories_problems_on_category_id", using: :btree

  create_table "configurations", force: :cascade do |t|
    t.string   "key",        limit: 255,                    null: false
    t.string   "value",      limit: 255
    t.string   "value_type", limit: 255, default: "string", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contest_results", force: :cascade do |t|
    t.integer  "contest_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.decimal  "points",               precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contest_results", ["contest_id"], name: "index_contest_results_on_contest_id", using: :btree
  add_index "contest_results", ["user_id"], name: "index_contest_results_on_user_id", using: :btree

  create_table "contest_start_events", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "contest_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contest_start_events", ["user_id", "contest_id"], name: "index_contest_start_events_on_user_id_and_contest_id", unique: true, using: :btree

  create_table "contests", force: :cascade do |t|
    t.string   "set_code",            limit: 255,                 null: false
    t.string   "name",                limit: 255,                 null: false
    t.datetime "start_time",                                      null: false
    t.datetime "end_time",                                        null: false
    t.integer  "duration",            limit: 4,                   null: false
    t.integer  "show_sources",        limit: 4,   default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "practicable",                     default: false
    t.boolean  "results_visible",                 default: false
    t.boolean  "auto_test",                       default: false
    t.boolean  "visible",                         default: true
    t.string   "runner_type",         limit: 255, default: "box"
    t.boolean  "best_submit_results",             default: false
    t.integer  "group_id",            limit: 4,   default: 1,     null: false
  end

  add_index "contests", ["group_id"], name: "index_contests_on_group_id", using: :btree

  create_table "external_contest_results", force: :cascade do |t|
    t.integer  "external_contest_id", limit: 4
    t.string   "coder_name",          limit: 255
    t.string   "city",                limit: 255
    t.integer  "user_id",             limit: 4
    t.decimal  "points",                          precision: 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "external_contests", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "messages", force: :cascade do |t|
    t.string   "subject",     limit: 255,   null: false
    t.text     "body",        limit: 65535, null: false
    t.text     "emails_sent", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", force: :cascade do |t|
    t.datetime "new_time",                 null: false
    t.string   "file",       limit: 64,    null: false
    t.string   "topic",      limit: 128,   null: false
    t.text     "content",    limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problems", force: :cascade do |t|
    t.integer  "contest_id",      limit: 4,                                              null: false
    t.string   "letter",          limit: 16
    t.string   "name",            limit: 64,                                             null: false
    t.decimal  "time_limit",                  precision: 5, scale: 2,                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "memory_limit",    limit: 4,                           default: 16777216
    t.string   "diff_parameters", limit: 255,                         default: "",       null: false
    t.boolean  "runs_visible"
  end

  add_index "problems", ["contest_id"], name: "index_problems_on_contest_id", using: :btree

  create_table "rating_changes", force: :cascade do |t|
    t.integer  "user_id",                   limit: 4
    t.integer  "contest_result_id",         limit: 4
    t.string   "contest_result_type",       limit: 255
    t.integer  "previous_rating_change_id", limit: 4
    t.decimal  "rating",                                precision: 10, scale: 2
    t.decimal  "volatility",                            precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rating_changes", ["user_id"], name: "index_rating_changes_on_user_id", using: :btree

  create_table "run_blob_collections", force: :cascade do |t|
    t.integer "run_id",      limit: 4,        null: false
    t.binary  "source_code", limit: 65535
    t.binary  "log",         limit: 16777215
  end

  add_index "run_blob_collections", ["run_id"], name: "index_run_blob_collections_on_run_id", using: :btree

  create_table "runs", force: :cascade do |t|
    t.integer  "problem_id",   limit: 4,                                                 null: false
    t.integer  "user_id",      limit: 4,                                                 null: false
    t.string   "language",     limit: 255,                                               null: false
    t.string   "status",       limit: 1024,                          default: "pending", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "total_points",              precision: 10, scale: 2
    t.float    "max_time",     limit: 24
    t.integer  "max_memory",   limit: 8
  end

  add_index "runs", ["created_at"], name: "index_runs_on_created_at", using: :btree
  add_index "runs", ["problem_id"], name: "index_runs_on_problem_id", using: :btree
  add_index "runs", ["status", "created_at"], name: "status_created_at", length: {"status"=>255, "created_at"=>nil}, using: :btree
  add_index "runs", ["updated_at"], name: "index_runs_on_updated_at", using: :btree
  add_index "runs", ["user_id", "problem_id"], name: "index_runs_on_user_id_and_problem_id", using: :btree

  create_table "user_preferences", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.binary   "preferences", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_preferences", ["user_id"], name: "index_user_preferences_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "login",      limit: 40
    t.string   "name",       limit: 100, default: ""
    t.string   "email",      limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password",   limit: 40,                        null: false
    t.string   "city",       limit: 255
    t.string   "token",      limit: 16
    t.string   "role",       limit: 255, default: "contester", null: false
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

  add_foreign_key "contests", "groups"
end
