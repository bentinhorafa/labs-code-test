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

ActiveRecord::Schema.define(version: 2020_08_19_034333) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.integer "type", null: false
    t.decimal "amount", null: false
    t.bigint "transfer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_account_transactions_on_account_id"
    t.index ["transfer_id"], name: "index_account_transactions_on_transfer_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "branch", limit: 4, null: false
    t.string "account_number", limit: 5, null: false
    t.decimal "limit", default: "0.0", null: false
    t.datetime "last_limit_update", null: false
    t.decimal "balance"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["branch", "account_number"], name: "index_accounts_on_branch_and_account_number", unique: true
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.integer "origin_id", null: false
    t.integer "destiny_id", null: false
    t.decimal "amount", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["destiny_id"], name: "index_transfers_on_destiny_id"
    t.index ["origin_id"], name: "index_transfers_on_origin_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name", limit: 200, null: false
    t.string "document", limit: 11, null: false
    t.string "address", limit: 200, null: false
    t.date "birthday", null: false
    t.string "gender", limit: 1, null: false
    t.string "password", limit: 8, null: false
    t.string "token", limit: 100, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["document"], name: "index_users_on_document", unique: true
    t.index ["token"], name: "index_users_on_token", unique: true
  end

  add_foreign_key "account_transactions", "accounts"
  add_foreign_key "account_transactions", "transfers"
  add_foreign_key "accounts", "users"
end
