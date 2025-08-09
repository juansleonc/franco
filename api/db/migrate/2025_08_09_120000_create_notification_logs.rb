class CreateNotificationLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :notification_logs, id: :uuid do |t|
      t.uuid :invoice_id, null: false
      t.uuid :tenant_id, null: false
      t.string :channel, null: false
      t.string :status, null: false, default: 'sent'
      t.text :error
      t.datetime :sent_at, null: false
      t.timestamps
    end
    add_index :notification_logs, [:tenant_id, :channel, :sent_at]
    add_index :notification_logs, [:invoice_id, :channel, :sent_at]
  end
end
