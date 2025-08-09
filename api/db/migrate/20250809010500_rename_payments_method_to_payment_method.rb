class RenamePaymentsMethodToPaymentMethod < ActiveRecord::Migration[8.0]
  def change
    # Some environments may already have the correct column name
    if column_exists?(:payments, :method)
      rename_column :payments, :method, :payment_method
    end
  end
end
