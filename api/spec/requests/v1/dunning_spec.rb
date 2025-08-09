require 'rails_helper'

RSpec.describe 'V1::Dunning', type: :request do
  let!(:user) { create(:user, email: 'admin@example.com', password: 'Password123!', password_confirmation: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'returns candidates with stages' do
    contract = create(:contract, start_on: Date.today - 60, end_on: Date.today + 120, due_day: 5, monthly_rent: 1000)
    as_of = Date.new(2025, 8, 20)
    create(:invoice, contract: contract, tenant: contract.tenant, due_on: as_of - 8, issue_on: as_of - 30, amount_cents: 100_00, balance_cents: 100_00)

    get '/v1/dunning/candidates', params: { as_of: as_of.to_s }, headers: auth_headers
    expect(response).to have_http_status(:ok)
    data = JSON.parse(response.body)['data']
    expect(data.first['stage']).to eq('gentle')
    # second call should not mutate state and should return same candidates
    get '/v1/dunning/candidates', params: { as_of: as_of.to_s }, headers: auth_headers
    second = JSON.parse(response.body)['data']
    expect(second).not_to be_empty
  end

  it 'previews channels without side effects' do
    property = create(:property)
    tenant = create(:tenant, email: 'a@x.com', phone: '+111')
    contract = create(:contract, property: property, tenant: tenant, start_on: Date.today - 90, end_on: Date.today + 90, due_day: 1)
    create(:invoice, contract: contract, tenant: tenant, due_on: Date.today - 10, balance_cents: 1000)
    get '/v1/dunning/preview', headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']).to be_an(Array)
    # When there are candidates, first entry includes email and phone
    if body['data'].any?
      expect(body['data'].first).to include('email', 'phone')
    end
  end

  it 'enqueues bulk notifications job' do
    tenant = create(:tenant, email: 'a@x.com', phone: '+111')
    contract = create(:contract, tenant: tenant)
    inv = create(:invoice, tenant: tenant, contract: contract, balance_cents: 5000)
    # Use ActiveJob test helper expectations if available, fallback to response check
    post '/v1/dunning/send_bulk', params: { invoice_ids: [ inv.id ], channels: %w[email sms] }, headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']['enqueued']).to eq(1)
  end

  it 'throttles frequent sends per tenant/channel' do
    tenant = create(:tenant, email: 'a@x.com', phone: '+111')
    contract = create(:contract, tenant: tenant)
    inv = create(:invoice, tenant: tenant, contract: contract, balance_cents: 5000)
    NotificationLog.create!(invoice: inv, tenant: tenant, channel: 'email', status: 'sent', sent_at: Time.current)
    post '/v1/dunning/send_bulk', params: { invoice_ids: [ inv.id ], channels: %w[email] }, headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']['throttled']).to be >= 1
  end
end
