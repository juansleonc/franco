require 'rails_helper'

RSpec.describe 'V1::Auth header', type: :request do
  it 'sets Authorization header on successful login' do
    create(:user, email: 'admin@example.com', password: 'Password123!', password_confirmation: 'Password123!')
    post '/v1/auth/login', params: { email: 'admin@example.com', password: 'Password123!' }, as: :json
    expect(response).to have_http_status(:ok)
    expect(response.headers['Authorization']).to match(/^Bearer /)
  end
end
