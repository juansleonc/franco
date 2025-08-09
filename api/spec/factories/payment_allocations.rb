FactoryBot.define do
  factory :payment_allocation do
    payment
    invoice
    amount_cents { 50_00 }
  end
end
