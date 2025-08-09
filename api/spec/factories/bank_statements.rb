FactoryBot.define do
  factory :bank_statement do
    account { 'TEST-ACC' }
    statement_on { Date.today }
    imported_by_user factory: %i[user]
    original_filename { 'stmt.csv' }
  end
end
