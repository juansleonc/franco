require 'rails_helper'

RSpec.describe PaymentAllocation, type: :model do
  it 'reverts invoice balance on destroy' do
    payment = create(:payment, amount_cents: 100_00)
    invoice = create(:invoice, amount_cents: 100_00, balance_cents: 100_00)
    alloc = create(:payment_allocation, payment: payment, invoice: invoice, amount_cents: 40_00)
    expect(invoice.reload.balance_cents).to eq(60_00)

    alloc.destroy!
    expect(invoice.reload.balance_cents).to eq(100_00)
  end
end
