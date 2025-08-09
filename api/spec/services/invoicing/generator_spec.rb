require 'rails_helper'

RSpec.describe Invoicing::Generator do
  it 'creates one invoice per active contract and skips duplicates for month' do
    contract = create(:contract, start_on: Date.today - 10, end_on: Date.today + 60, due_day: 10, monthly_rent: 1234.56)
    as_of = Date.new(2025, 8, 15)
    gen = described_class.new(as_of: as_of)

    expect { gen.call }.to change(Invoice, :count).by(1)
    # calling again in same month should not create duplicates
    expect { gen.call }.not_to change(Invoice, :count)

    inv = Invoice.last
    expect(inv.issue_on).to eq(as_of.beginning_of_month)
    expect(inv.due_on).to eq(Date.new(2025, 8, 10))
    expect(inv.amount_cents).to eq(123456)
    expect(inv.balance_cents).to eq(123456)
  end
end
