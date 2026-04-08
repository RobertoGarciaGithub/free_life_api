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

ActiveRecord::Schema[8.1].define(version: 2026_04_08_191736) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "accountable_id", null: false
    t.string "accountable_type", null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "BRL", null: false
    t.uuid "bank_id", null: false
    t.datetime "created_at", null: false
    t.integer "profitability", null: false
    t.datetime "updated_at", null: false
    t.index ["accountable_type", "accountable_id"], name: "index_accounts_on_accountable"
    t.index ["bank_id"], name: "index_accounts_on_bank_id"
  end

  create_table "banks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_banks_on_code", unique: true
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.integer "budget_cents", default: 0, null: false
    t.string "budget_currency", default: "BRL", null: false
    t.integer "category_type", null: false
    t.datetime "created_at", null: false
    t.string "icon", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_categories_on_account_id"
  end

  create_table "enterprises", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "cnpj", null: false
    t.datetime "created_at", null: false
    t.string "legal_name", null: false
    t.uuid "owner_id", null: false
    t.string "trade_name"
    t.datetime "updated_at", null: false
    t.index ["cnpj"], name: "index_enterprises_on_cnpj", unique: true
    t.index ["owner_id"], name: "index_enterprises_on_owner_id"
  end

  create_table "transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "BRL", null: false
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.integer "status", default: 0, null: false
    t.uuid "target_id"
    t.string "target_type"
    t.uuid "transactable_id", null: false
    t.string "transactable_type", null: false
    t.integer "transactions_type", default: 0, null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["target_type", "target_id"], name: "index_transactions_on_target"
    t.index ["transactable_type", "transactable_id"], name: "index_transactions_on_transactable"
    t.index ["user_id"], name: "index_transactions_on_user_id"
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

  add_foreign_key "accounts", "banks"
  add_foreign_key "categories", "accounts"
  add_foreign_key "enterprises", "users", column: "owner_id"
  add_foreign_key "transactions", "users"
end
