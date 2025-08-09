require 'rails_helper'

RSpec.describe 'V1::Contracts', type: :request do
  let!(:user) { create(:user, password: 'secret123') }
  let!(:property) { create(:property, name: 'Depto 1', address: 'Calle 123', unit: 'A') }
  let!(:tenant) { create(:tenant, full_name: 'Juan Perez', email: 'juan@example.com') }

  before do
    sign_in user
  end

  it 'previews schedule' do
    post '/v1/contracts/schedule_preview', params: { start_on: '2025-01-15', due_day: 10, months: 3 }, as: :json
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['schedule'].size).to eq(3)
  end

  it 'prevents overlapping contracts' do
    Contract.create!(property: property, tenant: tenant, start_on: '2025-01-01', end_on: '2025-12-31', due_day: 5, monthly_rent: 1000)
    post '/v1/contracts', params: { contract: { property_id: property.id, tenant_id: tenant.id, start_on: '2025-06-01', end_on: '2025-09-30', due_day: 5, monthly_rent: 1200 } }, as: :json
    expect(response).to have_http_status(:unprocessable_content)
  end
end
