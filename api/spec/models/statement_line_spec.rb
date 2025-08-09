require 'rails_helper'

RSpec.describe StatementLine, type: :model do
  it 'defaults to unmatched and allows optional matched_payment' do
    line = build(:statement_line)
    expect(line).to be_match_status_unmatched
    expect(line.matched_payment).to be_nil
    expect(line).to be_valid
  end
end
