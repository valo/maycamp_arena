# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2016_09_03_221446) do

  create_table "categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "description", size: :medium
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_problems", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "category_id"
    t.integer "problem_id"
    t.index ["category_id"], name: "index_categories_problems_on_category_id"
  end

  create_table "configurations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "value"
    t.string "value_type", default: "string", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contest_results", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "contest_id"
    t.integer "user_id"
    t.decimal "points", precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["contest_id"], name: "index_contest_results_on_contest_id"
    t.index ["user_id"], name: "index_contest_results_on_user_id"
  end

  create_table "contest_start_events", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "contest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "contest_id"], name: "index_contest_start_events_on_user_id_and_contest_id", unique: true
  end

  create_table "contests", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "set_code", null: false
    t.string "name", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.integer "duration", null: false
    t.integer "show_sources", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "practicable", default: false
    t.boolean "results_visible", default: false
    t.boolean "auto_test", default: false
    t.boolean "visible", default: true
    t.string "runner_type", default: "box"
    t.boolean "best_submit_results", default: false
    t.integer "group_id", default: 1, null: false
    t.index ["group_id"], name: "index_contests_on_group_id"
  end

  create_table "groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
  end

  create_table "level_infos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "level", default: 1, null: false
    t.integer "current_exp", default: 0, null: false
    t.datetime "last_level_showed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_level_infos_on_user_id", unique: true
  end

  create_table "messages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "subject", null: false
    t.text "body", null: false
    t.text "emails_sent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "new_time", null: false
    t.string "file", limit: 64, null: false
    t.string "topic", limit: 128, null: false
    t.text "content", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problem_best_scores", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "problem_id"
    t.integer "top_points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "fk_rails_b80e9ab572"
    t.index ["user_id", "problem_id"], name: "index_problem_best_scores_on_user_id_and_problem_id", unique: true
  end

  create_table "problem_stats", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "problem_id", null: false
    t.float "percent_success", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_problem_stats_on_problem_id", unique: true
  end

  create_table "problems", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "contest_id", null: false
    t.string "letter", limit: 16
    t.string "name", limit: 64, null: false
    t.decimal "time_limit", precision: 5, scale: 2, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "memory_limit", default: 16777216
    t.string "diff_parameters", default: "", null: false
    t.boolean "runs_visible"
    t.index ["contest_id"], name: "index_problems_on_contest_id"
  end

  create_table "run_blob_collections", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "run_id", null: false
    t.binary "source_code"
    t.binary "log", size: :medium
    t.index ["run_id"], name: "index_run_blob_collections_on_run_id"
  end

  create_table "runs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "problem_id", null: false
    t.integer "user_id", null: false
    t.string "language", null: false
    t.string "status", limit: 1024, default: "pending", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "total_points", precision: 10, scale: 2
    t.float "max_time"
    t.bigint "max_memory"
    t.index ["created_at"], name: "index_runs_on_created_at"
    t.index ["problem_id"], name: "index_runs_on_problem_id"
    t.index ["status", "created_at"], name: "status_created_at", length: { status: 255 }
    t.index ["updated_at"], name: "index_runs_on_updated_at"
    t.index ["user_id", "problem_id"], name: "index_runs_on_user_id_and_problem_id"
  end

  create_table "user_preferences", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.binary "preferences"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "login", limit: 40
    t.string "name", limit: 100, default: ""
    t.string "email", limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "password", limit: 40, null: false
    t.string "city"
    t.string "token", limit: 16
    t.string "role", default: "contester", null: false
    t.index ["login"], name: "index_users_on_login", unique: true
  end

  add_foreign_key "contests", "groups"
  add_foreign_key "level_infos", "users"
  add_foreign_key "problem_best_scores", "problems"
  add_foreign_key "problem_best_scores", "users"
end
