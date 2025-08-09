class PaymentAllocationSerializer < ActiveModel::Serializer
  attributes :id, :payment_id, :invoice_id, :amount_cents, :created_at, :updated_at
end
