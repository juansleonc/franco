class PaymentAllocation < ApplicationRecord
  belongs_to :payment
  belongs_to :invoice

  validates :amount_cents, numericality: { greater_than: 0 }
  validate :not_exceed_payment

  after_commit :update_invoice_balance_and_status

  private

  def not_exceed_payment
    return if payment.blank?
    if amount_cents.to_i + payment.allocated_cents - (persisted? ? self.class.find(id).amount_cents : 0) > payment.amount_cents
      errors.add(:amount_cents, "exceeds payment amount")
    end
  end

  def update_invoice_balance_and_status
    inv = invoice
    inv.update!(balance_cents: [ inv.balance_cents - amount_cents, 0 ].max)
    inv.recalc_status!
  end
end
