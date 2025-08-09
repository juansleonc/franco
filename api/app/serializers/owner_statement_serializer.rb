class OwnerStatementSerializer < ActiveModel::Serializer
  attributes :id, :property_id, :period, :total_rent_cents, :total_expenses_cents, :total_fees_cents, :net_cents, :created_at
end
