require 'rails_helper'

RSpec.describe 'V1::StatementLines', type: :request do
  let!(:user) { create(:user, email: 'admin@example.com', password: 'Password123!', password_confirmation: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'matches and ignores a statement line' do
    line = create(:statement_line)
    payment = create(:payment)

    post "/v1/statement_lines/#{line.id}/match", params: { payment_id: payment.id }, headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']['match_status']).to eq('matched')

    post "/v1/statement_lines/#{line.id}/ignore", headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']['match_status']).to eq('ignored')
  end
end
