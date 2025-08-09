require 'rails_helper'

RSpec.describe 'V1::Notifications CSV', type: :request do
  let!(:user) { create(:user, password: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'exports CSV with at least header row' do
    # Seed one log to ensure CSV has rows
    tenant = create(:tenant)
    contract = create(:contract, tenant: tenant)
    inv = create(:invoice, tenant: tenant, contract: contract)
    NotificationLog.create!(invoice: inv, tenant: tenant, channel: 'email', status: 'sent', sent_at: Time.current)
    get '/v1/notifications/logs.csv', headers: auth_headers
    expect(response).to have_http_status(:ok)
    expect(response.body).to include('invoice_id')
  end
end
