require 'rails_helper'

RSpec.describe 'V1::Dedup Suppliers', type: :request do
  let!(:user) { create(:user, password: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'lists supplier duplicates by email (tax_id is unique)' do
    # tax_id is unique by validation and index, so we simulate duplicates via same email
    create(:supplier, tax_id: 'T-1a', email: 'dup-sup@example.com', name: 'S1')
    create(:supplier, tax_id: 'T-2a', email: 'dup-sup@example.com', name: 'S2')
    get '/v1/dedup/suppliers/candidates', headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data'].any? { |g| g['criterion'] == 'email' }).to be true
  end
end
