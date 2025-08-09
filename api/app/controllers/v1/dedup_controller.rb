module V1
  class DedupController < ApplicationController
    def candidates
      authorize :dedup, :index?
      entity = params[:entity]
      fuzzy = params[:fuzzy] == "true"
      case entity
      when "tenants"
        render json: { data: Dedup::TenantMatcher.new.call(fuzzy: fuzzy) }
      when "suppliers"
        render json: { data: Dedup::SupplierMatcher.new.call(fuzzy: fuzzy) }
      when "properties"
        render json: { data: Dedup::PropertyMatcher.new.call }
      else
        render json: { error: "unknown_entity" }, status: :bad_request
      end
    end

    def merge
      authorize :dedup, :update?
      entity = params.require(:entity)
      target_id = params.require(:target_id)
      source_ids = Array(params[:source_ids]).map(&:to_s)

      service = case entity
      when "tenants" then Dedup::TenantMerger.new
      when "suppliers" then Dedup::SupplierMerger.new
      when "properties" then Dedup::PropertyMerger.new
      else
                  return render json: { error: "unknown_entity" }, status: :bad_request
      end

      result = service.call(target_id: target_id, source_ids: source_ids)
      if result[:ok]
        render json: { data: result }
      else
        render json: { errors: result[:errors] }, status: :unprocessable_content
      end
    end
  end
end
