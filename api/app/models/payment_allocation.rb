class PaymentAllocation < ApplicationRecord
  belongs_to :payment
  belongs_to :invoice

  validates :amount_cents, numericality: { greater_than: 0 }
  validate :not_exceed_payment

  after_commit :update_invoice_balance_and_status, on: :create

  private

  def not_exceed_payment
    return if payment.blank?
    previous = persisted? ? self.class.find(id).amount_cents : 0
    new_total = payment.allocated_cents - previous + amount_cents.to_i
    if new_total > payment.amount_cents
      errors.add(:amount_cents, "exceeds payment amount")
    end
  end

  def update_invoice_balance_and_status
    inv = invoice
    inv.update!(balance_cents: [ inv.balance_cents - amount_cents, 0 ].max)
    inv.recalc_status!
  end
end
