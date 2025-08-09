module V1
  class NotificationsController < ApplicationController
    def send_test
      authorize :notifications, :create?
      to = params.require(:to)
      subject = params[:subject] || 'Franco Test Notification'
      body = params[:body] || 'This is a test email from Franco.'
      mail = DunningMailer.test_email(to: to, subject: subject, body: body)
      mail.deliver_now
      render json: { data: { delivered: true } }
    end

    def send_test_sms
      authorize :notifications, :create?
      to = params.require(:to)
      body = params[:body] || 'This is a test SMS from Franco.'
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
  end
end
