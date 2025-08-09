class CreateDunningEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :dunning_events, id: :uuid do |t|
      t.uuid :invoice_id, null: false
      t.string :stage, null: false
      t.datetime :sent_at, null: false
      t.timestamps
    end

    add_foreign_key :dunning_events, :invoices
    add_index :dunning_events, [ :invoice_id, :stage ], unique: true
  end
end
