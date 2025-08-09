require 'rails_helper'

RSpec.describe PaymentAllocation, type: :model do
  it 'prevents exceeding payment amount and updates invoice' do
    payment = create(:payment, amount_cents: 100_00)
    invoice = create(:invoice, amount_cents: 100_00, balance_cents: 100_00)
    alloc1 = create(:payment_allocation, payment: payment, invoice: invoice, amount_cents: 60_00)
    expect(alloc1).to be_persisted

    alloc2 = build(:payment_allocation, payment: payment, invoice: invoice, amount_cents: 50_00)
    expect(alloc2).not_to be_valid
    expect(alloc2.errors[:amount_cents]).to include('exceeds payment amount')

    expect(invoice.reload.balance_cents).to eq(40_00)
    expect(invoice).to be_status_partial
  end
end
