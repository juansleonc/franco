require 'rails_helper'

RSpec.describe 'V1::Dunning', type: :request do
  let!(:user) { create(:user, email: 'admin@example.com', password: 'Password123!', password_confirmation: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'returns candidates with stages' do
    contract = create(:contract, start_on: Date.today - 60, end_on: Date.today + 120, due_day: 5, monthly_rent: 1000)
    as_of = Date.new(2025, 8, 20)
    create(:invoice, contract: contract, tenant: contract.tenant, due_on: as_of - 8, issue_on: as_of - 30, amount_cents: 100_00, balance_cents: 100_00)

    get '/v1/dunning/candidates', params: { as_of: as_of.to_s }, headers: auth_headers
    expect(response).to have_http_status(:ok)
    data = JSON.parse(response.body)['data']
    expect(data.first['stage']).to eq('gentle')
  end
end
