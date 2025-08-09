require 'rails_helper'

RSpec.describe Dedup::PropertyMatcher do
  it 'returns groups when underlying query finds >1 per address/unit' do
    # We cannot insert duplicates due to unique index; stub the DB grouping
    allow(Property).to receive(:group).and_return(
      double(having: double(count: { [ '123 Main', '1A' ] => 2 }))
    )
    allow(Property).to receive(:where).with(address: '123 Main', unit: '1A').and_return(
      double(order: double(pluck: %w[id1 id2]))
    )
    results = described_class.new.call
    group = results.find { |r| r[:criterion] == 'address_unit' }
    expect(group).to be_present
    expect(group[:ids]).to eq(%w[id1 id2])
  end
end
