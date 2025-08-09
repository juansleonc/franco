module Banking
  class PlaidClient
    def initialize(client_id:, secret:, environment: 'sandbox')
      @client_id = client_id
      @secret = secret
      @environment = environment
    end

    def list_accounts
      # Stubbed response; integrate plaid gem in future
      [ { id: 'plaid_acc_123', name: 'Plaid Checking', currency: 'USD' } ]
    end

    def sync(as_of: Date.today)
      { synced: true, as_of: as_of.to_s, provider: 'plaid', transactions: [] }
    end
  end
end
