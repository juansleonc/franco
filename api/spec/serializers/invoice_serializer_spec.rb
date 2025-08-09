require 'rails_helper'

RSpec.describe InvoiceSerializer do
  it 'serializes invoice fields' do
    contract = create(:contract, start_on: Date.today - 1, end_on: Date.today + 30, due_day: 5, monthly_rent: 1000)
    invoice = create(:invoice, contract: contract, tenant: contract.tenant, amount_cents: 100_00, balance_cents: 100_00)
    json = described_class.new(invoice).as_json
    expect(json[:id]).to eq(invoice.id)
    expect(json[:amount_cents]).to eq(100_00)
    expect(json[:currency]).to eq('USD')
  end
end
