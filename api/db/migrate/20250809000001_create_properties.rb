class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties, id: :uuid do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :unit
      t.boolean :active, null: false, default: true
      t.timestamps
    end

    add_index :properties, %i[address unit], unique: true
  end
end
