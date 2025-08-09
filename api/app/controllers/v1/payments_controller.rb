module V1
  class PaymentsController < ApplicationController
    include Pagy::Backend

    def index
      authorize Payment, :index?
      scope = Payment.order(received_on: :desc)
      pagy_obj, records = pagy(scope)
      render_collection(records, serializer: PaymentSerializer, pagy: pagy_obj)
    end

    def create
      payment = Payment.new(payment_params)
      authorize payment, :create?
      if payment.save
        render json: { data: PaymentSerializer.new(payment) }, status: :created
      else
        render_errors(payment.errors.full_messages)
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
        render_errors(payment.errors.full_messages)
      end
    end

    private

    def payment_params
      params.require(:payment).permit(:tenant_id, :received_on, :amount_cents, :currency, :payment_method, :reference, :status)
    end

    # metadata is provided by Renderable#render_collection
  end
end
