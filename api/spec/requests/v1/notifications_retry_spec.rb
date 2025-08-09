require 'rails_helper'

RSpec.describe 'V1::Notifications retry', type: :request do
  let!(:user) { create(:user, password: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'retries failed logs and enqueues jobs' do
    tenant = create(:tenant, email: 't@example.com')
    contract = create(:contract, tenant: tenant)
    inv = create(:invoice, tenant: tenant, contract: contract)
    NotificationLog.create!(invoice: inv, tenant: tenant, channel: 'email', status: 'failed', sent_at: Time.current)

    expect {
      post '/v1/notifications/retry_failed', params: { invoice_id: inv.id }, headers: auth_headers
    }.to change { enqueued_jobs_count }.by_at_least(1)
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']['enqueued']).to be >= 1
  end
end
