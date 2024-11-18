# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_11_18_094306) do
  create_table "cards", force: :cascade do |t|
    t.integer "game_id"
    t.integer "card_id"
    t.integer "position"
    t.boolean "flip_state"
    t.boolean "found"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_cards_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "iden"
    t.string "status"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "saved_games", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "game_name"
    t.text "game_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "game_name"], name: "index_saved_games_on_user_id_and_game_name", unique: true
    t.index ["user_id"], name: "index_saved_games_on_user_id"
  end

  create_table "scores", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "game_name"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_scores_on_user_id"
  end

  create_table "sudoku_games", force: :cascade do |t|
    t.json "user_board", default: [], null: false
    t.json "win_board", default: [], null: false
    t.json "initial_board", default: [], null: false
    t.string "status", default: "in_progress"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cards", "games"
  add_foreign_key "saved_games", "users"
  add_foreign_key "scores", "users"
end
