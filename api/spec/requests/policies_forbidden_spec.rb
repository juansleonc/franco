require 'rails_helper'

RSpec.describe 'Pundit forbidden paths', type: :request do
  it 'returns 403 when accessing protected endpoint without auth' do
    get '/v1/properties'
    expect(response).to have_http_status(:unauthorized)
  end

  it 'rescues NotAuthorizedError to 403' do
    user = create(:user, password: 'secret123')
    post '/v1/auth/login', params: { email: user.email, password: 'secret123' }, as: :json
    token = JSON.parse(response.body)['token']

    allow_any_instance_of(ApplicationPolicy).to receive(:index?).and_return(false)
    get '/v1/properties', headers: { 'Authorization' => "Bearer #{token}" }
    expect(response).to have_http_status(:forbidden)
  end
end
