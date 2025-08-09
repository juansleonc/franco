class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :contract_id, :tenant_id, :issue_on, :due_on, :amount_cents, :balance_cents, :currency, :status, :created_at, :updated_at
end
