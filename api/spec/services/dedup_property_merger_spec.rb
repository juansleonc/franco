require 'rails_helper'

RSpec.describe Dedup::PropertyMerger do
  it 'reassigns associations and destroys source properties' do
    target = create(:property, address: 'A', unit: '1')
    source = create(:property, address: 'B', unit: '2')
    contract = create(:contract, property: source)

    result = described_class.new.call(target_id: target.id, source_ids: [source.id])

    expect(result[:ok]).to be true
    expect { source.reload }.to raise_error(ActiveRecord::RecordNotFound)
    expect(contract.reload.property_id).to eq(target.id)
  end
end
