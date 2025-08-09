require 'rails_helper'

RSpec.describe Dedup::PropertyMatcher do
  it 'returns groups when underlying query finds >1 per address/unit' do
    # We cannot insert duplicates due to unique index; stub the DB grouping
    group_relation = instance_double(ActiveRecord::Relation)
    having_relation = instance_double(ActiveRecord::Relation)
    order_relation = instance_double(ActiveRecord::Relation)

    allow(Property).to receive(:group).with(:address, :unit).and_return(group_relation)
    allow(group_relation).to receive(:having).with("count(*) > 1").and_return(having_relation)
    allow(having_relation).to receive(:count).and_return({ [ '123 Main', '1A' ] => 2 })

    allow(Property).to receive(:where).with(address: '123 Main', unit: '1A').and_return(order_relation)
    allow(order_relation).to receive(:order).with(:created_at).and_return(order_relation)
    allow(order_relation).to receive(:pluck).with(:id).and_return(%w[id1 id2])
    results = described_class.new.call
    group = results.find { |r| r[:criterion] == 'address_unit' }
    expect(group).to be_present
    expect(group[:ids]).to eq(%w[id1 id2])
  end
end
