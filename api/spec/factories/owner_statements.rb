FactoryBot.define do
  factory :owner_statement do
    property
    period { '2025-08' }
    total_rent_cents { 0 }
    total_expenses_cents { 0 }
    total_fees_cents { 0 }
    net_cents { 0 }
  end
end
