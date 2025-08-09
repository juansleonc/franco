module Dunning
  class SendNotificationsJob < ApplicationJob
    queue_as :default

    retry_on StandardError, attempts: 5, wait: :exponentially_longer

    def perform(invoice_id:, channels: %w[email sms])
      invoice = Invoice.find(invoice_id)
      tenant = invoice.tenant

      delivered_any_channel = false

      if channels.include?("email")
        begin
          DunningMailer.overdue_notice(invoice: invoice).deliver_now
          NotificationLog.create!(invoice: invoice, tenant: tenant, channel: "email", status: "sent", sent_at: Time.current)
          delivered_any_channel = true
        rescue => e
          NotificationLog.create!(invoice: invoice, tenant: tenant, channel: "email", status: "failed", error: e.message, sent_at: Time.current)
          raise
        end
      end
      if channels.include?("sms") && tenant.phone.present?
        begin
          Sms.client.deliver(to: tenant.phone, body: Dunning::SmsTemplates.overdue(invoice: invoice))
          NotificationLog.create!(invoice: invoice, tenant: tenant, channel: "sms", status: "sent", sent_at: Time.current)
          delivered_any_channel = true
        rescue => e
          NotificationLog.create!(invoice: invoice, tenant: tenant, channel: "sms", status: "failed", error: e.message, sent_at: Time.current)
          raise
        end
      end

      # Mark dunning stage as emitted only after at least one successful delivery
      if delivered_any_channel
        begin
          stage = Dunning::Scheduler.new(as_of: Date.current).send(:stage_for, invoice)
          if stage.present?
            DunningEvent.find_or_create_by!(invoice_id: invoice.id, stage: stage.to_s) do |ev|
              ev.sent_at = Time.current
            end
          end
        rescue => _e
          # Non-blocking
        end
      end
    end
  end
end
