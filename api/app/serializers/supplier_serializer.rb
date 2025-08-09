class SupplierSerializer < ActiveModel::Serializer
  attributes :id, :name, :tax_id, :email, :phone, :created_at, :updated_at
end
