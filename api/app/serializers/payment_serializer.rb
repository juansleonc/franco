class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :tenant_id, :received_on, :amount_cents, :currency, :method, :reference, :status, :created_at, :updated_at
  has_many :payment_allocations
end
