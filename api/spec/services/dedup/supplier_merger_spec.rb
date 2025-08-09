require 'rails_helper'

RSpec.describe Dedup::SupplierMerger do
  it 'destroys source suppliers and keeps target' do
    target = create(:supplier, tax_id: 'TA-1', email: 'a@sup.com', name: 'A')
    source = create(:supplier, tax_id: 'TA-2', email: 'b@sup.com', name: 'B')

    result = described_class.new.call(target_id: target.id, source_ids: [ source.id ])

    expect(result[:ok]).to be true
    expect { source.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
