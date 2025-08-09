require 'rails_helper'

RSpec.describe 'V1::Properties', type: :request do
  let!(:user) { create(:user, password: 'secret123') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'secret123' }
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'lists properties' do
    create(:property, name: 'Casa', address: 'Calle 1')
    get '/v1/properties', headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']).to be_an(Array)
    expect(body['data'].first['name']).to eq('Casa')
  end

  it 'creates, updates and deletes a property' do
    # create
    post '/v1/properties', params: { property: { name: 'Depto', address: 'Av Siempre Viva', unit: 'B' } }, headers: auth_headers
    expect(response).to have_http_status(:created)
    prop = JSON.parse(response.body)['data']

    # update
    patch "/v1/properties/#{prop['id']}", params: { property: { name: 'Depto Editado' } }, headers: auth_headers
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['data']['name']).to eq('Depto Editado')

    # delete
    delete "/v1/properties/#{prop['id']}", headers: auth_headers
    expect(response).to have_http_status(:no_content)
  end

  it 'returns 422 on invalid create' do
    post '/v1/properties', params: { property: { address: 'Sin nombre' } }, headers: auth_headers
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
