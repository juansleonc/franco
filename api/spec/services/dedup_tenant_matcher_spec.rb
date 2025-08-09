require 'rails_helper'

RSpec.describe Dedup::TenantMatcher do
  it 'finds exact duplicates by full_name' do
    create(:tenant, email: 'a1@example.com', full_name: 'Same Name')
    create(:tenant, email: 'a2@example.com', full_name: 'Same Name')
    results = described_class.new.call
    group = results.find { |r| r[:criterion] == 'full_name' && r[:value] == 'Same Name' }
    expect(group).to be_present
    expect(group[:ids].size).to eq(2)
  end

  it 'finds fuzzy duplicates by similar names and domain' do
    create(:tenant, email: 'ana.gomez@domain.com', full_name: 'Ana Gomez')
    create(:tenant, email: 'ana.gomes@domain.com', full_name: 'Ana Gomes')
    results = described_class.new.call(fuzzy: true)
    expect(results.any? { |r| r[:criterion] == 'name_fuzzy' }).to be true
  end
end
