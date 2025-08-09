class Property < ApplicationRecord
  has_many :contracts, dependent: :restrict_with_error

  validates :name, presence: true
  validates :address, presence: true
end
