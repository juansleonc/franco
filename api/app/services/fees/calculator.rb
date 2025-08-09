module Fees
  class Calculator
    # Calculates admin fees for a given period (YYYY-MM)
    def initialize(period:)
      @period = period
      @month_start = Date.strptime("#{period}-01", "%Y-%m-%d").beginning_of_month
      @month_end = @month_start.end_of_month
    end

    def call
      generated = 0
      Contract.active.find_each do |contract|
        base_cents = monthly_collected_cents(contract)
        next if base_cents <= 0
        rate = contract.fee_rate_pct.to_d
        fee_cents = ((base_cents.to_d * rate) / 100).to_i
        AdminFee.find_or_create_by!(contract_id: contract.id, period: @period) do |fee|
          fee.base_cents = base_cents
          fee.fee_rate_pct = rate
          fee.fee_cents = fee_cents
        end
        generated += 1
      end
      generated
    end

    private

    def monthly_collected_cents(contract)
      # sum of allocations applied to invoices of this contract in the period
      Invoice.where(contract_id: contract.id, issue_on: @month_start..@month_end)
             .joins(:payment_allocations)
             .sum(:amount_cents)
    end
  end
end
