class DunningMailer < ApplicationMailer
  def test_email(to:, subject: 'Franco Test Notification', body: 'Test')
    @body = body
    mail(to: to, subject: subject) do |format|
      format.text { render plain: @body }
      format.html { render html: ERB::Util.html_escape(@body).gsub("\n", '<br>').html_safe }
    end
  end
end
