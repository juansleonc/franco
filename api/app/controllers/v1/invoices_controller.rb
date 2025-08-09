module V1
  class InvoicesController < ApplicationController
    include Pagy::Backend

    def index
      authorize Invoice, :index?
      scope = Invoice.order(issue_on: :desc)
      pagy_obj, records = pagy(scope)
      render json: { data: ActiveModelSerializers::SerializableResource.new(records, each_serializer: InvoiceSerializer), pagy: pagy_metadata(pagy_obj) }
    end

    def show
      invoice = Invoice.find(params[:id])
      authorize invoice, :show?
      render json: { data: InvoiceSerializer.new(invoice) }
    end

    private

    def pagy_metadata(pagy)
      { page: pagy.page, items: pagy.items, pages: pagy.pages, count: pagy.count }
    end
  end
end
