module V1
  class SuppliersController < ApplicationController
    include Pagy::Backend

    def index
      authorize Supplier
      pagy, records = pagy(Supplier.order(created_at: :desc))
      render json: { data: records.as_json(only: %i[id name tax_id email phone]), meta: { page: pagy.page, pages: pagy.pages, count: pagy.count } }
    end

    def create
      authorize Supplier
      supplier = Supplier.new(supplier_params.merge(created_by_user: current_user))
      if supplier.save
        render json: { data: supplier.as_json(only: %i[id name tax_id email phone]) }, status: :created
      else
        render json: { errors: supplier.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def import
      authorize Supplier, :import?
      if params[:file].blank?
        return render json: { error: 'file_missing' }, status: :bad_request
      end
      importer = Suppliers::CsvImporter.new(current_user: current_user)
      result = importer.call(io: params[:file].tempfile, dry_run: params[:dry_run] != 'false')
      render json: { imported: result.imported, rejected: result.rejected, errors: result.errors }
    end

    private

    def supplier_params
      params.require(:supplier).permit(:name, :tax_id, :email, :phone, :bank_account)
    end
  end
end
