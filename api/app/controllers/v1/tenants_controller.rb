module V1
  class TenantsController < ApplicationController
    def index
      authorize Tenant
      render json: { data: Tenant.order(created_at: :desc) }
    end

    def show
      authorize tenant
      render json: { data: tenant }
    end

    def create
      authorize Tenant
      record = Tenant.new(tenant_params)
      if record.save
        render json: { data: record }, status: :created
      else
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      authorize tenant
      if tenant.update(tenant_params)
        render json: { data: tenant }
      else
        render json: { errors: tenant.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      authorize tenant
      tenant.destroy!
      head :no_content
    end

    private

    def tenant
      @tenant ||= Tenant.find(params[:id])
    end

    def tenant_params
      params.require(:tenant).permit(:full_name, :email, :phone)
    end
  end
end
