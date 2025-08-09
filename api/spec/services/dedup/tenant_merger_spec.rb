require 'rails_helper'

RSpec.describe Dedup::TenantMerger do
  it 'reassigns associations and destroys source tenants' do
    target = create(:tenant, email: 'merge-target@example.com')
    source = create(:tenant, email: 'merge-source@example.com')
    property = create(:property)
    contract = create(:contract, tenant: source, property: property)
    invoice = create(:invoice, tenant: source, contract: contract)
    payment = create(:payment, tenant: source)

    result = described_class.new.call(target_id: target.id, source_ids: [ source.id ])

    expect(result[:ok]).to be true
    expect { source.reload }.to raise_error(ActiveRecord::RecordNotFound)
    expect(contract.reload.tenant_id).to eq(target.id)
    expect(invoice.reload.tenant_id).to eq(target.id)
    expect(payment.reload.tenant_id).to eq(target.id)
  end
end
