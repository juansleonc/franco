require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject(:payment) { build(:payment) }

  it 'is valid with required fields' do
    expect(payment).to be_valid
  end

  it 'sums allocated cents' do
    payment.save!
    inv1 = create(:invoice, amount_cents: 100_00, balance_cents: 100_00)
    inv2 = create(:invoice, amount_cents: 100_00, balance_cents: 100_00)
    create(:payment_allocation, payment: payment, invoice: inv1, amount_cents: 40_00)
    create(:payment_allocation, payment: payment, invoice: inv2, amount_cents: 10_00)
    expect(payment.allocated_cents).to eq(50_00)
  end
end
