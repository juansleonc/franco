require 'rails_helper'

RSpec.describe Invoice, type: :model do
  subject(:invoice) { build(:invoice, contract: contract, tenant: contract.tenant, amount_cents: 100_00, balance_cents: 100_00) }

  let(:contract) { create(:contract, start_on: Date.today - 10, end_on: Date.today + 365, due_day: 5, monthly_rent: 1000) }


  it 'is valid with required fields' do
    expect(invoice).to be_valid
  end

  it 'recalculates status based on balance' do
    invoice.save!
    invoice.update!(balance_cents: 0)
    expect(invoice).to be_status_paid
    invoice.update!(balance_cents: 50_00)
    expect(invoice).to be_status_partial
    invoice.update!(balance_cents: 100_00)
    expect(invoice).to be_status_pending
  end
end
