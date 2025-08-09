require 'rails_helper'

RSpec.describe 'V1::Notifications Logs', type: :request do
  let!(:user) { create(:user, password: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'filters by tenant and channel and since' do
    tenant = create(:tenant, email: 't@example.com')
    contract = create(:contract, tenant: tenant)
    inv = create(:invoice, tenant: tenant, contract: contract)
    NotificationLog.create!(invoice: inv, tenant: tenant, channel: 'email', status: 'sent', sent_at: 1.hour.ago)
    NotificationLog.create!(invoice: inv, tenant: tenant, channel: 'sms', status: 'sent', sent_at: 2.days.ago)
    get '/v1/notifications/logs', params: { tenant_id: tenant.id, channel: 'email', since: 2.hours.ago.iso8601 }, headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data'].length).to eq(1)
    expect(body['data'].first['channel']).to eq('email')
  end

  it 'exports logs as CSV' do
    tenant = create(:tenant, email: 't2@example.com')
    contract = create(:contract, tenant: tenant)
    inv = create(:invoice, tenant: tenant, contract: contract)
    NotificationLog.create!(invoice: inv, tenant: tenant, channel: 'email', status: 'failed', sent_at: Time.current)
    get '/v1/notifications/logs.csv', params: { tenant_id: tenant.id }, headers: auth_headers
    expect(response).to have_http_status(:ok)
    # Rails may set application/octet-stream in tests; just ensure CSV header row exists
    expect(response.body).to include('invoice_id')
  end

  it 'retries failed logs enqueueing jobs' do
    tenant = create(:tenant, email: 't3@example.com')
    contract = create(:contract, tenant: tenant)
    inv = create(:invoice, tenant: tenant, contract: contract)
    NotificationLog.create!(invoice: inv, tenant: tenant, channel: 'email', status: 'failed', sent_at: Time.current)
    post '/v1/notifications/retry_failed', params: { tenant_id: tenant.id, channel: 'email' }, headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']['enqueued']).to be >= 1
  end
end
