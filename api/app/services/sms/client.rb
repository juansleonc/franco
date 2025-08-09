module Sms
  # Define constant to satisfy Zeitwerk
  class Client; end
  class << self
    def client
      @client ||= build_client
    end

    private

    def build_client
      if ENV["TWILIO_ACCOUNT_SID"].present?
        Sms::TwilioClient.new(
          account_sid: ENV["TWILIO_ACCOUNT_SID"],
          auth_token: ENV["TWILIO_AUTH_TOKEN"],
          from_number: ENV["TWILIO_FROM_NUMBER"]
        )
      else
        Sms::NullClient.new
      end
    end
  end
end
