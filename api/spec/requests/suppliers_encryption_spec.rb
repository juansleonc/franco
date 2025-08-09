require 'rails_helper'

RSpec.describe 'V1::Suppliers encryption', type: :request do
  let!(:user) { create(:user, password: 'secret123') }

  def auth_headers
    post '/v1/auth/login', params: { email: user.email, password: 'secret123' }
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'stores bank_account encrypted and not exposed by serializer' do
    post '/v1/suppliers', params: { supplier: { name: 'Prov Z', tax_id: 'TZ', email: 'z@prov.com', phone: '1', bank_account: 'ES7620770024003102575766' } }, headers: auth_headers
    expect(response).to have_http_status(:created)
    data = JSON.parse(response.body)['data']
    expect(data['bank_account']).to be_nil
    supplier = Supplier.find(data['id'])
    # ciphertext should not be blank when bank_account present
    expect(supplier.bank_account_ciphertext).to be_present
  end
end
