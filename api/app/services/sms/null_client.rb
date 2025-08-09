module Sms
  class NullClient
    def deliver(to:, body:)
      Rails.logger.info("SMS[NULL] to=#{to} body=#{body}")
      true
    end
  end
end
