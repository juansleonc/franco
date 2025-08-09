FactoryBot.define do
  factory :payment do
    tenant
    received_on { Date.today }
    amount_cents { 150_00 }
    currency { 'USD' }
    add_attribute(:payment_method) { 'transfer' }
    reference { 'REF123' }
    status { 'captured' }
  end
end
