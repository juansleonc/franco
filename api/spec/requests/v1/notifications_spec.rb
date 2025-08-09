require 'rails_helper'

RSpec.describe 'V1::Notifications', type: :request do
  let!(:user) { create(:user, password: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'sends a test email' do
    # Stub delivery to avoid SMTP in test
    allow(DunningMailer).to receive(:test_email).and_return(double(deliver_now: true))
    post '/v1/notifications/send_test', params: { to: 'test@example.com', subject: 'Hi', body: 'Hello' }, headers: auth_headers
    expect(response).to have_http_status(:ok)
  end

  it 'sends a test sms' do
    # Ensure Sms.client exists
    require Rails.root.join('app/services/sms/client')
    post '/v1/notifications/send_test_sms', params: { to: '+123456' }, headers: auth_headers
    expect(response).to have_http_status(:ok)
  end

  it 'sends dunning email for invoice' do
    allow(DunningMailer).to receive(:overdue_notice).and_return(double(deliver_now: true))
    tenant = create(:tenant, email: 't@example.com', full_name: 'T')
    contract = create(:contract, tenant: tenant)
    invoice = create(:invoice, tenant: tenant, contract: contract, balance_cents: 12345)
    post '/v1/notifications/dunning_email', params: { invoice_id: invoice.id }, headers: auth_headers
    expect(response).to have_http_status(:ok)
  end

  it 'sends dunning sms for invoice (null client)' do
    require Rails.root.join('app/services/sms/client')
    tenant = create(:tenant, email: 't@example.com', full_name: 'T', phone: '+100000')
    contract = create(:contract, tenant: tenant)
    invoice = create(:invoice, tenant: tenant, contract: contract, balance_cents: 12345)
    post '/v1/notifications/dunning_sms', params: { invoice_id: invoice.id }, headers: auth_headers
    expect(response).to have_http_status(:ok)
  end

  it 'lists notification logs filtered by invoice' do
    tenant = create(:tenant, email: 't@example.com', full_name: 'T')
    contract = create(:contract, tenant: tenant)
    invoice = create(:invoice, tenant: tenant, contract: contract)
    NotificationLog.create!(invoice: invoice, tenant: tenant, channel: 'email', status: 'sent', sent_at: Time.current)
    get '/v1/notifications/logs', params: { invoice_id: invoice.id }, headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']).not_to be_empty
    expect(body['data'].first['invoice_id']).to eq(invoice.id)
  end
end
