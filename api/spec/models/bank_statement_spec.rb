require 'rails_helper'

RSpec.describe BankStatement, type: :model do
  it 'is valid with account and statement_on and user' do
    expect(build(:bank_statement)).to be_valid
  end
end
