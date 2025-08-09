require 'rails_helper'

RSpec.describe 'V1::Contracts CRUD', type: :request do
  let!(:user) { User.create!(email: 'user@example.com', password: 'secret123') }
  let!(:property) { Property.create!(name: 'Depto 1', address: 'Calle 123', unit: 'A') }
  let!(:tenant) { Tenant.create!(full_name: 'Juan Perez', email: 'juan@example.com') }

  before { sign_in user }

  it 'creates, shows, updates and deletes contract' do
    post '/v1/contracts', params: { contract: { property_id: property.id, tenant_id: tenant.id, start_on: '2025-01-01', end_on: '2025-12-31', due_day: 5, monthly_rent: 1000 } }
    expect(response).to have_http_status(:created)
    c = JSON.parse(response.body)['data']

    get "/v1/contracts/#{c['id']}"
    expect(response).to have_http_status(:ok)

    patch "/v1/contracts/#{c['id']}", params: { contract: { monthly_rent: 1200 } }
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['data']['monthly_rent'].to_s).to eq('1200.0')

    delete "/v1/contracts/#{c['id']}"
    expect(response).to have_http_status(:no_content)
  end

  it 'returns 422 on invalid date range' do
    post '/v1/contracts', params: { contract: { property_id: property.id, tenant_id: tenant.id, start_on: '2025-01-01', end_on: '2024-12-31', due_day: 5, monthly_rent: 1000 } }
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
