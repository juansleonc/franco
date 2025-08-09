require 'rails_helper'

RSpec.describe 'Auth header format', type: :request do
  it 'returns unauthorized without Bearer token' do
    get '/v1/tenants', headers: { 'Authorization' => 'Token abc' }
    expect(response).to have_http_status(:unauthorized)
  end
end
