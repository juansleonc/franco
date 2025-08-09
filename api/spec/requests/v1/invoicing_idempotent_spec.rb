require 'rails_helper'

RSpec.describe 'V1::Invoicing idempotent', type: :request do
  let!(:user) { create(:user, email: 'admin@example.com', password: 'Password123!', password_confirmation: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'skips generation when invoice already exists for month' do
    contract = create(:contract, start_on: '2025-01-01', end_on: '2025-12-31', due_day: 10, monthly_rent: 1000)
    post '/v1/invoicing/generate_monthly', params: { as_of: '2025-08-15' }, headers: auth_headers
    post '/v1/invoicing/generate_monthly', params: { as_of: '2025-08-20' }, headers: auth_headers
    expect(Invoice.where(contract_id: contract.id, issue_on: Date.new(2025, 8, 1)..Date.new(2025, 8, 31)).count).to eq(1)
  end
end
