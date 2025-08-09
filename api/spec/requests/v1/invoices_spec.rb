require 'rails_helper'

RSpec.describe 'V1::Invoices', type: :request do
  let!(:user) { create(:user, email: 'admin@example.com', password: 'Password123!', password_confirmation: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'lists invoices (index)' do
    create_list(:invoice, 2)
    get '/v1/invoices', headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']).to be_an(Array)
    expect(body['data'].length).to be >= 1
  end

  it 'shows invoice (show)' do
    invoice = create(:invoice)
    get "/v1/invoices/#{invoice.id}", headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']['id']).to eq(invoice.id)
  end
end
