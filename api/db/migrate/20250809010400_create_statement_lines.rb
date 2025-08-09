class CreateStatementLines < ActiveRecord::Migration[8.0]
  def change
    create_table :statement_lines, id: :uuid do |t|
      t.uuid :bank_statement_id, null: false
      t.date :posted_on, null: false
      t.string :description
      t.integer :amount_cents, null: false
      t.uuid :matched_payment_id
      t.string :match_status, null: false, default: 'unmatched'
      t.timestamps
    end

    add_foreign_key :statement_lines, :bank_statements
    add_foreign_key :statement_lines, :payments, column: :matched_payment_id
    add_index :statement_lines, :bank_statement_id
    add_index :statement_lines, :matched_payment_id
    add_index :statement_lines, :match_status
  end
end
