module V1
  class SuppliersController < ApplicationController
    def index
      suppliers = Supplier.order(created_at: :desc).limit(25)
      render json: { data: suppliers.as_json(only: %i[id name tax_id email phone]) }
    end

    def create
      supplier = Supplier.new(supplier_params.merge(created_by_user: current_user))
      if supplier.save
        render json: { data: supplier.as_json(only: %i[id name tax_id email phone]) }, status: :created
      else
        render json: { errors: supplier.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def import
      # stub for CSV import; to be implemented with dry_run
      render json: { imported: 0, rejected: 0, errors: [] }
    end

    private

    def supplier_params
      params.require(:supplier).permit(:name, :tax_id, :email, :phone, :bank_account)
    end

    def current_user
      User.first || User.create!(email: "admin@example.com", password: "Password123!", password_confirmation: "Password123!")
    end
  end
end
