require 'rails_helper'

RSpec.describe Dunning::Scheduler do
  it 'assigns stages based on days overdue' do
    contract = create(:contract, start_on: Date.today - 60, end_on: Date.today + 300, due_day: 5, monthly_rent: 1000)
    as_of = Date.new(2025, 8, 20)
    inv_gentle = create(:invoice, contract: contract, tenant: contract.tenant, due_on: as_of - 8, issue_on: as_of - 30, amount_cents: 100_00, balance_cents: 100_00)
    inv_reminder = create(:invoice, contract: contract, tenant: contract.tenant, due_on: as_of - 20, issue_on: as_of - 30, amount_cents: 100_00, balance_cents: 100_00)
    inv_final = create(:invoice, contract: contract, tenant: contract.tenant, due_on: as_of - 40, issue_on: as_of - 30, amount_cents: 100_00, balance_cents: 100_00)

    scheduler = described_class.new(as_of: as_of)
    pairs = scheduler.candidates.to_h # { invoice => stage }
    expect(pairs[inv_gentle]).to eq(:gentle)
    expect(pairs[inv_reminder]).to eq(:reminder)
    expect(pairs[inv_final]).to eq(:final)
  end
end
