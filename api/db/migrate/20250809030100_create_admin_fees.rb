class CreateAdminFees < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_fees, id: :uuid do |t|
      t.uuid :contract_id, null: false
      t.string :period, null: false # YYYY-MM
      t.integer :base_cents, null: false
      t.decimal :fee_rate_pct, precision: 5, scale: 2, null: false
      t.integer :fee_cents, null: false
      t.string :status, null: false, default: 'calculated'
      t.timestamps
    end

    add_foreign_key :admin_fees, :contracts
    add_index :admin_fees, [ :contract_id, :period ], unique: true
  end
end
