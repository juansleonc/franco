require 'rails_helper'

RSpec.describe 'V1::Banking with Plaid', type: :request do
  let!(:user) { create(:user, password: 'Password123!') }

  around do |ex|
    orig = ENV.to_hash
    ENV['BANKING_PROVIDER'] = 'plaid'
    ENV['PLAID_CLIENT_ID'] = 'id'
    ENV['PLAID_SECRET'] = 'secret'
    Banking.reset_client!
    ex.run
    ENV.replace(orig)
    Banking.reset_client!
  end

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'lists accounts via plaid client' do
    get '/v1/banking/accounts', headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data'].first['id']).to include('plaid')
  end
end
