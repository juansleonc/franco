class CreateBankStatements < ActiveRecord::Migration[8.0]
  def change
    create_table :bank_statements, id: :uuid do |t|
      t.string :account, null: false
      t.date :statement_on, null: false
      t.references :imported_by_user, null: false, foreign_key: { to_table: :users }, type: :bigint
      t.string :original_filename
      t.timestamps
    end
  end
end
