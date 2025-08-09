require 'rails_helper'

RSpec.describe Fees::Calculator do
  it 'creates admin fees per active contract with collected base' do
    contract = create(:contract, start_on: '2025-01-01', end_on: '2025-12-31', due_day: 5, monthly_rent: 1000, fee_rate_pct: 10.0)
    # simulate rent collection via allocations
    inv = create(:invoice, contract: contract, tenant: contract.tenant, issue_on: Date.new(2025, 8, 1), due_on: Date.new(2025, 8, 5), amount_cents: 100_00, balance_cents: 50_00)
    pay = create(:payment, amount_cents: 100_00)
    create(:payment_allocation, payment: pay, invoice: inv, amount_cents: 50_00)

    calc = described_class.new(period: '2025-08')
    expect { calc.call }.to change(AdminFee, :count).by(1)
    fee = AdminFee.last
    expect(fee.base_cents).to eq(50_00)
    expect(fee.fee_cents).to eq(5_00)
  end
end
