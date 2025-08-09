class Payment < ApplicationRecord
  belongs_to :tenant
  has_many :payment_allocations, dependent: :destroy

  enum :status, { captured: "captured", allocated: "allocated", reconciled: "reconciled" }, prefix: true

  validates :received_on, :amount_cents, :currency, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }

  # Compatibility writer for legacy attribute name in factories/tests
  def payment_method=(val)
    self[:payment_method] = val
  end

  def allocated_cents
    payment_allocations.sum(:amount_cents)
  end
end
