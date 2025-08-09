require 'rails_helper'

RSpec.describe 'V1::OwnerStatements', type: :request do
  let!(:user) { create(:user, email: 'admin@example.com', password: 'Password123!', password_confirmation: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'lists owner statements for a period (index)' do
    property = create(:property)
    contract = create(:contract, property: property, start_on: '2025-01-01', end_on: '2025-12-31', due_day: 5, monthly_rent: 1000, fee_rate_pct: 10.0)
    inv = create(:invoice, contract: contract, tenant: contract.tenant, issue_on: Date.new(2025, 8, 1), due_on: Date.new(2025, 8, 5), amount_cents: 100_00, balance_cents: 0)
    pay = create(:payment, amount_cents: 100_00)
    create(:payment_allocation, payment: pay, invoice: inv, amount_cents: 100_00)
    create(:admin_fee, contract: contract, period: '2025-08', base_cents: 100_00, fee_rate_pct: 10.0, fee_cents: 10_00)

    get '/v1/owner_statements', params: { period: '2025-08' }, headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']).to be_an(Array)
    expect(body['data'].length).to be >= 1
    expect(body['data'].first['period']).to eq('2025-08')
  end

  it 'shows a single owner statement (show)' do
    property = create(:property)
    st = create(:owner_statement, property: property, period: '2025-08', total_rent_cents: 100_00, total_expenses_cents: 0, total_fees_cents: 10_00, net_cents: 90_00)

    get "/v1/owner_statements/#{st.id}", headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']['id']).to eq(st.id)
    expect(body['data']['property_id']).to eq(property.id)
  end
end
