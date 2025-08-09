FactoryBot.define do
  factory :property do
    sequence(:name) { |n| "Property #{n}" }
    address { "Calle #{rand(1..999)}" }
    unit { [nil, "A", "B", "C"].sample }
  end
end
