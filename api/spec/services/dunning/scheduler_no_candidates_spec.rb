require 'rails_helper'

RSpec.describe Dunning::Scheduler do
  it 'returns empty when no overdue invoices' do
    create(:invoice, due_on: Date.today + 5, issue_on: Date.today - 2, amount_cents: 100_00, balance_cents: 100_00)
    scheduler = described_class.new(as_of: Date.today)
    expect(scheduler.candidates).to be_empty
  end
end
