class StatementLine < ApplicationRecord
  belongs_to :bank_statement
  belongs_to :matched_payment, class_name: 'Payment', optional: true

  enum :match_status, { unmatched: 'unmatched', matched: 'matched', ignored: 'ignored' }, prefix: true

  validates :posted_on, :amount_cents, presence: true
end
