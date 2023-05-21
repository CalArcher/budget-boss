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

ActiveRecord::Schema[7.0].define(version: 2023_05_21_214149) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bills", force: :cascade do |t|
    t.string "bill_name", null: false
    t.integer "bill_amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sheets", force: :cascade do |t|
    t.integer "month", null: false
    t.integer "year", null: false
    t.integer "income", null: false
    t.integer "bill_totals", null: false
    t.integer "total_spent"
    t.integer "together_budger"
    t.integer "user_1_budget"
    t.integer "user_1_spent"
    t.integer "user_2_budget"
    t.integer "user_2_spent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payday_count"
  end

  create_table "text_recieves", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "text_sends", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "texts", force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string "tx_name", null: false
    t.string "tx_type", null: false
    t.integer "tx_amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "tx_currency"
  end

  create_table "user_commands", force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
