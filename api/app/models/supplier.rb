class Supplier < ApplicationRecord
  belongs_to :created_by_user, class_name: "User"

  encrypts :bank_account, deterministic: false

  validates :name, presence: true
  validates :tax_id, presence: true, uniqueness: true
  validates :email, presence: true
end
