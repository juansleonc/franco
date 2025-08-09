require 'rails_helper'

RSpec.describe 'Banking.client', type: :model do
  around do |ex|
    orig = ENV.to_hash
    ex.run
    ENV.replace(orig)
    Banking.reset_client!
  end

  it 'returns NullClient by default' do
    Banking.reset_client!
    expect(Banking.client).to be_a(Banking::NullClient)
    expect(Banking.client.list_accounts).to be_an(Array)
  end

  it 'returns PlaidClient when env is set' do
    ENV['BANKING_PROVIDER'] = 'plaid'
    ENV['PLAID_CLIENT_ID'] = 'x'
    ENV['PLAID_SECRET'] = 'y'
    Banking.reset_client!
    expect(Banking.client).to be_a(Banking::PlaidClient)
    expect(Banking.client.list_accounts).to be_an(Array)
  end
end
