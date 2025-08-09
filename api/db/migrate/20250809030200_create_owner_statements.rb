class CreateOwnerStatements < ActiveRecord::Migration[8.0]
  def change
    create_table :owner_statements, id: :uuid do |t|
      t.uuid :property_id, null: false
      t.string :period, null: false # YYYY-MM
      t.integer :total_rent_cents, null: false, default: 0
      t.integer :total_expenses_cents, null: false, default: 0
      t.integer :total_fees_cents, null: false, default: 0
      t.integer :net_cents, null: false, default: 0
      t.timestamps
    end

    add_foreign_key :owner_statements, :properties
    add_index :owner_statements, [ :property_id, :period ], unique: true
  end
end
