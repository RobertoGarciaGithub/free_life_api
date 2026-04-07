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

ActiveRecord::Schema[8.1].define(version: 2026_04_07_223515) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "accounts", force: :cascade do |t|
    t.string "account_number"
    t.string "account_type", default: "checking", null: false
    t.decimal "balance", precision: 15, scale: 2, default: "0.0", null: false
    t.string "bank_name"
    t.datetime "created_at", null: false
    t.string "currency", default: "BRL", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["account_type"], name: "index_accounts_on_account_type"
  end

  create_table "banks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_banks_on_code", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.string "description"
    t.string "fit_id"
    t.string "memo"
    t.string "transaction_type", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "fit_id"], name: "index_transactions_on_account_id_and_fit_id", unique: true, where: "(fit_id IS NOT NULL)"
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["date"], name: "index_transactions_on_date"
    t.index ["fit_id"], name: "index_transactions_on_fit_id"
    t.index ["transaction_type"], name: "index_transactions_on_transaction_type"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "document", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "updated_at", null: false
    t.index ["document"], name: "index_users_on_document", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "transactions", "accounts"
end
