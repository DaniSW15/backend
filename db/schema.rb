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

ActiveRecord::Schema[8.1].define(version: 2026_06_29_221714) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "collaborators", force: :cascade do |t|
    t.string "contract_type", null: false
    t.datetime "created_at", null: false
    t.string "curp", null: false
    t.decimal "daily_salary", precision: 10, scale: 2, null: false
    t.string "department", null: false
    t.string "email", null: false
    t.string "entity_key", null: false
    t.text "fiscal_address", null: false
    t.string "name", null: false
    t.string "position", null: false
    t.string "rfc", null: false
    t.decimal "salary", precision: 10, scale: 2, null: false
    t.string "social_security_number", null: false
    t.date "start_date", null: false
    t.string "state", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_collaborators_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["token"], name: "index_sessions_on_token", unique: true
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.bigint "creator_id"
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.string "phone"
    t.string "rfc", null: false
    t.string "role", default: "user"
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["creator_id"], name: "index_users_on_creator_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["rfc"], name: "index_users_on_rfc", unique: true
  end

  add_foreign_key "collaborators", "users", on_delete: :cascade
  add_foreign_key "sessions", "users", on_delete: :cascade
  add_foreign_key "users", "users", column: "creator_id", on_delete: :nullify
end
