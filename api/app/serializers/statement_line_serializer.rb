class StatementLineSerializer < ActiveModel::Serializer
  attributes :id, :bank_statement_id, :posted_on, :description, :amount_cents, :match_status, :matched_payment_id, :created_at
end
