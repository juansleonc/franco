class DunningEvent < ApplicationRecord
  belongs_to :invoice
  validates :stage, presence: true
  validates :sent_at, presence: true
end
