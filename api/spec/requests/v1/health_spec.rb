require 'rails_helper'

RSpec.describe "V1::Health", type: :request do
  describe "GET /v1/health" do
    it "returns ok" do
      host! "localhost:3000"
      get "/v1/health"
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["status"]).to eq("ok")
    end
  end
end
