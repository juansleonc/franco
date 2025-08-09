require 'rails_helper'

RSpec.describe 'V1::Dedup', type: :request do
  let!(:user) { create(:user, password: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'lists tenant duplicate candidates' do
    create(:tenant, email: 'dup1@example.com')
    create(:tenant, email: 'dup1@example.com')
    get '/v1/dedup/tenants/candidates', headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']).to be_an(Array)
    expect(body['data'].first['entity']).to eq('tenants')
  end

  it 'lists fuzzy candidates when enabled' do
    create(:tenant, full_name: 'Ana Gomez', email: 'ana@x.com')
    create(:tenant, full_name: 'Ana Gomes', email: 'ana@x.com')
    get '/v1/dedup/tenants/candidates', params: { fuzzy: 'true' }, headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data'].any? { |g| g['criterion'] == 'name_fuzzy' }).to be true
  end

  it 'merges tenants' do
    t1 = create(:tenant, email: 'a1@example.com')
    t2 = create(:tenant, email: 'a1@example.com')
    post '/v1/dedup/merge', params: { entity: 'tenants', target_id: t1.id, source_ids: [t2.id] }, headers: auth_headers, as: :json
    expect(response).to have_http_status(:ok)
    expect(Tenant.where(id: t2.id)).to be_empty
  end
end
