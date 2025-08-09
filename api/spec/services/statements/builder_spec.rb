require 'rails_helper'

RSpec.describe Statements::Builder do
  it 'builds owner statement with rent and fees' do
    property = create(:property)
    contract = create(:contract, property: property, start_on: '2025-01-01', end_on: '2025-12-31', due_day: 5, monthly_rent: 1000, fee_rate_pct: 10.0)
    inv = create(:invoice, contract: contract, tenant: contract.tenant, issue_on: Date.new(2025, 8, 1), due_on: Date.new(2025, 8, 5), amount_cents: 100_00, balance_cents: 0)
    pay = create(:payment, amount_cents: 100_00)
    create(:payment_allocation, payment: pay, invoice: inv, amount_cents: 100_00)
    create(:admin_fee, contract: contract, period: '2025-08', base_cents: 100_00, fee_rate_pct: 10.0, fee_cents: 10_00)

    builder = described_class.new(period: '2025-08')
    expect { builder.call }.to change(OwnerStatement, :count).by(1)
    st = OwnerStatement.last
    expect(st.total_rent_cents).to eq(100_00)
    expect(st.total_fees_cents).to eq(10_00)
    expect(st.net_cents).to eq(90_00)
  end
end
