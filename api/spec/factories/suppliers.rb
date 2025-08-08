FactoryBot.define do
  factory :supplier do
    name { "MyString" }
    tax_id { "MyString" }
    email { "MyString" }
    phone { "MyString" }
    bank_account_ciphertext { "MyText" }
    created_by_user { nil }
  end
end
