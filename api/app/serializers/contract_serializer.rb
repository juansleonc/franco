class ContractSerializer < ActiveModel::Serializer
  attributes :id, :property_id, :tenant_id, :start_on, :end_on, :due_day, :monthly_rent, :active, :created_at, :updated_at
end
