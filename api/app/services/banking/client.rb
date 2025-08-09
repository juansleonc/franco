module Banking
  class << self
    def client
      @client ||= build_client
    end

    def reset_client!
      @client = nil
    end

    private

    def build_client
      provider = ENV["BANKING_PROVIDER"].to_s.downcase
      case provider
      when "plaid"
        if ENV["PLAID_CLIENT_ID"].present? && ENV["PLAID_SECRET"].present?
          return Banking::PlaidClient.new(
            client_id: ENV["PLAID_CLIENT_ID"],
            secret: ENV["PLAID_SECRET"],
            environment: ENV["PLAID_ENV"] || "sandbox"
          )
        end
      end
      Banking::NullClient.new
    end
  end
end
