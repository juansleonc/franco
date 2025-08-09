module Dedup
  class SupplierMerger
    def call(target_id:, source_ids: [])
      errors = []
      ActiveRecord::Base.transaction do
        target = Supplier.find(target_id)
        sources = Supplier.where(id: source_ids).to_a
        if sources.empty?
          return { ok: false, errors: [ "no_sources" ] }
        end
        sources.each do |src|
          next if src.id == target.id
          src.destroy!
        rescue => e
          errors << e.message
        end
        raise ActiveRecord::Rollback if errors.any?
      end
      { ok: errors.empty?, errors: errors }
    end
  end
end
