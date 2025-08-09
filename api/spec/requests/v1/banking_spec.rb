require 'rails_helper'

RSpec.describe 'V1::Banking', type: :request do
  let!(:user) { create(:user, password: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'lists accounts (stub)' do
    get '/v1/banking/accounts', headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']).to be_an(Array)
  end

  it 'syncs (stub)' do
    post '/v1/banking/sync', headers: auth_headers
    expect(response).to have_http_status(:ok)
  end
end
