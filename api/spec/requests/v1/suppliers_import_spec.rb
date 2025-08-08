require 'rails_helper'

RSpec.describe "V1::Suppliers import", type: :request do
  let!(:user) { User.create!(email: "admin@example.com", password: "Password123!", password_confirmation: "Password123!") }

  def auth_headers
    post "/v1/auth/login", params: { email: user.email, password: "Password123!" }
    token = JSON.parse(response.body)["token"]
    { "Authorization" => "Bearer #{token}" }
  end

  it "dry runs CSV and returns counts" do
    csv = <<~CSV
      legalName,taxId,email,phone
      Proveedor 1,TAX1,p1@example.com,111
      Proveedor 2,TAX2,p2@example.com,222
    CSV
    file = Tempfile.new(["suppliers", ".csv"]).tap { |f| f.write(csv); f.rewind }

    post "/v1/suppliers/import", headers: auth_headers, params: { file: Rack::Test::UploadedFile.new(file.path, 'text/csv'), dry_run: 'true' }
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["imported"]).to eq(2)
    expect(body["rejected"]).to eq(0)
  ensure
    file.close!
  end
end
