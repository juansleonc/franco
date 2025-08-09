module V1
  class InvoicesController < ApplicationController
    include Pagy::Backend

    def index
      authorize Invoice, :index?
      scope = Invoice.order(issue_on: :desc)
      pagy_obj, records = pagy(scope)
      render_collection(records, serializer: InvoiceSerializer, pagy: pagy_obj)
    end

    def show
      invoice = Invoice.find(params[:id])
      authorize invoice, :show?
      render json: { data: InvoiceSerializer.new(invoice) }
    end

    private
    # metadata is provided by Renderable#render_collection
  end
end
