class AddFeeRateToContracts < ActiveRecord::Migration[8.0]
  def change
    add_column :contracts, :fee_rate_pct, :decimal, precision: 5, scale: 2, null: false, default: 10.0
    add_index :contracts, :fee_rate_pct
  end
end
