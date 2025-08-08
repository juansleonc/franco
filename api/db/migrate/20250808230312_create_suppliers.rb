class CreateSuppliers < ActiveRecord::Migration[8.0]
  def change
    create_table :suppliers, id: :uuid do |t|
      t.string :name, null: false
      t.string :tax_id, null: false
      t.string :email, null: false
      t.string :phone
      t.text :bank_account_ciphertext
      t.references :created_by_user, null: false, foreign_key: { to_table: :users }, type: :bigint

      t.timestamps
    end
    add_index :suppliers, :tax_id, unique: true
    add_index :suppliers, :email
  end
end
