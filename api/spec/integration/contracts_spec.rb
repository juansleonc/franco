require 'swagger_helper'

RSpec.describe 'v1/contracts', type: :request do
  let!(:user) { create(:user, email: 'admin@example.com', password: 'Password123!', password_confirmation: 'Password123!') }
  let!(:auth) do
    post "/v1/auth/login", params: { email: user.email, password: 'Password123!' }
    token = JSON.parse(response.body)['token']
    { 'Authorization' => "Bearer #{token}" }
  end
  path '/v1/contracts' do
    get 'List contracts' do
      tags 'Contracts'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, schema: { type: :string }
      response '200', 'ok' do
        let(:'Authorization') { auth['Authorization'] }
        run_test!
      end
    end

    post 'Create contract' do
      tags 'Contracts'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, schema: { type: :string }
      parameter name: :contract, in: :body, schema: {
        type: :object,
        properties: {
          property_id: { type: :string }, tenant_id: { type: :string },
          start_on: { type: :string, format: :date }, end_on: { type: :string, format: :date },
          due_day: { type: :integer }, monthly_rent: { type: :number }
        },
        required: %w[property_id tenant_id start_on end_on due_day monthly_rent]
      }
      response '201', 'created' do
        let(:'Authorization') { auth['Authorization'] }
        let(:contract) do
          p = create(:property, name: 'Casa', address: 'Calle 1')
          t = create(:tenant, full_name: 'Ana', email: 'ana@example.com')
          { property_id: p.id, tenant_id: t.id, start_on: '2025-01-01', end_on: '2025-12-31', due_day: 5, monthly_rent: 1000 }
        end
        run_test!
      end
    end
  end

  path '/v1/contracts/schedule_preview' do
    post 'Preview rent schedule' do
      tags 'Contracts'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, schema: { type: :string }
      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: { start_on: { type: :string, format: :date }, due_day: { type: :integer }, months: { type: :integer } },
        required: %w[start_on due_day]
      }
      response '200', 'ok' do
        let(:'Authorization') { auth['Authorization'] }
        let(:payload) { { start_on: '2025-01-15', due_day: 10, months: 3 } }
        run_test!
      end
    end
  end
end
