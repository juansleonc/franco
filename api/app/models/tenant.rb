class Tenant < ApplicationRecord
  has_many :contracts, dependent: :restrict_with_error

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true
end
