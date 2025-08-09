class TenantSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :email, :phone, :created_at, :updated_at
end
