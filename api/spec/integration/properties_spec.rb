require 'swagger_helper'

RSpec.describe 'v1/properties', type: :request do
  let!(:user) { create(:user, email: 'admin@example.com', password: 'Password123!', password_confirmation: 'Password123!') }
  let!(:auth_token) do
    post "/v1/auth/login", params: { email: user.email, password: 'Password123!' }
    JSON.parse(response.body)['token']
  end
  path '/v1/properties' do
    get 'List properties' do
      tags 'Properties'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, schema: { type: :string }, description: 'Bearer token'
      response '200', 'ok' do
        let(:'Authorization') { "Bearer #{auth_token}" }
        run_test!
      end
    end

    post 'Create property' do
      tags 'Properties'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, schema: { type: :string }
      parameter name: :property, in: :body, schema: {
        type: :object,
        properties: { name: { type: :string }, address: { type: :string }, unit: { type: :string } },
        required: %w[name address]
      }
      response '201', 'created' do
        let(:'Authorization') { "Bearer #{auth_token}" }
        let(:property) { { name: 'Casa', address: 'Calle 1' } }
        run_test!
      end
    end
  end

  path '/v1/properties/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Show property' do
      tags 'Properties'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, schema: { type: :string }
      response '200', 'ok' do
        let(:'Authorization') { "Bearer #{auth_token}" }
        let(:id) { create(:property, name: 'Casa', address: 'Calle 1').id }
        run_test!
      end
    end

    patch 'Update property' do
      tags 'Properties'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, schema: { type: :string }
      parameter name: :property, in: :body, schema: {
        type: :object,
        properties: { name: { type: :string } }
      }
      response '200', 'updated' do
        let(:'Authorization') { "Bearer #{auth_token}" }
        let(:id) { create(:property, name: 'Casa', address: 'Calle 1').id }
        let(:property) { { name: 'New' } }
        run_test!
      end
    end

    delete 'Delete property' do
      tags 'Properties'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, schema: { type: :string }
      response '204', 'deleted' do
        let(:'Authorization') { "Bearer #{auth_token}" }
        let(:id) { create(:property, name: 'Casa', address: 'Calle 1').id }
        run_test!
      end
    end
  end
end
