class Invoice < ApplicationRecord
  belongs_to :contract
  belongs_to :tenant
  has_many :payment_allocations, dependent: :destroy

  enum :status, { pending: "pending", partial: "partial", paid: "paid" }, prefix: true

  scope :pending, -> { where(status: "pending") }

  validates :issue_on, :due_on, :amount_cents, :balance_cents, :currency, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }
  validates :balance_cents, numericality: { greater_than_or_equal_to: 0 }

  before_validation :compute_status_from_balance

  def recalc_status!
    computed = if balance_cents.to_i <= 0
                 "paid"
    elsif balance_cents.to_i < amount_cents.to_i
                 "partial"
    else
                 "pending"
    end
    update!(status: computed)
  end

  private

  def compute_status_from_balance
    self.status = if balance_cents.to_i <= 0
                    "paid"
    elsif balance_cents.to_i < amount_cents.to_i
                    "partial"
    else
                    "pending"
    end
  end
end
