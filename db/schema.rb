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

ActiveRecord::Schema[7.0].define(version: 2023_12_31_212632) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bills", force: :cascade do |t|
    t.string "bill_name", null: false
    t.decimal "bill_amount", precision: 9, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.decimal "budget"
    t.decimal "spent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "month_stats", force: :cascade do |t|
    t.integer "month"
    t.integer "year"
    t.decimal "total_spent"
    t.decimal "total_saved"
    t.decimal "remaining_budget"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["year", "month"], name: "index_month_stats_on_year_and_month"
  end

  create_table "sheets", force: :cascade do |t|
    t.integer "month", null: false
    t.integer "year", null: false
    t.decimal "income", precision: 9, scale: 2, null: false
    t.decimal "bill_totals", precision: 9, scale: 2, null: false
    t.float "total_spent"
    t.integer "together_budger"
    t.decimal "user_1_budget", precision: 9, scale: 2
    t.decimal "user_1_spent", precision: 9, scale: 2
    t.decimal "user_2_budget", precision: 9, scale: 2
    t.decimal "user_2_spent", precision: 9, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payday_count"
    t.decimal "user_3_spent", precision: 9, scale: 2
    t.decimal "user_3_budget", precision: 9, scale: 2
    t.integer "monthly_service"
    t.decimal "saved", precision: 9, scale: 2, default: "0.0"
    t.decimal "payday_sum", precision: 9, scale: 2
    t.index ["year", "month"], name: "index_sheets_on_year_and_month"
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

  create_table "transactions", force: :cascade do |t|
    t.string "tx_name", null: false
    t.integer "tx_type", null: false
    t.decimal "tx_amount", precision: 9, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "tx_currency", null: false
    t.string "tx_description"
  end

  create_table "users", force: :cascade do |t|
    t.string "key"
    t.string "name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "send_report"
    t.integer "payday_date"
    t.string "discord_username"
    t.string "discord_userid"
    t.string "channel_id"
  end

end
