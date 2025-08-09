require 'rails_helper'

RSpec.describe Dedup::PropertyMatcher do
  it 'finds duplicates by address and unit' do
    create(:property, address: '123 Main', unit: '1A', name: 'P1')
    create(:property, address: '123 Main', unit: '1A', name: 'P2')
    results = described_class.new.call
    group = results.find { |r| r[:criterion] == 'address_unit' }
    expect(group).to be_present
    expect(group[:ids].size).to eq(2)
  end
end
