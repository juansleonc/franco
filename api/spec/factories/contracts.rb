FactoryBot.define do
  factory :contract do
    property
    tenant
    start_on { Date.parse('2025-01-01') }
    end_on { Date.parse('2025-12-31') }
    due_day { 5 }
    monthly_rent { 1000 }
    active { true }
  end
end
