require 'rails_helper'

RSpec.describe Dedup::TenantMatcher do
  it 'finds exact duplicates by email' do
    create(:tenant, email: 'dup@example.com', full_name: 'A')
    create(:tenant, email: 'dup@example.com', full_name: 'B')
    results = described_class.new.call
    group = results.find { |r| r[:criterion] == 'email' && r[:value] == 'dup@example.com' }
    expect(group).to be_present
    expect(group[:ids].size).to eq(2)
  end

  it 'finds fuzzy duplicates by similar names and domain' do
    create(:tenant, email: 'a@domain.com', full_name: 'Ana Gomez')
    create(:tenant, email: 'b@domain.com', full_name: 'Ana Gomes')
    results = described_class.new.call(fuzzy: true)
    expect(results.any? { |r| r[:criterion] == 'name_fuzzy' && r[:score] >= 0.8 }).to be true
  end
end
