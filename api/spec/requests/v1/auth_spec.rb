require 'rails_helper'

RSpec.describe "V1::Auth", type: :request do
  before do
    create(:user, email: "admin@example.com", password: "Password123!", password_confirmation: "Password123!")
  end

  it "logs in and receives JWT" do
    post "/v1/auth/login", params: { email: "admin@example.com", password: "Password123!" }, as: :json
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["token"]).to be_present
  end

  it "rejects invalid credentials" do
    post "/v1/auth/login", params: { email: "admin@example.com", password: "bad" }, as: :json
    expect(response).to have_http_status(:unauthorized)
  end
end
