require 'swagger_helper'

RSpec.describe 'v1/health', type: :request do
  before { host! 'localhost:3000' }

  path '/v1/health' do
    get 'Health check' do
      tags 'Health'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'ok' do
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['status']).to eq('ok')
        end
      end
    end
  end
end
