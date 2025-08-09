FactoryBot.define do
  factory :statement_line do
    bank_statement
    posted_on { Date.today }
    description { 'Payment received' }
    amount_cents { 150_00 }
    match_status { 'unmatched' }
  end
end
