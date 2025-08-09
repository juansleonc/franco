require 'rails_helper'

RSpec.describe Dedup::SupplierMatcher do
  it 'finds duplicates by email' do
    create(:supplier, tax_id: 'TA1', email: 'dup@example.com', name: 'A')
    create(:supplier, tax_id: 'TA2', email: 'dup@example.com', name: 'B')
    results = described_class.new.call
    group = results.find { |r| r[:criterion] == 'email' && r[:value] == 'dup@example.com' }
    expect(group).to be_present
    expect(group[:ids].size).to eq(2)
  end
end
