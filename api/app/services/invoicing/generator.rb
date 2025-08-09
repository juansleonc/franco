module Invoicing
  class Generator
    # Generates monthly invoices for active contracts for the given date's month
    # Idempotent: if an invoice already exists for contract and month, it is skipped
    def initialize(as_of: Date.current)
      @as_of = as_of
      @month_start = @as_of.beginning_of_month
      @month_end = @as_of.end_of_month
    end

    def call
      generated = 0
      Contract.active.find_each do |contract|
        next if invoice_exists_for_month?(contract_id: contract.id)

        amount_cents = (contract.monthly_rent.to_d * 100).to_i
        Invoice.create!(
          contract_id: contract.id,
          tenant_id: contract.tenant_id,
          issue_on: @month_start,
          due_on: due_date_for(contract: contract),
          amount_cents: amount_cents,
          balance_cents: amount_cents,
          currency: "USD",
          status: "pending"
        )
        generated += 1
      end
      generated
    end

    private

    def invoice_exists_for_month?(contract_id:)
      Invoice.where(contract_id: contract_id, issue_on: @month_start..@month_end).exists?
    end

    def due_date_for(contract:)
      day = [ [ contract.due_day.to_i, 28 ].min, 1 ].max
      Date.new(@as_of.year, @as_of.month, day)
    end
  end
end
