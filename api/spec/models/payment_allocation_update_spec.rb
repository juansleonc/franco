require 'rails_helper'

RSpec.describe PaymentAllocation, type: :model do
  it 'validates update does not exceed payment total without saving' do
    payment = create(:payment, amount_cents: 100_00)
    invoice = create(:invoice, amount_cents: 100_00, balance_cents: 100_00)
    alloc = create(:payment_allocation, payment: payment, invoice: invoice, amount_cents: 60_00)

    # Change amount to a smaller value -> still valid
    alloc.amount_cents = 50_00
    expect(alloc).to be_valid

    # Change amount to exceed payment total -> invalid (validation hits persisted? branch)
    alloc.amount_cents = 110_00
    expect(alloc).not_to be_valid
    expect(alloc.errors[:amount_cents]).to include('exceeds payment amount')
  end
end
