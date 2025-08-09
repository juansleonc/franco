require 'rails_helper'

RSpec.describe 'V1::Contracts overlaps', type: :request do
  let!(:user) { create(:user, password: 'secret123') }
  let!(:property) { create(:property, name: 'Depto 1', address: 'Calle 123', unit: 'A') }
  let!(:tenant) { create(:tenant, full_name: 'Juan Perez', email: 'juan@example.com') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'secret123' }
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'allows non-overlapping contracts and rejects overlapping' do
    post '/v1/contracts', params: { contract: { property_id: property.id, tenant_id: tenant.id, start_on: '2025-01-01', end_on: '2025-03-31', due_day: 5, monthly_rent: 1000, active: true } }, headers: auth_headers
    expect(response).to have_http_status(:created)

    post '/v1/contracts', params: { contract: { property_id: property.id, tenant_id: tenant.id, start_on: '2025-04-01', end_on: '2025-06-30', due_day: 5, monthly_rent: 1000, active: true } }, headers: auth_headers
    expect(response).to have_http_status(:created)

    post '/v1/contracts', params: { contract: { property_id: property.id, tenant_id: tenant.id, start_on: '2025-03-15', end_on: '2025-04-15', due_day: 5, monthly_rent: 1000, active: true } }, headers: auth_headers
    expect(response).to have_http_status(:unprocessable_content)
  end
end
