class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices, id: :uuid do |t|
      t.uuid :contract_id, null: false
      t.uuid :tenant_id, null: false
      t.date :issue_on, null: false
      t.date :due_on, null: false
      t.integer :amount_cents, null: false
      t.integer :balance_cents, null: false
      t.string :currency, null: false, default: "USD"
      t.string :status, null: false, default: "pending"
      t.timestamps
    end

    add_foreign_key :invoices, :contracts
    add_foreign_key :invoices, :tenants
    add_index :invoices, [:tenant_id, :status]
    add_index :invoices, [:contract_id, :due_on]
  end
end
