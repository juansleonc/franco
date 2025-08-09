require 'rails_helper'

RSpec.describe BankStatementSerializer do
  it 'serializes bank statement fields' do
    bs = create(:bank_statement)
    json = described_class.new(bs).as_json
    expect(json[:id]).to eq(bs.id)
    expect(json[:account]).to eq('TEST-ACC')
  end
end
