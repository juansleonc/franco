module Dunning
  class SendNotificationsJob < ApplicationJob
    queue_as :default

    retry_on StandardError, attempts: 5, wait: :exponentially_longer

    def perform(invoice_id:, channels: %w[email sms])
      invoice = Invoice.find(invoice_id)
      tenant = invoice.tenant

      if channels.include?("email")
        begin
          DunningMailer.overdue_notice(invoice: invoice).deliver_now
          NotificationLog.create!(invoice: invoice, tenant: tenant, channel: 'email', status: 'sent', sent_at: Time.current)
        rescue => e
          NotificationLog.create!(invoice: invoice, tenant: tenant, channel: 'email', status: 'failed', error: e.message, sent_at: Time.current)
          raise
        end
      end
      if channels.include?("sms") && tenant.phone.present?
        begin
          Sms.client.deliver(to: tenant.phone, body: Dunning::SmsTemplates.overdue(invoice: invoice))
          NotificationLog.create!(invoice: invoice, tenant: tenant, channel: 'sms', status: 'sent', sent_at: Time.current)
        rescue => e
          NotificationLog.create!(invoice: invoice, tenant: tenant, channel: 'sms', status: 'failed', error: e.message, sent_at: Time.current)
          raise
        end
      end
    end
  end
end
