FactoryBot.define do
  factory :tenant do
    full_name { "John Doe" }
    sequence(:email) { |n| "tenant#{n}@example.com" }
  end
end
