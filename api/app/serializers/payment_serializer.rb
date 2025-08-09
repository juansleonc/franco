class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :tenant_id, :received_on, :amount_cents, :currency, :payment_method, :reference, :status, :created_at, :updated_at
  has_many :payment_allocations

  def payment_method
    object[:payment_method]
  end
end
