require 'rails_helper'

RSpec.describe 'V1::Dedup Properties', type: :request do
  let!(:user) { create(:user, password: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'lists property duplicates by address/unit' do
    # property has a unique index on [address, unit], so we cannot persist duplicates.
    # We simulate duplicates by stubbing the matcher service.
    allow(Dedup::PropertyMatcher).to receive(:new).and_return(
      instance_double(Dedup::PropertyMatcher, call: [ { entity: 'properties', criterion: 'address_unit', value: { address: 'XYZ', unit: '1' }, ids: %w[a b], count: 2 } ])
    )
    get '/v1/dedup/properties/candidates', headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data'].any? { |g| g['criterion'] == 'address_unit' }).to be true
  end
end
