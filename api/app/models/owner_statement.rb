class OwnerStatement < ApplicationRecord
  belongs_to :property

  validates :period, presence: true
  validates :total_rent_cents, :total_expenses_cents, :total_fees_cents, :net_cents, numericality: { greater_than_or_equal_to: 0 }
end
