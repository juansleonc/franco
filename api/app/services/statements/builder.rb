module Statements
  class Builder
    # Builds or updates owner statements per property for period (YYYY-MM)
    def initialize(period:)
      @period = period
      @month_start = Date.strptime("#{period}-01", "%Y-%m-%d").beginning_of_month
      @month_end = @month_start.end_of_month
    end

    def call
      Property.find_each do |property|
        total_rent = rent_collected_cents(property)
        total_expenses = expenses_cents(property)
        total_fees = fees_cents(property)
        net = total_rent - total_expenses - total_fees
        OwnerStatement.find_or_create_by!(property_id: property.id, period: @period) do |st|
          st.total_rent_cents = total_rent
          st.total_expenses_cents = total_expenses
          st.total_fees_cents = total_fees
          st.net_cents = net
        end
      end
    end

    private

    def rent_collected_cents(property)
      PaymentAllocation.joins(invoice: :contract)
                       .where(contracts: { property_id: property.id }, invoices: { issue_on: @month_start..@month_end })
                       .sum(:amount_cents)
    end

    def expenses_cents(property)
      # Placeholder: sum of suppliers expenses for property in period when modeled
      0
    end

    def fees_cents(property)
      AdminFee.joins(contract: :property)
              .where(contracts: { property_id: property.id }, period: @period)
              .sum(:fee_cents)
    end
  end
end
