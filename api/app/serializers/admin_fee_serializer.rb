class AdminFeeSerializer < ActiveModel::Serializer
  attributes :id, :contract_id, :period, :base_cents, :fee_rate_pct, :fee_cents, :status, :created_at
end
