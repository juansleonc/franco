module Dedup
  class SupplierMatcher
    def call
      res = []
      dup_by_tax = Supplier.group(:tax_id).having('count(*) > 1').count
      res += dup_by_tax.map do |tax_id, count|
        { entity: 'suppliers', criterion: 'tax_id', value: tax_id, ids: Supplier.where(tax_id: tax_id).pluck(:id), count: count }
      end
      dup_by_email = Supplier.group(:email).having('count(*) > 1').count
      res += dup_by_email.map do |email, count|
        { entity: 'suppliers', criterion: 'email', value: email, ids: Supplier.where(email: email).pluck(:id), count: count }
      end
      res
    end
  end
end
