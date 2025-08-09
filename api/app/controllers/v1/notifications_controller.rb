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
      Sms::NullClient.new.deliver(to: to, body: body)
      render json: { data: { sent: true } }
    end
  end
end
