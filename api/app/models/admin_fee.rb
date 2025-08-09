class AdminFee < ApplicationRecord
  belongs_to :contract
  enum :status, { calculated: "calculated", invoiced: "invoiced" }, prefix: true

  validates :period, :base_cents, :fee_rate_pct, :fee_cents, presence: true
end
