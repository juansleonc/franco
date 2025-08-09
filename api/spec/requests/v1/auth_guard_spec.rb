require 'rails_helper'

RSpec.describe 'Auth guards', type: :request do
  it 'protects invoicing generate endpoint' do
    post '/v1/invoicing/generate_monthly', params: { as_of: '2025-08-15' }
    expect(response).to have_http_status(:unauthorized)
  end

  it 'protects dunning candidates endpoint' do
    get '/v1/dunning/candidates', params: { as_of: '2025-08-15' }
    expect(response).to have_http_status(:unauthorized)
  end
end
