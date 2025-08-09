FactoryBot.define do
  factory :supplier do
    name { "Supplier" }
    sequence(:tax_id) { |n| "TAX#{n}" }
    email { "supplier@example.com" }
    phone { "123" }
    created_by_user { association :user }
  end
end
