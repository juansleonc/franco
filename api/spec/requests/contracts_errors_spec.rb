require 'rails_helper'

RSpec.describe 'V1::Contracts errors', type: :request do
  let!(:user) { create(:user, password: 'secret123') }
  let!(:property) { create(:property, name: 'Casa', address: 'Calle 1') }
  let!(:tenant) { create(:tenant, full_name: 'Ana', email: 'ana@example.com') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'secret123' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'returns 422 when end_on <= start_on' do
    post '/v1/contracts', params: { contract: { property_id: property.id, tenant_id: tenant.id, start_on: '2025-01-01', end_on: '2024-12-31', due_day: 5, monthly_rent: 1000 } }, headers: auth_headers, as: :json
    expect(response).to have_http_status(:unprocessable_content)
  end

  it 'returns 422 when due_day out of range' do
    post '/v1/contracts', params: { contract: { property_id: property.id, tenant_id: tenant.id, start_on: '2025-01-01', end_on: '2025-12-31', due_day: 31, monthly_rent: 1000 } }, headers: auth_headers, as: :json
    expect(response).to have_http_status(:unprocessable_content)
  end

  it 'returns 422 when monthly_rent <= 0' do
    post '/v1/contracts', params: { contract: { property_id: property.id, tenant_id: tenant.id, start_on: '2025-01-01', end_on: '2025-12-31', due_day: 5, monthly_rent: 0 } }, headers: auth_headers, as: :json
    expect(response).to have_http_status(:unprocessable_content)
  end
end
