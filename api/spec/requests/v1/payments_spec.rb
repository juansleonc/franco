require 'rails_helper'

RSpec.describe 'V1::Payments', type: :request do
  let!(:user) { create(:user, email: 'admin@example.com', password: 'Password123!', password_confirmation: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'lists payments (index)' do
    create_list(:payment, 2)
    get '/v1/payments', headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']).to be_an(Array)
    expect(body['data'].length).to be >= 1
  end

  it 'creates and updates a payment' do
    tenant = create(:tenant)
    post '/v1/payments', params: { payment: { tenant_id: tenant.id, received_on: Date.today, amount_cents: 100_00, currency: 'USD', payment_method: 'cash', reference: 'ref-1', status: 'captured' } }, headers: auth_headers
    expect(response).to have_http_status(:created)
    body = JSON.parse(response.body)
    id = body['data']['id']

    patch "/v1/payments/#{id}", params: { payment: { reference: 'ref-2' } }, headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']['reference']).to eq('ref-2')
  end

  it 'shows payment (show)' do
    payment = create(:payment)
    get "/v1/payments/#{payment.id}", headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']['id']).to eq(payment.id)
  end
end
