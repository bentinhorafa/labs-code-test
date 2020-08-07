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

ActiveRecord::Schema.define(version: 2020_07_29_230905) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
    t.string "full_name", limit: 200, null: false
    t.string "document", limit: 11, null: false
    t.string "address", limit: 200, null: false
    t.date "birthday", null: false
    t.string "gender", limit: 1, null: false
    t.string "password", limit: 8, null: false
    t.string "token", null: false
    t.index ["document"], name: "index_users_on_document", unique: true
    t.index ["token"], name: "index_users_on_token", unique: true
  end

end