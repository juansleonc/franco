require 'rails_helper'

RSpec.describe PaymentSerializer do
  it 'serializes payment and allocations' do
    payment = create(:payment)
    inv = create(:invoice, amount_cents: 50_00, balance_cents: 50_00)
    create(:payment_allocation, payment: payment, invoice: inv, amount_cents: 50_00)
    json = described_class.new(payment).as_json
    expect(json[:id]).to eq(payment.id)
    expect(json[:amount_cents]).to eq(payment.amount_cents)
    expect(json[:payment_method]).to eq('transfer')
  end
end
