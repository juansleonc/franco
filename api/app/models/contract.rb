class Contract < ApplicationRecord
  belongs_to :property
  belongs_to :tenant

  validates :start_on, :end_on, :due_day, :monthly_rent, presence: true
  validates :monthly_rent, numericality: { greater_than: 0 }
  validates :due_day, inclusion: { in: 1..28 }
  validate :end_after_start
  validate :no_overlapping_active_contracts

  scope :active, -> { where(active: true) }

  private

  def end_after_start
    return if start_on.blank? || end_on.blank?
    errors.add(:end_on, 'must be after start_on') if end_on <= start_on
  end

  def no_overlapping_active_contracts
    return if property_id.blank? || start_on.blank? || end_on.blank?
    overlap = Contract.where(property_id: property_id, active: true)
                      .where.not(id: id)
                      .where('(start_on, end_on) OVERLAPS (?, ?)', start_on, end_on)
    errors.add(:base, 'overlapping active contract for property') if overlap.exists?
  end
end
