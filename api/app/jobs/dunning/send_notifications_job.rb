module Dunning
  class SendNotificationsJob < ApplicationJob
    queue_as :default

    def perform(invoice_id:, channels: %w[email sms])
      invoice = Invoice.find(invoice_id)
      if channels.include?("email")
        DunningMailer.overdue_notice(invoice: invoice).deliver_now
      end
      if channels.include?("sms") && invoice.tenant.phone.present?
        Sms.client.deliver(to: invoice.tenant.phone, body: Dunning::SmsTemplates.overdue(invoice: invoice))
      end
    end
  end
end
