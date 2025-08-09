require 'swagger_helper'

RSpec.describe 'v1/tenants', type: :request do
  let!(:user) { create(:user, email: 'admin@example.com', password: 'Password123!', password_confirmation: 'Password123!') }
  let!(:auth) do
    post "/v1/auth/login", params: { email: 'admin@example.com', password: 'Password123!' }
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end
  path '/v1/tenants' do
    get 'List tenants' do
      tags 'Tenants'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, schema: { type: :string }
      response '200', 'ok' do
        let(:'Authorization') { auth['Authorization'] }
        run_test!
      end
    end

    post 'Create tenant' do
      tags 'Tenants'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, schema: { type: :string }
      parameter name: :tenant, in: :body, schema: {
        type: :object,
        properties: { full_name: { type: :string }, email: { type: :string } },
        required: %w[full_name email]
      }
      response '201', 'created' do
        let(:'Authorization') { auth['Authorization'] }
        let(:tenant) { { full_name: 'Ana Gomez', email: 'ana@example.com' } }
        run_test!
      end
    end
  end

  path '/v1/tenants/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Show tenant' do
      tags 'Tenants'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, schema: { type: :string }
      response '200', 'ok' do
        let(:'Authorization') { auth['Authorization'] }
        let(:id) { create(:tenant, full_name: 'Ana', email: 'ana@example.com').id }
        run_test!
      end
    end

    patch 'Update tenant' do
      tags 'Tenants'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, schema: { type: :string }
      parameter name: :tenant, in: :body, schema: {
        type: :object,
        properties: { phone: { type: :string } }
      }
      response '200', 'updated' do
        let(:'Authorization') { auth['Authorization'] }
        let(:id) { create(:tenant, full_name: 'Ana', email: 'ana@example.com').id }
        let(:tenant) { { phone: '123' } }
        run_test!
      end
    end

    delete 'Delete tenant' do
      tags 'Tenants'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, schema: { type: :string }
      response '204', 'deleted' do
        let(:'Authorization') { auth['Authorization'] }
        let(:id) { create(:tenant, full_name: 'Ana', email: 'ana@example.com').id }
        run_test!
      end
    end
  end
end
