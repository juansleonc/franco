FactoryBot.define do
  factory :admin_fee do
    contract
    period { '2025-08' }
    base_cents { 100_00 }
    fee_rate_pct { 10.0 }
    fee_cents { 10_00 }
    status { 'calculated' }
  end
end
