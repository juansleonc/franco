class CreateContracts < ActiveRecord::Migration[8.0]
  def change
    create_table :contracts, id: :uuid do |t|
      t.uuid :property_id, null: false
      t.uuid :tenant_id, null: false
      t.date :start_on, null: false
      t.date :end_on, null: false
      t.integer :due_day, null: false
      t.decimal :monthly_rent, precision: 12, scale: 2, null: false
      t.boolean :active, null: false, default: true
      t.timestamps
    end

    add_foreign_key :contracts, :properties
    add_foreign_key :contracts, :tenants
    add_index :contracts, %i[property_id start_on end_on]
  end
end
