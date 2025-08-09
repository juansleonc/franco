class NotificationLog < ApplicationRecord
  belongs_to :invoice
  belongs_to :tenant

  enum :status, { sent: 'sent', failed: 'failed' }, prefix: true

  validates :channel, :sent_at, presence: true
end
