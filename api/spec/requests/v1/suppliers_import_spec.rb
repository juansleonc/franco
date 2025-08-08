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

  it "persists when dry_run is false and updates duplicates" do
    Supplier.create!(name: "Old", tax_id: "TAX1", email: "old@example.com", created_by_user: user)

    csv = <<~CSV
      legalName,taxId,email
      Proveedor 1,TAX1,new1@example.com
      Proveedor 3,TAX3,p3@example.com
    CSV
    file = Tempfile.new(["suppliers", ".csv"]).tap { |f| f.write(csv); f.rewind }

    post "/v1/suppliers/import", headers: auth_headers, params: { file: Rack::Test::UploadedFile.new(file.path, 'text/csv'), dry_run: 'false' }
    expect(response).to have_http_status(:ok)
    expect(Supplier.find_by(tax_id: 'TAX1').email).to eq('new1@example.com')
    expect(Supplier.find_by(tax_id: 'TAX3')).to be_present
  ensure
    file.close!
  end

  it "returns error CSV when requested" do
    csv = <<~CSV
      legalName,taxId,email
      ,MISSING_NAME,invalid-email
    CSV
    file = Tempfile.new(["suppliers", ".csv"]).tap { |f| f.write(csv); f.rewind }

    post "/v1/suppliers/import", headers: auth_headers, params: { file: Rack::Test::UploadedFile.new(file.path, 'text/csv'), dry_run: 'true', generate_error_csv: 'true' }
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["rejected"]).to be >= 1
    expect(body["errors"]).to be_an(Array)
  ensure
    file.close!
  end
end
