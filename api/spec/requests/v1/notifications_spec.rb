require 'rails_helper'

RSpec.describe 'V1::Notifications', type: :request do
  let!(:user) { create(:user, password: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'sends a test email' do
    post '/v1/notifications/send_test', params: { to: 'test@example.com', subject: 'Hi', body: 'Hello' }, headers: auth_headers
    expect(response).to have_http_status(:ok)
  end

  it 'sends a test sms' do
    post '/v1/notifications/send_test_sms', params: { to: '+123456' }, headers: auth_headers
    expect(response).to have_http_status(:ok)
  end
end
