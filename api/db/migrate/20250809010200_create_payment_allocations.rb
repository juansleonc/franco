class CreatePaymentAllocations < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_allocations, id: :uuid do |t|
      t.uuid :payment_id, null: false
      t.uuid :invoice_id, null: false
      t.integer :amount_cents, null: false
      t.timestamps
    end

    add_foreign_key :payment_allocations, :payments
    add_foreign_key :payment_allocations, :invoices
    add_index :payment_allocations, [ :payment_id, :invoice_id ], unique: true
  end
end
