module Sms
  class TwilioClient
    def initialize(account_sid:, auth_token:, from_number:)
      @account_sid = account_sid
      @auth_token = auth_token
      @from_number = from_number
    end

    def deliver(to:, body:)
      # Minimal stub: don't require twilio-ruby gem here, just log
      Rails.logger.info("SMS[Twilio] from=#{@from_number} to=#{to} body=#{body}")
      true
    end
  end
end
