require 'rails_helper'

RSpec.describe Invoicing::Generator do
  it 'does not generate for inactive contracts' do
    contract = create(:contract, active: false, start_on: Date.today - 10, end_on: Date.today + 60, due_day: 10, monthly_rent: 1000)
    gen = described_class.new(as_of: Date.today)
    expect { gen.call }.not_to change(Invoice, :count)
  end
end
