module Banking
  class NullClient
    def list_accounts
      [
        { id: "acc_001", name: "Default Operating", currency: "USD" }
      ]
    end

    def sync(as_of: Date.today)
      { synced: true, as_of: as_of.to_s, transactions: [] }
    end
  end
end
