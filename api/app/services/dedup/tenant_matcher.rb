module Dedup
  class TenantMatcher
    def call
      groups = Tenant.group(:email).having('count(*) > 1').count
      groups.map do |email, count|
        ids = Tenant.where(email: email).order(:created_at).pluck(:id)
        { entity: 'tenants', criterion: 'email', value: email, ids: ids, count: count }
      end
    end
  end
end
