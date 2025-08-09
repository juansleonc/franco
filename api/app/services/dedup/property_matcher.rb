module Dedup
  class PropertyMatcher
    def call
      groups = Property.group(:address, :unit).having('count(*) > 1').count
      groups.map do |(address, unit), count|
        ids = Property.where(address: address, unit: unit).order(:created_at).pluck(:id)
        { entity: 'properties', criterion: 'address_unit', value: { address: address, unit: unit }, ids: ids, count: count }
      end
    end
  end
end
