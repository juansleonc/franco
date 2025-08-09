module V1
  class TenantsController < ApplicationController
    include Pagy::Backend
    def index
      authorize Tenant
      pagy, records = pagy(Tenant.order(created_at: :desc))
      render_collection(records, serializer: TenantSerializer, pagy: pagy)
    end

    def show
      authorize tenant
      render_resource(tenant, serializer: TenantSerializer)
    end

    def create
      authorize Tenant
      record = Tenant.new(tenant_params)
      if record.save
        render_resource(record, serializer: TenantSerializer, status: :created)
      else
        render_errors(record.errors.full_messages)
      end
    end

    def update
      authorize tenant
      if tenant.update(tenant_params)
        render_resource(tenant, serializer: TenantSerializer)
      else
        render_errors(tenant.errors.full_messages)
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
