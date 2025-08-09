class CreateBankStatements < ActiveRecord::Migration[8.0]
  def change
    create_table :bank_statements, id: :uuid do |t|
      t.string :account, null: false
      t.date :statement_on, null: false
      t.uuid :imported_by_user_id, null: false
      t.string :original_filename
      t.timestamps
    end

    add_foreign_key :bank_statements, :users, column: :imported_by_user_id
  end
end
