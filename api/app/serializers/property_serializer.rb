class PropertySerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :unit, :active, :created_at, :updated_at
end
