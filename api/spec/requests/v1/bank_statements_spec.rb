require 'rails_helper'

RSpec.describe 'V1::BankStatements', type: :request do
  let!(:user) { create(:user, email: 'admin@example.com', password: 'Password123!', password_confirmation: 'Password123!') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'Password123!' }, as: :json
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'imports a bank statement' do
    file = Rack::Test::UploadedFile.new(StringIO.new('data'), 'text/plain', original_filename: 'stmt.csv')
    post '/v1/bank_statements/import', params: { file: file }, headers: auth_headers
    expect(response).to have_http_status(:created)
    body = JSON.parse(response.body)
    expect(body['data']['original_filename']).to eq('stmt.csv')
  end

  it 'parses CSV and creates statement lines' do
    csv = <<~CSV
      date,amount,description
      2025-08-01,100.50,Payment A
      2025-08-02,-20.00,Fee
    CSV
    file = Rack::Test::UploadedFile.new(StringIO.new(csv), 'text/csv', original_filename: 'stmt.csv')
    expect {
      post '/v1/bank_statements/import', params: { file: file }, headers: auth_headers
    }.to change(StatementLine, :count).by(2)
    expect(response).to have_http_status(:created)
  end

  it 'shows a bank statement' do
    st = create(:bank_statement)
    get "/v1/bank_statements/#{st.id}", headers: auth_headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']['id']).to eq(st.id)
  end
end
