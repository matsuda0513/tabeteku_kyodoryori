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

ActiveRecord::Schema[7.0].define(version: 2024_08_16_025547) do
  create_table "english_foods", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "prefecture", null: false
    t.text "history", null: false
    t.string "image_url", null: false
    t.string "image_credit"
    t.string "detail_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "food_id"
    t.string "food_name"
    t.index ["detail_url"], name: "index_english_foods_on_detail_url", unique: true
    t.index ["name"], name: "index_english_foods_on_name"
    t.index ["prefecture"], name: "index_english_foods_on_prefecture"
  end

  create_table "foods", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "prefecture", null: false
    t.text "history", null: false
    t.string "image_url", null: false
    t.string "image_credit"
    t.string "detail_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["detail_url"], name: "index_foods_on_detail_url", unique: true
    t.index ["name"], name: "index_foods_on_name"
    t.index ["prefecture"], name: "index_foods_on_prefecture"
  end

end
