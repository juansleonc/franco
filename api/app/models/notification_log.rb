class NotificationLog < ApplicationRecord
  belongs_to :invoice
  belongs_to :tenant

  enum :status, { sent: "sent", failed: "failed" }, prefix: true

  CHANNELS = %w[email sms].freeze

  validates :channel, :sent_at, presence: true
  validates :channel, inclusion: { in: CHANNELS }
end
