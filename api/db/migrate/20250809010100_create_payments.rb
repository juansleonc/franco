class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments, id: :uuid do |t|
      t.uuid :tenant_id, null: false
      t.date :received_on, null: false
      t.integer :amount_cents, null: false
      t.string :currency, null: false, default: "USD"
      t.string :payment_method
      t.string :reference
      t.string :status, null: false, default: "captured"
      t.timestamps
    end

    add_foreign_key :payments, :tenants
    add_index :payments, [ :tenant_id, :received_on ]
  end
end
