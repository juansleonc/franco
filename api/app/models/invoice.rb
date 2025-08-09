class Invoice < ApplicationRecord
  belongs_to :contract
  belongs_to :tenant
  has_many :payment_allocations, dependent: :destroy

  enum :status, { pending: 'pending', partial: 'partial', paid: 'paid' }, prefix: true

  validates :issue_on, :due_on, :amount_cents, :balance_cents, :currency, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }
  validates :balance_cents, numericality: { greater_than_or_equal_to: 0 }

  def recalc_status!
    new_status = if balance_cents.zero?
                   'paid'
                 elsif balance_cents < amount_cents
                   'partial'
                 else
                   'pending'
                 end
    update!(status: new_status)
  end
end
