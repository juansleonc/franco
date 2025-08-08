require 'rails_helper'

RSpec.describe "V1::Suppliers", type: :request do
  let!(:user) { User.create!(email: "admin@example.com", password: "Password123!", password_confirmation: "Password123!") }

  def auth_headers
    post "/v1/auth/login", params: { email: user.email, password: "Password123!" }
    token = JSON.parse(response.body)["token"]
    { "Authorization" => "Bearer #{token}" }
  end

  describe "GET /v1/suppliers" do
    it "returns list" do
      Supplier.create!(name: "Prov A", tax_id: "T1", email: "a@prov.com", phone: "1", created_by_user: user)
      get "/v1/suppliers", headers: auth_headers
      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)["data"]
      expect(data).to be_an(Array)
      expect(data.first["name"]).to eq("Prov A")
    end
  end

  describe "POST /v1/suppliers" do
    it "creates supplier" do
      post "/v1/suppliers", params: { supplier: { name: "Prov B", tax_id: "T2", email: "b@prov.com", phone: "2" } }, headers: auth_headers
      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body.dig("data", "tax_id")).to eq("T2")
    end
  end

  describe "POST /v1/suppliers/import" do
    it "returns stub response" do
      post "/v1/suppliers/import", headers: auth_headers
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["imported"]).to eq(0)
    end
  end
end
