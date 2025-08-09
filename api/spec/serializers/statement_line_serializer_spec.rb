require 'rails_helper'

RSpec.describe StatementLineSerializer do
  it 'serializes statement line fields' do
    line = create(:statement_line)
    json = described_class.new(line).as_json
    expect(json[:id]).to eq(line.id)
    expect(json[:amount_cents]).to eq(line.amount_cents)
  end
end
