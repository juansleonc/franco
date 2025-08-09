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

ActiveRecord::Schema[8.0].define(version: 2025_08_09_030200) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "admin_fees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "contract_id", null: false
    t.string "period", null: false
    t.integer "base_cents", null: false
    t.decimal "fee_rate_pct", precision: 5, scale: 2, null: false
    t.integer "fee_cents", null: false
    t.string "status", default: "calculated", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id", "period"], name: "index_admin_fees_on_contract_id_and_period", unique: true
  end

  create_table "bank_statements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "account", null: false
    t.date "statement_on", null: false
    t.bigint "imported_by_user_id", null: false
    t.string "original_filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imported_by_user_id"], name: "index_bank_statements_on_imported_by_user_id"
  end

  create_table "contracts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "property_id", null: false
    t.uuid "tenant_id", null: false
    t.date "start_on", null: false
    t.date "end_on", null: false
    t.integer "due_day", null: false
    t.decimal "monthly_rent", precision: 12, scale: 2, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "fee_rate_pct", precision: 5, scale: 2, default: "10.0", null: false
    t.index ["fee_rate_pct"], name: "index_contracts_on_fee_rate_pct"
    t.index ["property_id", "start_on", "end_on"], name: "index_contracts_on_property_id_and_start_on_and_end_on"
  end

  create_table "dunning_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "invoice_id", null: false
    t.string "stage", null: false
    t.datetime "sent_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id", "stage"], name: "index_dunning_events_on_invoice_id_and_stage", unique: true
  end

  create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "contract_id", null: false
    t.uuid "tenant_id", null: false
    t.date "issue_on", null: false
    t.date "due_on", null: false
    t.integer "amount_cents", null: false
    t.integer "balance_cents", null: false
    t.string "currency", default: "USD", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id", "due_on"], name: "index_invoices_on_contract_id_and_due_on"
    t.index ["tenant_id", "status"], name: "index_invoices_on_tenant_id_and_status"
  end

  create_table "owner_statements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "property_id", null: false
    t.string "period", null: false
    t.integer "total_rent_cents", default: 0, null: false
    t.integer "total_expenses_cents", default: 0, null: false
    t.integer "total_fees_cents", default: 0, null: false
    t.integer "net_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id", "period"], name: "index_owner_statements_on_property_id_and_period", unique: true
  end

  create_table "payment_allocations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "payment_id", null: false
    t.uuid "invoice_id", null: false
    t.integer "amount_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_id", "invoice_id"], name: "index_payment_allocations_on_payment_id_and_invoice_id", unique: true
  end

  create_table "payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tenant_id", null: false
    t.date "received_on", null: false
    t.integer "amount_cents", null: false
    t.string "currency", default: "USD", null: false
    t.string "payment_method"
    t.string "reference"
    t.string "status", default: "captured", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id", "received_on"], name: "index_payments_on_tenant_id_and_received_on"
  end

  create_table "properties", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.string "unit"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address", "unit"], name: "index_properties_on_address_and_unit", unique: true
  end

  create_table "statement_lines", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "bank_statement_id", null: false
    t.date "posted_on", null: false
    t.string "description"
    t.integer "amount_cents", null: false
    t.uuid "matched_payment_id"
    t.string "match_status", default: "unmatched", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_statement_id"], name: "index_statement_lines_on_bank_statement_id"
    t.index ["match_status"], name: "index_statement_lines_on_match_status"
    t.index ["matched_payment_id"], name: "index_statement_lines_on_matched_payment_id"
  end

  create_table "suppliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "tax_id", null: false
    t.string "email", null: false
    t.string "phone"
    t.text "bank_account_ciphertext"
    t.bigint "created_by_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_user_id"], name: "index_suppliers_on_created_by_user_id"
    t.index ["email"], name: "index_suppliers_on_email"
    t.index ["tax_id"], name: "index_suppliers_on_tax_id", unique: true
  end

  create_table "tenants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "full_name", null: false
    t.string "email", null: false
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_tenants_on_email", unique: true
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

  add_foreign_key "admin_fees", "contracts"
  add_foreign_key "bank_statements", "users", column: "imported_by_user_id"
  add_foreign_key "contracts", "properties"
  add_foreign_key "contracts", "tenants"
  add_foreign_key "dunning_events", "invoices"
  add_foreign_key "invoices", "contracts"
  add_foreign_key "invoices", "tenants"
  add_foreign_key "owner_statements", "properties"
  add_foreign_key "payment_allocations", "invoices"
  add_foreign_key "payment_allocations", "payments"
  add_foreign_key "payments", "tenants"
  add_foreign_key "statement_lines", "bank_statements"
  add_foreign_key "statement_lines", "payments", column: "matched_payment_id"
  add_foreign_key "suppliers", "users", column: "created_by_user_id"
end
