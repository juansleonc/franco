FactoryBot.define do
  factory :invoice do
    contract
    tenant { contract.tenant }
    issue_on { Date.today }
    due_on { Date.today + 30 }
    amount_cents { 100_00 }
    balance_cents { 100_00 }
    currency { 'USD' }
    status { 'pending' }
  end
end
