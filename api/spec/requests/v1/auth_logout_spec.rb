require 'rails_helper'

RSpec.describe "V1::Auth logout", type: :request do
  it "logs out and returns 204" do
    user = create(:user, email: "admin@example.com", password: "Password123!", password_confirmation: "Password123!")
    post "/v1/auth/login", params: { email: user.email, password: "Password123!" }, as: :json
    token = JSON.parse(response.body)["token"]

    delete "/v1/auth/logout", headers: { "Authorization" => "Bearer #{token}" }
    expect(response).to have_http_status(:no_content)
  end
end
