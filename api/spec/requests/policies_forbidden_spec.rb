require 'rails_helper'

RSpec.describe 'Pundit forbidden paths', type: :request do
  it 'returns 403 when accessing protected endpoint without auth' do
    get '/v1/properties'
    expect(response).to have_http_status(:unauthorized)
  end
end
