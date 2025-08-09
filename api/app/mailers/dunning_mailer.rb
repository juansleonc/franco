class DunningMailer < ApplicationMailer
  def test_email(to:, subject: 'Franco Test Notification', body: 'Test')
    @body = body
    mail(to: to, subject: subject) do |format|
      format.text { render plain: @body }
      format.html { render html: ERB::Util.html_escape(@body).gsub("\n", '<br>').html_safe }
    end
  end

  def overdue_notice(invoice:)
    @invoice = invoice
    @tenant = invoice.tenant
    subject = "Payment reminder — Invoice ##{invoice.id} due #{invoice.due_on}"
    mail(to: @tenant.email, subject: subject)
  end
end
