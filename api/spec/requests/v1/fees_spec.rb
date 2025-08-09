require 'rails_helper'

RSpec.describe 'V1::Fees', type: :request do
  let!(:user) { create(:user, email: 'admin@example.com', password: 'Password123!', password_confirmation: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'calculates admin fees for a period' do
    contract = create(:contract, start_on: '2025-01-01', end_on: '2025-12-31', due_day: 5, monthly_rent: 1000, fee_rate_pct: 10.0)
    inv = create(:invoice, contract: contract, tenant: contract.tenant, issue_on: Date.new(2025,8,1), due_on: Date.new(2025,8,5), amount_cents: 100_00, balance_cents: 0)
    pay = create(:payment, amount_cents: 100_00)
    create(:payment_allocation, payment: pay, invoice: inv, amount_cents: 100_00)

    post '/v1/fees/calculate', params: { period: '2025-08' }, headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['generated']).to be >= 1
  end
end
