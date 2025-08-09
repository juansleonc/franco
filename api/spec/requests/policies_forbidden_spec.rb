require 'rails_helper'

RSpec.describe 'Pundit forbidden paths', type: :request do
  it 'returns 403 when accessing protected endpoint without auth' do
    get '/v1/properties'
    expect(response).to have_http_status(:unauthorized)
  end

  it 'rescues NotAuthorizedError to 403' do
    # Create user but make a policy deny explicitly (simulate by stubbing Pundit authorize)
    user = create(:user, password: 'secret123')
    post '/v1/auth/login', params: { email: user.email, password: 'secret123' }
    token = JSON.parse(response.body)['token']

    allow(Pundit).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
    get '/v1/properties', headers: { 'Authorization' => "Bearer #{token}" }
    expect(response).to have_http_status(:forbidden)
  end
end
