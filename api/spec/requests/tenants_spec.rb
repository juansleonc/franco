require 'rails_helper'

RSpec.describe 'V1::Tenants', type: :request do
  let!(:user) { User.create!(email: 'user@example.com', password: 'secret123') }

  before { sign_in user }

  it 'lists tenants' do
    Tenant.create!(full_name: 'Ana Gomez', email: 'ana@example.com')
    get '/v1/tenants'
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']).to be_an(Array)
    expect(body['data'].first['full_name']).to eq('Ana Gomez')
  end

  it 'creates, updates and deletes a tenant' do
    # create
    post '/v1/tenants', params: { tenant: { full_name: 'Pepe', email: 'pepe@example.com' } }
    expect(response).to have_http_status(:created)
    ten = JSON.parse(response.body)['data']

    # update
    patch "/v1/tenants/#{ten['id']}", params: { tenant: { phone: '123' } }
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['data']['phone']).to eq('123')

    # delete
    delete "/v1/tenants/#{ten['id']}"
    expect(response).to have_http_status(:no_content)
  end

  it 'returns 422 on invalid create' do
    post '/v1/tenants', params: { tenant: { full_name: '' } }
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
