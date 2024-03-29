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

ActiveRecord::Schema[7.0].define(version: 2023_07_30_153847) do
  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "receipt_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "receipt_details", force: :cascade do |t|
    t.string "name"
    t.float "price", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "receipt_id", null: false
    t.integer "receipt_category_id"
  end

  create_table "receipt_discounts", force: :cascade do |t|
    t.float "discount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "receipt_id"
    t.text "comment"
    t.integer "receipt_category_id"
    t.index ["receipt_id"], name: "index_receipt_discounts_on_receipt_id"
  end

  create_table "receipt_prices", force: :cascade do |t|
    t.integer "receipt_id", null: false
    t.integer "account_id", null: false
    t.float "price", null: false
  end

  create_table "receipts", force: :cascade do |t|
    t.date "date", null: false
    t.text "comment"
    t.boolean "is_income"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.text "store"
  end

  add_foreign_key "receipt_details", "receipt_categories"
  add_foreign_key "receipt_details", "receipts"
  add_foreign_key "receipt_discounts", "receipt_categories"
  add_foreign_key "receipt_discounts", "receipts"
end
