require 'rails_helper'

RSpec.describe 'V1::Tenants', type: :request do
  let!(:user) { create(:user, password: 'secret123') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'secret123' }
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'lists tenants' do
    create(:tenant, full_name: 'Ana Gomez', email: 'ana@example.com')
    get '/v1/tenants', headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']).to be_an(Array)
    expect(body['data'].first['full_name']).to eq('Ana Gomez')
  end

  it 'creates, updates and deletes a tenant' do
    # create
    post '/v1/tenants', params: { tenant: { full_name: 'Pepe', email: 'pepe@example.com' } }, headers: auth_headers
    expect(response).to have_http_status(:created)
    ten = JSON.parse(response.body)['data']

    # update
    patch "/v1/tenants/#{ten['id']}", params: { tenant: { phone: '123' } }, headers: auth_headers
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['data']['phone']).to eq('123')

    # delete
    delete "/v1/tenants/#{ten['id']}", headers: auth_headers
    expect(response).to have_http_status(:no_content)
  end

  it 'returns 422 on invalid create' do
    post '/v1/tenants', params: { tenant: { full_name: '' } }, headers: auth_headers
    expect(response).to have_http_status(:unprocessable_content)
  end

  it 'returns 422 on invalid update' do
    post '/v1/tenants', params: { tenant: { full_name: 'Bad', email: 'bad@example.com' } }, headers: auth_headers
    ten = JSON.parse(response.body)['data']
    patch "/v1/tenants/#{ten['id']}", params: { tenant: { full_name: '' } }, headers: auth_headers
    expect(response).to have_http_status(:unprocessable_content)
  end

  it 'requires authentication' do
    get '/v1/tenants'
    expect(response).to have_http_status(:unauthorized)
  end
end
