class CreateTenants < ActiveRecord::Migration[8.0]
  def change
    create_table :tenants, id: :uuid do |t|
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :phone
      t.timestamps
    end

    add_index :tenants, :email, unique: true
  end
end
