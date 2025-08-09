require 'rails_helper'

RSpec.describe 'V1::Contracts index', type: :request do
  let!(:user) { create(:user, password: 'secret123') }
  let!(:property) { create(:property, name: 'Casa', address: 'Calle 1') }
  let!(:tenant) { create(:tenant, full_name: 'Ana', email: 'ana@example.com') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'secret123' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'lists contracts with pagination meta' do
    create(:contract, property: property, tenant: tenant, start_on: '2025-01-01', end_on: '2025-12-31', due_day: 5, monthly_rent: 1000)
    get '/v1/contracts', headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']).to be_an(Array)
    expect(body['meta']).to include('page', 'pages', 'count')
  end
end
