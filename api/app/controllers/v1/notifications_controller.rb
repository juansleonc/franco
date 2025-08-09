module V1
  class NotificationsController < ApplicationController
    def send_test
      authorize :notifications, :create?
      to = params.require(:to)
      subject = params[:subject] || "Franco Test Notification"
      body = params[:body] || "This is a test email from Franco."
      mail = DunningMailer.test_email(to: to, subject: subject, body: body)
      mail.deliver_now
      render json: { data: { delivered: true } }
    end

    def send_test_sms
      authorize :notifications, :create?
      to = params.require(:to)
      body = params[:body] || "This is a test SMS from Franco."
      Sms.client.deliver(to: to, body: body)
      render json: { data: { sent: true } }
    end

    def dunning_email
      authorize :notifications, :create?
      invoice = Invoice.find(params.require(:invoice_id))
      mail = DunningMailer.overdue_notice(invoice: invoice)
      mail.deliver_now
      render json: { data: { delivered: true, invoice_id: invoice.id } }
    end

    def dunning_sms
      authorize :notifications, :create?
      invoice = Invoice.find(params.require(:invoice_id))
      Sms.client.deliver(to: invoice.tenant.phone, body: Dunning::SmsTemplates.overdue(invoice: invoice))
      render json: { data: { sent: true, invoice_id: invoice.id } }
    end

    def logs
      authorize :notifications, :index?
      scope = NotificationLog.all
      if params[:invoice_id].present?
        scope = scope.where(invoice_id: params[:invoice_id])
      end
      if params[:tenant_id].present?
        scope = scope.where(tenant_id: params[:tenant_id])
      end
      if params[:channel].present?
        scope = scope.where(channel: params[:channel])
      end
      if params[:since].present?
        scope = scope.where("sent_at >= ?", Time.parse(params[:since]))
      end
    scope = scope.order(sent_at: :desc)
    requested_limit = (params[:limit] || 100).to_i
    requested_limit = 1 if requested_limit < 1
    max_limit = 500
    scope = scope.limit([ requested_limit, max_limit ].min)
      render json: { data: scope.map { |l| serialize_log(l) } }
    end

    def logs_csv
      authorize :notifications, :index?
      scope = NotificationLog.all
      scope = scope.where(invoice_id: params[:invoice_id]) if params[:invoice_id].present?
      scope = scope.where(tenant_id: params[:tenant_id]) if params[:tenant_id].present?
      scope = scope.where(channel: params[:channel]) if params[:channel].present?
      scope = scope.where("sent_at >= ?", Time.parse(params[:since])) if params[:since].present?
    scope = scope.order(sent_at: :desc)
    require 'csv'
      csv = CSV.generate do |csvio|
        csvio << %w[id invoice_id tenant_id channel status error sent_at]
      scope.find_each do |l|
          csvio << [ l.id, l.invoice_id, l.tenant_id, l.channel, l.status, l.error, l.sent_at ]
        end
      end
      send_data csv, filename: "notification_logs.csv", type: "text/csv"
    end

    def retry_failed
      authorize :notifications, :create?
      scope = NotificationLog.where(status: "failed")
      scope = scope.where(invoice_id: params[:invoice_id]) if params[:invoice_id].present?
      scope = scope.where(tenant_id: params[:tenant_id]) if params[:tenant_id].present?
      scope = scope.where(channel: params[:channel]) if params[:channel].present?
      count = 0
      scope.find_each do |log|
        # Avoid enqueuing duplicate jobs for the same invoice/channel too frequently
        recent = NotificationLog.where(tenant_id: log.tenant_id, channel: log.channel).where("sent_at > ?", 5.minutes.ago)
        next if recent.exists?
        channels = [ log.channel ]
        Dunning::SendNotificationsJob.perform_later(invoice_id: log.invoice_id, channels: channels)
        count += 1
      end
      render json: { data: { enqueued: count } }
    end

    private

    def serialize_log(l)
      {
        id: l.id,
        invoice_id: l.invoice_id,
        tenant_id: l.tenant_id,
        channel: l.channel,
        status: l.status,
        error: l.error,
        sent_at: l.sent_at
      }
    end
  end
end
