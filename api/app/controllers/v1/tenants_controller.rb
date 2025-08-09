module V1
  class TenantsController < ApplicationController
    include Pagy::Backend
    def index
      authorize Tenant
      pagy, records = pagy(Tenant.order(created_at: :desc))
      render json: { data: ActiveModelSerializers::SerializableResource.new(records, each_serializer: TenantSerializer), meta: { page: pagy.page, pages: pagy.pages, count: pagy.count } }
    end

    def show
      authorize tenant
      render json: { data: TenantSerializer.new(tenant) }
    end

    def create
      authorize Tenant
      record = Tenant.new(tenant_params)
      if record.save
        render json: { data: TenantSerializer.new(record) }, status: :created
      else
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      authorize tenant
      if tenant.update(tenant_params)
        render json: { data: TenantSerializer.new(tenant) }
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
