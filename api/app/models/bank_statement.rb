class BankStatement < ApplicationRecord
  belongs_to :imported_by_user, class_name: "User"
  has_many :statement_lines, dependent: :destroy

  validates :account, :statement_on, presence: true
end
