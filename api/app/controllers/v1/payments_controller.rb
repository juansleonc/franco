module V1
  class PaymentsController < ApplicationController
    include Pagy::Backend

    def index
      authorize Payment, :index?
      scope = Payment.order(received_on: :desc)
      pagy_obj, records = pagy(scope)
      render json: { data: ActiveModelSerializers::SerializableResource.new(records, each_serializer: PaymentSerializer), pagy: pagy_metadata(pagy_obj) }
    end

    def create
      payment = Payment.new(payment_params)
      authorize payment, :create?
      if payment.save
        render json: { data: PaymentSerializer.new(payment) }, status: :created
      else
        render json: { errors: payment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      payment = Payment.find(params[:id])
      authorize payment, :show?
      render json: { data: PaymentSerializer.new(payment) }
    end

    def update
      payment = Payment.find(params[:id])
      authorize payment, :update?
      if payment.update(payment_params)
        render json: { data: PaymentSerializer.new(payment) }
      else
        render json: { errors: payment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def payment_params
      params.require(:payment).permit(:tenant_id, :received_on, :amount_cents, :currency, :payment_method, :reference, :status)
    end

    def pagy_metadata(pagy)
      { page: pagy.page, items: pagy.items, pages: pagy.pages, count: pagy.count }
    end
  end
end
